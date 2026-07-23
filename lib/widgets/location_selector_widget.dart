import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';

class LocationSelectorWidget extends StatefulWidget {
  const LocationSelectorWidget({super.key});

  @override
  State<LocationSelectorWidget> createState() => _LocationSelectorWidgetState();
}

class _LocationSelectorWidgetState extends State<LocationSelectorWidget> {
  String? selectedIso3;
  String? selectedSub;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final db = FirebaseFirestore.instance;
    final String lang = auth.currentLanguage;

    return Column(
      children: [
        _buildDropdown(
          label: "Select Country",
          entityType: 'country',
          stream: db
              .collection('countries')
              .where('isCountryOnboarded', isEqualTo: true)
              .snapshots(),
          value: selectedIso3,
          valueKey: 'country_iso3',
          lang: lang,
          onSelected: (val, name) => setState(() {
            selectedIso3 = val;
            selectedSub = null;
          }),
        ),
        const SizedBox(height: 16),
        if (selectedIso3 != null)
          _buildDropdown(
            label: "Select Region",
            entityType: 'subdivision',
            stream: db
                .collection('countries')
                .doc(selectedIso3!)
                .collection('subdivisions')
                .where('isSubdivisionOnboarded', isEqualTo: true)
                .snapshots(),
            value: selectedSub,
            valueKey: 'subdivision_code',
            lang: lang,
            onSelected: (val, name) => setState(() {
              selectedSub = val;
            }),
          ),
        const SizedBox(height: 16),
        if (selectedSub != null)
          _buildDropdown(
            label: "Select Local Town",
            entityType: 'town',
            stream: db
                .collection('countries')
                .doc(selectedIso3!)
                .collection('subdivisions')
                .doc(selectedSub!)
                .collection('towns')
                .orderBy('town_unicode')
                .snapshots(),
            value: null, // Always starts from scratch [User Query]
            valueKey: 'town_unicode',
            lang: lang,
            onSelected: (val, name) {
              auth.setSessionLocation(val, name);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String entityType,
    required Stream<QuerySnapshot> stream,
    required String? value,
    required String valueKey,
    required String lang,
    required Function(String, String) onSelected,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name =
                data['${entityType}_name_$lang'] ??
                data['${entityType}_name_en'] ??
                "Unknown";
            return DropdownMenuItem(
              value: data[valueKey] as String,
              child: Text(name),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              final doc = snapshot.data!.docs.firstWhere(
                (d) => d[valueKey] == val,
              );
              final data = doc.data() as Map<String, dynamic>;
              final name =
                  data['${entityType}_name_$lang'] ??
                  data['${entityType}_name_en'];
              onSelected(val, name);
            }
          },
        );
      },
    );
  }
}
