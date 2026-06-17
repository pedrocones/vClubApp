abstract class AbstractVolunteerService {
  /// Pulls available neighborhood public action slots
  Future<List<Map<String, dynamic>>> fetchOpenPositions();

  /// Enrolls user tracking record to a specific position identifier
  Future<bool> applyForPosition({
    required String userId,
    required String positionId,
  });

  /// Pulls upcoming assigned volunteer shifts for a user
  Future<List<Map<String, dynamic>>> fetchAssignedShifts(String userId);
}
