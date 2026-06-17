abstract class AVolunteering {
  Future<List<Map<String, dynamic>>> searchPositions({
    required String keyword,
    String? location,
  });
  Future<bool> applyForPosition({
    required String positionId,
    required String userId,
  });
}
