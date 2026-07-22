class ShadowCheckModel {
  final String username;
  final String email;

  ShadowCheckModel({
    required this.username,
    required this.email,
  });

  factory ShadowCheckModel.fromJson(Map<String, dynamic> json) => ShadowCheckModel(
    username: json['username'],
    email: json['email'],
  );
}