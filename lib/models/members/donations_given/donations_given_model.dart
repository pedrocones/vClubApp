import 'package:cloud_firestore/cloud_firestore.dart';

// <REGISTRY_ENUMS_START>
// <REGISTRY_ENUMS_END>

class DonationsGivenModel {
  // <REGISTRY_FIELDS_START>
  final String campaign_id;
  final String original_currency;
  final double fx_rate;
  final double amount_vcoin;
  final DateTime timestamp;
  // <REGISTRY_FIELDS_END>

  DonationsGivenModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.campaign_id,
    required this.original_currency,
    required this.fx_rate,
    required this.amount_vcoin,
    required this.timestamp,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory DonationsGivenModel.fromJson(Map<String, dynamic> json) => DonationsGivenModel(
    // <REGISTRY_FACTORY_START>
      campaign_id: json['campaign_id'] as String,
      original_currency: json['original_currency']?.toString() ?? 'vCoin',
      fx_rate: (json['fx_rate'] as num).toDouble(),
      amount_vcoin: (json['amount_vcoin'] as num).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    // <REGISTRY_FACTORY_END>
  );

  // Manual Composition Logic (Benefits/Roles/Rewards) stays here.
}
