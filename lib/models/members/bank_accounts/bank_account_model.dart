// <REGISTRY_ENUMS_START>
// <REGISTRY_ENUMS_END>

class BankAccountModel {
  // <REGISTRY_FIELDS_START>
  final String? owner_name;
  final String? bank_name;
  final String? bank_address;
  final String? bank_account_no;
  final double? bank_routing_no;
  final String? currency;
  final String? type;
  // <REGISTRY_FIELDS_END>

  BankAccountModel({
    // <REGISTRY_CONSTRUCTOR_START>
    this.owner_name,
    this.bank_name,
    this.bank_address,
    this.bank_account_no,
    this.bank_routing_no,
    this.currency,
    this.type,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      BankAccountModel(
        // <REGISTRY_FACTORY_START>
      owner_name: json['owner_name'] as String?,
      bank_name: json['bank_name'] as String?,
      bank_address: json['bank_address'] as String?,
      bank_account_no: json['bank_account_no'] as String?,
      bank_routing_no: (json['bank_routing_no'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      type: json['type'] as String?,
    // <REGISTRY_FACTORY_END>
      );

  // Manual Composition Logic (Benefits/Roles/Rewards) stays here.
}
