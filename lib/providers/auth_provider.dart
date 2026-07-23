import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/members/member_model.dart';

class AppAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late MemberModel _member;
  User? _firebaseUser; // Track the Firebase User state [Conversation History]
  bool _isLoading = false;

  // Session-specific fields [User Logic]
  String _referralId = "admin_L1";
  String _sessionLanguage = "en";
  String _sessionTownUnicode = "US-CA-M0180";
  String _sessionTownName = "Marina del Rey";

  AppAuthProvider() {
    _member = _createDefaultGuest();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // Getters
  bool get isLoggedIn => _firebaseUser != null;
  MemberModel get member => _member;
  bool get isLoading => _isLoading;
  String get currentLanguage => _sessionLanguage;
  String get sessionTownUnicode => _sessionTownUnicode;
  String get sessionTownName => _sessionTownName;

  /// Synchronously decodes URL: "id;unicode;name;lang" [User Logic]
  void initializeReferral(String? rawLink) {
    if (rawLink == null || rawLink.isEmpty || rawLink == 'admin_L0') {
      _applyGuestDefaults();
      return;
    }
    try {
      final List<String> parts = rawLink.split(';');
      if (parts.length >= 3) {
        // FIX: Access by index then trim [User Logic]
        _referralId = parts[0].trim();
        _sessionTownUnicode = parts[1].trim();
        _sessionTownName = parts[2].trim();
        if (parts.length > 3) _sessionLanguage = parts[3].trim();

        debugPrint(
          "🔗 SESSION_INIT: Hub set to $_sessionTownName ($_sessionTownUnicode)",
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("⚠️ SESSION_INIT_ERR: $e");
      _applyGuestDefaults();
    }
  }

  void _applyGuestDefaults() {
    _referralId = "admin_L1";
    _sessionLanguage = "en";
    _sessionTownUnicode = "US-CA-M0180";
    _sessionTownName = "Marina del Rey";
    notifyListeners();
  }

  void setSessionLocation(String unicode, String localizedName) {
    _sessionTownUnicode = unicode;
    _sessionTownName = localizedName;
    notifyListeners();
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _db.collection('members').doc(cred.user!.uid).set({
        "member_id": cred.user!.uid,
        "email": email,
        "town_unicode": _sessionTownUnicode,
        "member_status": "Rookie",
        "reward_tree": {
          "recruiter_id": _referralId,
          "coach_id": _referralId,
          "mentor_id": "admin_L2",
          "master_id": "admin_L3",
        },
        "member_profile": {"is_anonymous": true, "language": _sessionLanguage},
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MemberModel _createDefaultGuest() {
    return MemberModel(
      member_id: 'GUEST_admin_L0',
      username: 'admin_L0',
      email: 'visitor@vicinum.org',
      town_unicode: 'US-CA-M0180',
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

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user; // Update the tracking variable [Conversation History]

    if (user == null) {
      _member = _createDefaultGuest();
    } else {
      // Upon login, sync the permanent member record to the global state
      final doc = await _db.collection('members').doc(user.uid).get();
      if (doc.exists) {
        _member = MemberModel.fromJson(doc.data()!);
        _sessionLanguage = _member.member_profile['language'] ?? 'en';
        _sessionTownUnicode = _member.town_unicode;
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      debugPrint("🔍 AUTH_TRACE: Initiating logout...");
      await _auth.signOut();

      // Revert all session state to Guest defaults
      _applyGuestDefaults();

      notifyListeners(); // Updates TopBar and Navigation immediately
      debugPrint(
        "✅ AUTH_TRACE: Logout successful. System reset to GUEST_admin_L0.",
      );
    } catch (e) {
      debugPrint("❌ AUTH_TRACE: Logout error: $e");
    }
  }

  void updateLanguage(String langCode) {
    _sessionLanguage = langCode;
    notifyListeners(); // Triggers UI to refresh translations (e.g., in Location Widget)
    debugPrint("🌐 LANG_TRACE: Session language updated to: $langCode");
  }
}
