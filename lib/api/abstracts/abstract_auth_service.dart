abstract class AbstractAuthService {
  /// Watches the current authentication state stream
  Stream<String?> get onAuthStateChanged;

  /// Retrieves the currently authenticated User ID or null
  String? get currentUserId;

  /// Registers a brand new user profile credentials matrix
  Future<String> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Validates user profile parameters against access credentials
  Future<String> signInWithEmail({
    required String email,
    required String password,
  });

  /// Clears active system platform tokenized session traces
  Future<void> signOut();
}
