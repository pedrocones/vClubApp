// <REGISTRY_ENUMS_START>
enum MemberStatus { rookie, ambassador, associated, overdue, banned }
// <REGISTRY_ENUMS_END>

class MemberModel {
  // <REGISTRY_FIELDS_START>
  final String member_id;
  final String? username;
  final String email;
  final String town_unicode;
  final MemberStatus member_status;
  final double vcoin_balance;
  final Map<String, dynamic> reward_tree;
  final Map<String, dynamic> member_profile;
  // <REGISTRY_FIELDS_END>

  MemberModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.member_id,
    this.username,
    required this.email,
    required this.town_unicode,
    required this.member_status,
    required this.vcoin_balance,
    required this.reward_tree,
    required this.member_profile,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
    // <REGISTRY_FACTORY_START>
      member_id: json['member_id'] as String,
      username: json['username'] as String?,
      email: json['email'] as String,
      town_unicode: json['town_unicode'] as String,
      member_status: MemberStatus.values.firstWhere((e) => e.name == json['member_status'].toString().toLowerCase(), orElse: () => MemberStatus.rookie),
      vcoin_balance: (json['vcoin_balance'] as num).toDouble(),
      reward_tree: (json['reward_tree'] as Map<String, dynamic>?) ?? {'recruiter_id': 'admin_L1', 'coach_id': 'admin_L1', 'mentor_id': 'admin_L2', 'master_id': 'admin_L3'},
      member_profile: (json['member_profile'] as Map<String, dynamic>?) ?? {'is_anonymous': false, 'language': 'en'},
    // <REGISTRY_FACTORY_END>
  );

  // Manual Composition Logic (Benefits/Roles/Rewards) stays here.
}
