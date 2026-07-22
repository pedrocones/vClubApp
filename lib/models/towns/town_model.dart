// <REGISTRY_ENUMS_START>
// <REGISTRY_ENUMS_END>

// ignore_for_file: non_constant_identifier_names

class TownModel {
  // <REGISTRY_FIELDS_START>
  final String town_unicode;
  final String subdivision_code;
  final String town_name_local;
  final String town_name_en;
  final String? town_name_es;
  final String? town_name_fr;
  final String? town_name_hi;
  final String? town_name_ar;
  final String? town_name_zn;
  final int? town_population;
  final double? latitude;
  final double? longitude;
  // <REGISTRY_FIELDS_END>

  TownModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.town_unicode,
    required this.subdivision_code,
    required this.town_name_local,
    required this.town_name_en,
    this.town_name_es,
    this.town_name_fr,
    this.town_name_hi,
    this.town_name_ar,
    this.town_name_zn,
    this.town_population,
    this.latitude,
    this.longitude,
    // <REGISTRY_CONSTRUCTOR_END>
  });

  factory TownModel.fromJson(Map<String, dynamic> json) => TownModel(
    // <REGISTRY_FACTORY_START>
      town_unicode: json['town_unicode'] as String,
      subdivision_code: json['subdivision_code'] as String,
      town_name_local: json['town_name_local'] as String,
      town_name_en: json['town_name_en'] as String,
      town_name_es: json['town_name_es'] as String?,
      town_name_fr: json['town_name_fr'] as String?,
      town_name_hi: json['town_name_hi'] as String?,
      town_name_ar: json['town_name_ar'] as String?,
      town_name_zn: json['town_name_zn'] as String?,
      town_population: json['town_population'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    // <REGISTRY_FACTORY_END>
  );
}
