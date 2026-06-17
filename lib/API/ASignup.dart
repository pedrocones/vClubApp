// abstract class for creating API exposing methods
//Overriting methods implemented in the backend. either google cloud functions or future dedicated server
abstract class ASignup {
  Future<bool> registerUser({
    required String email,
    required String password,
    required Map<String, dynamic> profileData,
  });
  Future<bool> verifyEmail(String email);
}
