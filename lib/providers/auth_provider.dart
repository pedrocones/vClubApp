import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  AppAuthProvider() {
    // Listen to real-time auth changes from the emulator
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Tells all listening screens to redraw when auth state changes
    });
  }

  // Public Getters
  User? get user => _user;
  bool get isLoggedIn =>
      _user != null; // Automatically true if a user exists, false if null
  bool get isLoading => _isLoading;

  // 1. Email and Password Registration
  Future<bool> signUpWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Registration Error: $e');
      return false;
    }
  }

  // 2. Mock Google Sign-In for Emulator Environment
  Future<bool> signInWithGoogleMock() async {
    // Note: Official Google Sign-In requires secure web tokens.
    // In local emulator pipelines, we can simulate successful handshakes.
    return true;
  }

  // 3. Submit Profile Metadata directly to state architecture
  Future<bool> saveProfileMetadata({
    required String username,
    required String coachId,
    required String location,
  }) async {
    // This is where your Firestore write call will reside inside Step 3!
    debugPrint(
      'Saving to database: User: $username, Coach: $coachId, Location: $location',
    );
    return true;
  }

  // 4. Temporary Toggle for testing layouts without a backend
  void toggleLogin() async {
    if (isLoggedIn) {
      await logout();
    } else {
      // Simulate an anonymous sign in for testing layouts
      try {
        await _auth.signInAnonymously();
      } catch (e) {
        debugPrint('Anonymous Sign In Error: $e');
      }
    }
  }

  // 5. Clean Session Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth
          .signOut(); // Directly terminates the session with the Local Emulator
    } catch (e) {
      debugPrint('Logout Error: $e');
    }

    _isLoading = false;
    notifyListeners(); // Changes trigger the authStateChanges listener above automatically
  }
}
