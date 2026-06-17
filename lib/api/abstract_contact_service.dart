abstract class AbstractContactService {
  /// Dispatches contact or support requests
  Future<bool> sendContactInquiry({
    required String name,
    required String category,
    required String message,
    String? attachmentPath,
  });
}
