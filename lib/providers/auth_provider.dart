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

  // Session state initialized to GUEST_admin_L0 defaults [801, Conversation History]
  String _referralId = "admin_L1";
  late String _currentLanguage;
  late String _sessionTownUnicode;
  late String _sessionTownName;

  AppAuthProvider() {
    _applyGuestDefaults();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // Getters
  MemberModel get member => _member;
  bool get isLoggedIn => _firebaseUser != null;
  bool get isLoading => _isLoading;
  String get currentLanguage => _currentLanguage;
  String get sessionTownUnicode => _sessionTownUnicode;
  String get sessionTownName => _sessionTownName;

  void _applyGuestDefaults() {
    _member = _createDefaultGuest();
    _referralId = "admin_L1";
    _currentLanguage = 'en';
    _sessionTownUnicode = 'US-CA-M0180';
    _sessionTownName = "Marina del Rey";
  }

  /// Synchronously decodes URL: "id;unicode;name;lang" [User Query]
  void initializeReferral(String? rawLink) {
    if (rawLink == null || rawLink.isEmpty || rawLink == 'admin_L0') {
      _applyGuestDefaults();
    } else {
      try {
        final parts = rawLink.split(';');
        if (parts.length >= 3) {
          _referralId = parts[0].trim();
          _sessionTownUnicode = parts[1].trim();
          _sessionTownName = parts[2].trim();
          if (parts.length > 3) _currentLanguage = parts[3].trim();
          debugPrint(
            "🔗 REF_TRACE: Decoded -> ID: $_referralId, Hub: $_sessionTownName",
          );
        }
      } catch (e) {
        debugPrint("⚠️ REF_TRACE: Decoding error, using defaults.");
        _applyGuestDefaults();
      }
    }
    notifyListeners();
  }

  void setSessionLocation(String unicode, String localizedName) {
    _sessionTownUnicode = unicode;
    _sessionTownName = localizedName;
    notifyListeners();
  }

  void updateLanguage(String langCode) {
    _currentLanguage = langCode;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _applyGuestDefaults();
    notifyListeners();
  }

  /// Final Sign-Up: Commits session state to Registry v3 [801, Conversation History]
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
        "username": null,
        "town_unicode": _sessionTownUnicode,
        "member_status": "Rookie",
        "vcoin_balance": 0.0,
        "reward_tree": {
          "recruiter_id": _referralId,
          "coach_id": _referralId,
          "mentor_id": "admin_L2",
          "master_id": "admin_L3",
        },
        "member_profile": {"is_anonymous": true, "language": _currentLanguage},
      });
      return true;
    } catch (e) {
      debugPrint("❌ SIGNUP_TRACE: $e");
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
    _firebaseUser = user;
    if (user != null) {
      final doc = await _db.collection('members').doc(user.uid).get();
      if (doc.exists) {
        _member = MemberModel.fromJson(doc.data()!);
        _currentLanguage = _member.member_profile['language'] ?? 'en';
      }
    } else {
      _applyGuestDefaults();
    }
    notifyListeners();
  }
}
