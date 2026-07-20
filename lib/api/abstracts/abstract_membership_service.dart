abstract class AbstractMembershipService {
  /// Pulls catalog tiers parameters
  Future<List<Map<String, dynamic>>> fetchMembershipTiers();

  /// Modifies active tier parameters matching account profile indices
  Future<bool> purchaseMembership({
    required String userId,
    required String tierId,
  });

  /// Tracks active subscription status validation keys
  Future<Map<String, dynamic>?> fetchActiveMembership(String userId);
}
