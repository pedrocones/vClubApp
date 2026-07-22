import 'package:cloud_firestore/cloud_firestore.dart';

// <REGISTRY_ENUMS_START>
// <REGISTRY_ENUMS_END>

class VolunteeringHourModel {
  // <REGISTRY_FIELDS_START>
  final String opportunity_id;
  final String opportunitty_title;
  final dynamic opportunitty_description;
  final double? hours;
  final DateTime? date;
  // <REGISTRY_FIELDS_END>

  VolunteeringHourModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.opportunity_id,
    required this.opportunitty_title,
    this.opportunitty_description,
    this.hours,
    this.date,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory VolunteeringHourModel.fromJson(Map<String, dynamic> json) => VolunteeringHourModel(
    // <REGISTRY_FACTORY_START>
      opportunity_id: json['opportunity_id'] as String,
      opportunitty_title: json['opportunitty_title']?.toString() ?? 'Opportunitties Require a descriptive title',
      opportunitty_description: json['opportunitty_description'] as String?,
      hours: (json['hours'] as num?)?.toDouble(),
      date: json['date'] != null ? (json['date'] as Timestamp).toDate() : null,
    // <REGISTRY_FACTORY_END>
  );

  // Manual Composition Logic (Benefits/Roles/Rewards) stays here.
}
