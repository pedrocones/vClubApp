import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/members/member_model.dart';

class AppAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late MemberModel _member;

  User? _firebaseUser;
  bool _isLoading = false;

  // 1. Session-only language state
  late String _currentLanguage;
  String get currentLanguage => _currentLanguage;

  AppAuthProvider() {
    _member = _createDefaultGuest(); // Initialize as GUEST_admin_L0
    // Initialize session language from the member profile (default 'en') [1]
    _currentLanguage = _member.member_profile['language'] ?? 'en';

    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // 2. Resolve Compiler Error: Define updateLanguage
  void updateLanguage(String langCode) {
    _currentLanguage = langCode;
    debugPrint(
      "🔍 AUTH_TRACE: Session language updated to $langCode (Not synced to DB)",
    );
    notifyListeners(); // Triggers UI update across the app
  }

  // Getters
  MemberModel get member => _member;
  bool get isLoggedIn => _firebaseUser != null;
  bool get isLoading => _isLoading;

  // Entry Point for all visitors [Conversation History]
  MemberModel _createDefaultGuest() {
    return MemberModel(
      member_id: 'GUEST_admin_L0',
      username: 'admin_L0',
      email: 'visitor@vicinum.org',
      town_unicode: 'US-CA-M0180', // Default visitor routing
      member_status: MemberStatus.rookie,
      vcoin_balance: 0.0,
      reward_tree: {
        'recruiter_id': 'admin_L1',
        'coach_id': 'admin_L1',
        'mentor_id': 'admin_L2',
        'master_id': 'admin_L3',
      },
      member_profile: {'is_anonymous': true, 'language': 'en'},
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
    _member = _createDefaultGuest();
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user == null) {
      _member = _createDefaultGuest();
    } else {
      await _fetchMemberData(user.uid);
    }
    notifyListeners();
  }

  Future<void> _fetchMemberData(String uid) async {
    try {
      final doc = await _db.collection('members').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        _member = MemberModel.fromJson(doc.data()!);
        // Sync temporary session to their saved preference upon login [Conversation History]
        _currentLanguage = _member.member_profile['language'] ?? 'en';
        debugPrint(
          "✅ AUTH_TRACE: Profile loaded. Session language sync'd to: $_currentLanguage",
        );
      } else {
        _member = _createDefaultGuest();
        _currentLanguage = 'en'; // Fallback for Guest
      }
    } catch (e) {
      debugPrint("❌ AUTH_TRACE: Error fetching member: $e");
      _member = _createDefaultGuest();
    }
    notifyListeners(); // Forces Top Bar and Widget to rebuild with the correct flag
  }

  // Email-First Signup Logic [Conversation History, 807]
  // Inside AppAuthProvider class
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String townUnicode, // Captured from UI Widget
    String? recruiterID, // Captured from Referral Link
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = credential.user!.uid;
      // If no referral link, default back to admin_L1 as the anchor
      final String activeRecruiter = recruiterID ?? "admin_L1";

      // Initialize Firestore record with real captured data [1]
      await _db.collection('members').doc(uid).set({
        "member_id": uid,
        "email": email,
        "username": null, // Username remains a Stage 2 decorator
        "town_unicode": townUnicode, // Dynamically set from UI
        "member_status": "Rookie",
        "vcoin_balance": 0.0,
        "reward_tree": {
          "recruiter_id": activeRecruiter,
          "coach_id": activeRecruiter, // Initially same as recruiter [3]
          "mentor_id": "admin_L2", // Inherited parent anchors
          "master_id": "admin_L3",
        },
        "member_profile": {"is_anonymous": true, "language": "en"},
      });

      return true;
    } catch (e) {
      debugPrint("❌ SIGNUP_ERROR: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
