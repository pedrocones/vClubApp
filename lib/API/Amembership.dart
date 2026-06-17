// abstract class for creating API exposing methods
//Overriting methods implemented in the backend. either google cloud functions or future dedicated server
abstract class AMembership {
  Future<bool> purchaseMembership({
    required String planId,
    required String userId,
  });
  Future<Map<String, dynamic>> getMembershipStatus(String userId);
}
