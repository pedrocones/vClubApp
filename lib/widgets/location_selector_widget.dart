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
  String? selectedTownUnicode;
  String? selectedTownName;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final db = FirebaseFirestore.instance;
    final String lang = auth.currentLanguage;

    return Column(
      children: [
        _buildDropdown(
          label: "Country",
          entity: 'country',
          valueKey: 'country_iso3',
          stream: db
              .collection('countries')
              .where('isCountryOnboarded', isEqualTo: true)
              .snapshots(),
          value: selectedIso3,
          lang: lang,
          onChanged: (val, name) => setState(() {
            selectedIso3 = val;
            selectedSub = null;
            selectedTownUnicode = null;
          }),
        ),
        const SizedBox(height: 12),
        if (selectedIso3 != null)
          _buildDropdown(
            label: "Region",
            entity: 'subdivision',
            valueKey: 'subdivision_code',
            stream: db
                .collection('countries')
                .doc(selectedIso3!)
                .collection('subdivisions')
                .where('isSubdivisionOnboarded', isEqualTo: true)
                .snapshots(),
            value: selectedSub,
            lang: lang,
            onChanged: (val, name) => setState(() {
              selectedSub = val;
              selectedTownUnicode = null;
            }),
          ),
        const SizedBox(height: 12),
        if (selectedSub != null)
          _buildDropdown(
            label: "Town",
            entity: 'town',
            valueKey: 'town_unicode',
            stream: db
                .collection('countries')
                .doc(selectedIso3!)
                .collection('subdivisions')
                .doc(selectedSub!)
                .collection('towns')
                .orderBy('town_unicode')
                .snapshots(),
            value: selectedTownUnicode,
            lang: lang,
            onChanged: (val, name) => setState(() {
              selectedTownUnicode = val;
              selectedTownName = name;
            }),
          ),
        const Spacer(),
        if (selectedTownUnicode != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
            ),
            onPressed: () {
              auth.setSessionLocation(selectedTownUnicode!, selectedTownName!);
              Navigator.pop(context);
            },
            child: const Text("CONFIRM ANCHORING"),
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String entity,
    required String valueKey,
    required Stream<QuerySnapshot> stream,
    required String? value,
    required String lang,
    required Function(String, String) onChanged,
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
                data['${entity}_name_$lang'] ??
                data['${entity}_name_en'] ??
                "Unknown";
            return DropdownMenuItem(
              value: data[valueKey] as String,
              child: Text(name),
            );
          }).toList(),
          onChanged: (val) {
            if (val == null) return;
            final doc = snapshot.data!.docs.firstWhere(
              (d) => d[valueKey] == val,
            );
            final name =
                (doc.data() as Map<String, dynamic>)['${entity}_name_$lang'] ??
                "Unknown";
            onChanged(val, name);
          },
        );
      },
    );
  }
}
