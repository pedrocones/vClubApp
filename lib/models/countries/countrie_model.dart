// <REGISTRY_ENUMS_START>
// <REGISTRY_ENUMS_END>

// ignore_for_file: non_constant_identifier_names

class CountrieModel {
  // <REGISTRY_FIELDS_START>
  final String country_iso2;
  final String country_iso3;
  final String country_name_local;
  final String country_name_en;
  final String? country_name_es;
  final String? country_name_fr;
  final String? country_name_hi;
  final String? country_name_ar;
  final String? country_name_zn;
  final bool? isCountryOnboarded;
  // <REGISTRY_FIELDS_START>

  CountrieModel({
    // <REGISTRY_CONSTRUCTOR_START>
    required this.country_iso2,
    required this.country_iso3,
    required this.country_name_local,
    required this.country_name_en,
    this.country_name_es,
    this.country_name_fr,
    this.country_name_hi,
    this.country_name_ar,
    this.country_name_zn,
    this.isCountryOnboarded,
    // <REGISTRY_CONSTRUCTOR_START>
  });

  factory CountrieModel.fromJson(Map<String, dynamic> json) => CountrieModel(
    // <REGISTRY_FACTORY_START>
      country_iso2: json['country_iso2'] as String,
      country_iso3: json['country_iso3'] as String,
      country_name_local: json['country_name_local'] as String,
      country_name_en: json['country_name_en'] as String,
      country_name_es: json['country_name_es'] as String?,
      country_name_fr: json['country_name_fr'] as String?,
      country_name_hi: json['country_name_hi'] as String?,
      country_name_ar: json['country_name_ar'] as String?,
      country_name_zn: json['country_name_zn'] as String?,
      isCountryOnboarded: json['isCountryOnboarded'] as bool?,
    // <REGISTRY_FACTORY_END>
  );

  // Manual Composition Logic (Benefits Map/Reward Tree) goes below.
}
