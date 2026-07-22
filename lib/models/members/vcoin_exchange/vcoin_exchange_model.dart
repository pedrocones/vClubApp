import 'package:cloud_firestore/cloud_firestore.dart';

// <REGISTRY_ENUMS_START>
enum TransactionType { credit, debit }
// <REGISTRY_ENUMS_END>

class VcoinExchangeModel {
  // <REGISTRY_FIELDS_START>
  final double amount;
  final double fx_rate;
  final String original_currency;
  final String source;
  final String destination;
  final String destination_currency;
  final TransactionType transaction_type;
  final String? reference;
  final DateTime created_at;
  // <REGISTRY_FIELDS_END>

  VcoinExchangeModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.amount,
    required this.fx_rate,
    required this.original_currency,
    required this.source,
    required this.destination,
    required this.destination_currency,
    required this.transaction_type,
    this.reference,
    required this.created_at,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory VcoinExchangeModel.fromJson(Map<String, dynamic> json) => VcoinExchangeModel(
    // <REGISTRY_FACTORY_START>
      amount: (json['amount'] as num).toDouble(),
      fx_rate: (json['fx_rate'] as num).toDouble(),
      original_currency: json['original_currency']?.toString() ?? 'vCoin',
      source: json['source'] as String,
      destination: json['destination'] as String,
      destination_currency: json['destination_currency']?.toString() ?? 'vCoin',
      transaction_type: TransactionType.values.firstWhere((e) => e.name == json['transaction_type'].toString().toLowerCase()),
      reference: json['reference'] as String?,
      created_at: (json['created_at'] as Timestamp).toDate(),
    // <REGISTRY_FACTORY_END>
  );
}