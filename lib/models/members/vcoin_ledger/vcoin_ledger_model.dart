import 'package:cloud_firestore/cloud_firestore.dart';

// <REGISTRY_ENUMS_START>
enum TransactionType { credit, debit }
// <REGISTRY_ENUMS_END>

class VcoinLedgerModel {
  // <REGISTRY_FIELDS_START>
  final double amount;
  final String source;
  final TransactionType transaction_type;
  final String? reference;
  final DateTime created_at;
  // <REGISTRY_FIELDS_END>

  VcoinLedgerModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.amount,
    required this.source,
    required this.transaction_type,
    this.reference,
    required this.created_at,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory VcoinLedgerModel.fromJson(Map<String, dynamic> json) => VcoinLedgerModel(
    // <REGISTRY_FACTORY_START>
      amount: (json['amount'] as num).toDouble(),
      source: json['source'] as String,
      transaction_type: TransactionType.values.firstWhere((e) => e.name == json['transaction_type'].toString().toLowerCase()),
      reference: json['reference'] as String?,
      created_at: (json['created_at'] as Timestamp).toDate(),
    // <REGISTRY_FACTORY_END>
  );
}