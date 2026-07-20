import 'dart:developer' as dev;
import 'abstract_contact_service.dart';

class MockContactService implements AbstractContactService {
  @override
  Future<bool> sendContactInquiry({
    required String name,
    required String category,
    required String message,
    String? attachmentPath,
  }) async {
    // 1. Simulate API connection round-trip latency
    await Future.delayed(const Duration(milliseconds: 500));

    // 2. Dump transaction data to the local terminal environment
    dev.log(
      '=== LOCAL CONTACT US GATEWAY INTERACTION ===',
      name: 'vicinum.api',
    );
    dev.log(
      'Target Mail Relay Address: vicinumclub@gmail.com',
      name: 'vicinum.api',
    );
    dev.log('Sender Label: $name', name: 'vicinum.api');
    dev.log('Selected Category Track: $category', name: 'vicinum.api');
    dev.log('Payload Content String: $message', name: 'vicinum.api');
    dev.log(
      'Attachment Verification Path: ${attachmentPath ?? "None Assigned"}',
      name: 'vicinum.api',
    );
    dev.log(
      '============================================',
      name: 'vicinum.api',
    );

    return true; // Successfully handles local tracking sequence simulation
  }
}
