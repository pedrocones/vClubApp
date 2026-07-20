import 'dart:async';
import 'abstract_donate_service.dart';

class MockDonateService implements AbstractDonateService {
  // Simulates a Firestore "donations" collection array registry
  final List<Map<String, dynamic>> _inMemoryDonationsTable = [
    {
      'id': 'TX-9081',
      'userId': 'user_abc',
      'amount': 25.00,
      'date': '2026-06-10',
      'notes': 'Keep up the excellent neighborhood cleanup work!',
    },
  ];

  @override
  Future<bool> processDonation({
    required String userId,
    required double amount,
    required String paymentMethodId,
    String? notes,
  }) async {
    // 1. Simulate server roundtrip delay lag
    await Future.delayed(const Duration(milliseconds: 600));

    // 2. Simulate Firestore document generation and write operations
    final newRecord = {
      'id':
          'TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'userId': userId,
      'amount': amount,
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'notes': notes ?? '',
    };

    _inMemoryDonationsTable.add(newRecord);
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchDonationHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Simulates an indexed where() query parameter filtering out records matching userId
    return _inMemoryDonationsTable
        .where((doc) => doc['userId'] == userId)
        .toList();
  }
}
