// <REGISTRY_ENUMS_START>
// <REGISTRY_ENUMS_END>

// ignore_for_file: non_constant_identifier_names

class SubdivisionModel {
  // <REGISTRY_FIELDS_START>
  final String subdivision_code;
  final String country_iso3;
  final String subdivision_name_local;
  final String subdivision_name_en;
  final String? subdivision_name_es;
  final String? subdivision_name_fr;
  final String? subdivision_name_hi;
  final String? subdivision_name_ar;
  final String subdivision_category;
  final bool? isSubdivisionOnboarded;
  // <REGISTRY_FIELDS_END>

  SubdivisionModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.subdivision_code,
    required this.country_iso3,
    required this.subdivision_name_local,
    required this.subdivision_name_en,
    this.subdivision_name_es,
    this.subdivision_name_fr,
    this.subdivision_name_hi,
    this.subdivision_name_ar,
    required this.subdivision_category,
    this.isSubdivisionOnboarded,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory SubdivisionModel.fromJson(Map<String, dynamic> json) =>
      SubdivisionModel(
        // <REGISTRY_FACTORY_START>
      subdivision_code: json['subdivision_code'] as String,
      country_iso3: json['country_iso3'] as String,
      subdivision_name_local: json['subdivision_name_local'] as String,
      subdivision_name_en: json['subdivision_name_en'] as String,
      subdivision_name_es: json['subdivision_name_es'] as String?,
      subdivision_name_fr: json['subdivision_name_fr'] as String?,
      subdivision_name_hi: json['subdivision_name_hi'] as String?,
      subdivision_name_ar: json['subdivision_name_ar'] as String?,
      subdivision_category: json['subdivision_category'] as String,
      isSubdivisionOnboarded: json['isSubdivisionOnboarded'] as bool?,
    // <REGISTRY_FACTORY_END>
      );
}
