abstract class AbstractProfileService {
  /// Pulls individual user profile parameter maps
  Future<Map<String, dynamic>> fetchUserProfile(String userId);

  /// Overwrites profile fields (Name, Avatar metadata)
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  });

  /// Pulls core local application configuration choices
  Future<Map<String, dynamic>> fetchUserSettings(String userId);

  /// Saves local feature options flags (Theme mode, Language keys)
  Future<void> updateUserSettings({
    required String userId,
    required Map<String, dynamic> settingsData,
  });
}
