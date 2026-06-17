import 'abstract_auth_service.dart';
import 'abstract_donate_service.dart';
import 'abstract_contact_service.dart';
import 'mock_contact_service.dart';

// Complete mock definitions used globally for manual injections
class MockAuthService implements AbstractAuthService {
  String? _cachedUserId;

  @override
  Stream<String?> get onAuthStateChanged => Stream.value(_cachedUserId);

  @override
  String? get currentUserId => _cachedUserId;

  @override
  Future<String> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cachedUserId = 'usr_mock_12345';
    return _cachedUserId!;
  }

  @override
  Future<String> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cachedUserId = 'usr_mock_12345';
    return _cachedUserId!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cachedUserId = null;
  }
}

class MockDonateService implements AbstractDonateService {
  final List<Map<String, dynamic>> _mockDatabaseTable = [
    {
      'id': 'TX-101',
      'userId': 'usr_mock_12345',
      'amount': 50.0,
      'date': '2026-05-01',
      'notes': 'Initial Support',
    },
  ];

  @override
  Future<bool> processDonation({
    required String userId,
    required double amount,
    required String paymentMethodId,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _mockDatabaseTable.add({
      'id':
          'TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      'userId': userId,
      'amount': amount,
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'notes': notes ?? '',
    });
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchDonationHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockDatabaseTable.where((doc) => doc['userId'] == userId).toList();
  }
}

// 1. Instantiating singletons for easy global testing access
final testAuthAPI = MockAuthService();
final testDonateAPI = MockDonateService();
final testContactAPI = MockContactService();
