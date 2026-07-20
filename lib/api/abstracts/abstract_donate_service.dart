abstract class AbstractDonateService {
  /// Dispatches a unique financial donation tracking block
  Future<bool> processDonation({
    required String userId,
    required double amount,
    required String paymentMethodId,
    String? notes,
  });

  /// Pulls previous logged historical transactional records
  Future<List<Map<String, dynamic>>> fetchDonationHistory(String userId);
}
