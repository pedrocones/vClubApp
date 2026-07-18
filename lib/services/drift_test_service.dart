// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriftTestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Ingests a small scoped test payload directly into the active emulator tree
  Future<void> simulateRegistryDriftAndCheck() async {
    print('🔄 Starting Sandbox Multi-Tier Drift Verification Sequence...');

    // Mock payload with updates to simulate live registry updates
    // Notice that "ORL" has indicator 'X' (deprecated), and "MIA" has indicator '#' (modified name)
    const String simulatedApiPayload = '''
    [
      {"Country": "US", "Location": "LAX", "Name": "Los Angeles Intl Airport", "Subdivision": "CA", "Ch": "", "Function": "14", "Status": "AI", "Date": "0307", "IATA": "LAX", "Coordinates": "3356N 11824W"},
      {"Country": "US", "Location": "MIA", "Name": "Miami Port and Terminal", "Subdivision": "FL", "Ch": "#", "Function": "15", "Status": "AI", "Date": "0512", "IATA": "MIA", "Coordinates": "2547N 08011W"},
      {"Country": "US", "Location": "SFO", "Name": "San Francisco Bay", "Subdivision": "CA", "Ch": "+", "Function": "1", "Status": "AI", "Date": "2106", "IATA": "SFO", "Coordinates": "3737N 12222W"},
      {"Country": "US", "Location": "ORL", "Name": "Orlando Substation", "Subdivision": "FL", "Ch": "X", "Function": "3", "Status": "AI", "Date": "2004", "IATA": "ORL", "Coordinates": "2832N 08122W"}
    ]
    ''';

    final List<dynamic> remoteDataList = json.decode(simulatedApiPayload);
    List<String> deviationReports = [];
    WriteBatch batch = _firestore.batch();
    int updateCounter = 0;

    for (var row in remoteDataList) {
      final String country = (row['Country'] ?? '')
          .toString()
          .trim()
          .toUpperCase();
      final String subdivision = (row['Subdivision'] ?? '')
          .toString()
          .trim()
          .toUpperCase();
      final String locationCode = (row['Location'] ?? '')
          .toString()
          .trim()
          .toUpperCase();
      final String unLocodeKey = '$country$subdivision$locationCode';
      final String changeIndicator = (row['Ch'] ?? '').toString().trim();

      bool nativelyFlaggedChanged =
          changeIndicator == '+' ||
          changeIndicator == '#' ||
          changeIndicator == 'X';

      // Target Path Structure: /un_locodes/{country}/states/{state}/towns/{town}
      final DocumentReference townDocRef = _firestore
          .collection('un_locodes')
          .doc(country)
          .collection('states')
          .doc(subdivision)
          .collection('towns')
          .doc(locationCode);

      final DocumentSnapshot townSnapshot = await townDocRef.get();

      if (!townSnapshot.exists) {
        deviationReports.add(
          '[NEW ENTRY] Code: $unLocodeKey | Indicator: $changeIndicator',
        );
        batch.set(
          townDocRef,
          _buildTownMap(
            row,
            unLocodeKey,
            locationCode,
            isChanged: true,
            active: changeIndicator != 'X',
          ),
          SetOptions(merge: true),
        );
        updateCounter++;
      } else {
        final currentData = townSnapshot.data() as Map<String, dynamic>;
        final String pastIndicator = currentData['nativeChangeIndicator'] ?? '';

        bool attributesChanged =
            currentData['nameNative'] != row['Name'] ||
            pastIndicator != changeIndicator;

        if (nativelyFlaggedChanged || attributesChanged) {
          deviationReports.add(
            '[DRIFT DETECTED] Key: $unLocodeKey | Fresh Indicator: "$changeIndicator"',
          );

          batch.set(townDocRef, {
            'nativeChangeIndicator': changeIndicator,
            'isRecordChanged': true, // Flagged for Admin View
            'isActive': changeIndicator != 'X',
            'nameNative': (row['Name'] ?? '').toString().trim(),
            'lastImportedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          updateCounter++;
        }
      }

      if (updateCounter >= 400) {
        await batch.commit();
        batch = _firestore.batch();
        updateCounter = 0;
      }
    }

    if (updateCounter > 0) {
      await batch.commit();
    }

    // Write logs for admin review
    if (deviationReports.isNotEmpty) {
      await _firestore.collection('system_notifications').add({
        'type': 'UNLOCODE_REGISTRY_DRIFT',
        'timestamp': FieldValue.serverTimestamp(),
        'requiresAdminMigrationReview': true,
        'summaryReport': deviationReports,
        'reviewed': false,
      });
      print(
        '🔔 Execution logged! Admin alert written to system_notifications.',
      );
    }
  }

  /// Map constructor explicitly matching your towns document structure
  Map<String, dynamic> _buildTownMap(
    Map<String, dynamic> row,
    String unLocodeKey,
    String locationCode, {
    required bool isChanged,
    required bool active,
  }) {
    final String rawFunctions = (row['Function'] ?? '').toString().trim();
    List<String> functionsList = rawFunctions.codeUnits
        .map((c) => String.fromCharCode(c))
        .where((s) => int.tryParse(s) != null)
        .toList();

    return {
      "unLocodeKey": unLocodeKey,
      "locationCode": locationCode,
      "nameNative": (row['Name'] ?? '').toString().trim(),
      "nameEn": (row['NameWoDiacritics'] ?? row['Name'] ?? '')
          .toString()
          .trim(),
      "functions": functionsList,
      "status": (row['Status'] ?? '').toString().trim(),
      "unCodeDate": (row['Date'] ?? '').toString().trim(),
      "iataCode": (row['IATA'] ?? '').toString().trim(),
      "rawCoordinates": (row['Coordinates'] ?? '').toString().trim(),
      "nativeChangeIndicator": (row['Ch'] ?? '').toString().trim(),
      "isRecordChanged": isChanged,
      "isActive": active,
      "population": 0,
      "lastCensus": null,
      "translations": {"es": "", "fr": ""},
      "lastImportedAt": FieldValue.serverTimestamp(),
    };
  }
}
