// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class UnLocodeDriftEngine {
  final FirebaseFirestore _firestore;

  UnLocodeDriftEngine({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Main periodic sync pipeline wrapper loop
  Future<void> checkRegistryDeviations() async {
    print('🔄 Starting Periodic UN-LOCODE Drift and Change Analysis Loop...');

    final String unRegistryApiUrl = 'https://api.example.com/un-locode/latest';

    try {
      final response = await http.get(
        Uri.parse(unRegistryApiUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to pull updated registry from remote stream.');
      }

      final List<dynamic> remoteDataList = json.decode(response.body);
      print(
        '📥 Live feed obtained. Analyzing ${remoteDataList.length} total entries...',
      );

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

        if (country != 'US' || (subdivision != 'CA' && subdivision != 'FL')) {
          continue;
        }

        final String locationCode = (row['Location'] ?? '')
            .toString()
            .trim()
            .toUpperCase();
        final String unLocodeKey = '$country$subdivision$locationCode';
        final String changeIndicator = (row['Ch'] ?? '').toString().trim();

        bool nativelyFlaggedChanged =
            changeIndicator == '+' ||
            changeIndicator == '#' ||
            changeIndicator == 'X' ||
            changeIndicator == '¦';

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
            '[NEW ENTRY DETECTED] Key: $unLocodeKey, Indicator: $changeIndicator',
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
          final String pastIndicator =
              currentData['nativeChangeIndicator'] ?? '';

          bool internalAttributesDrifted =
              currentData['nameNative'] != row['Name'] ||
              currentData['nameEn'] != row['NameWoDiacritics'] ||
              pastIndicator != changeIndicator;

          if (nativelyFlaggedChanged || internalAttributesDrifted) {
            deviationReports.add(
              '[DRIFT DETECTED] Key: $unLocodeKey, Past: "$pastIndicator" -> Fresh: "$changeIndicator"',
            );

            batch.set(townDocRef, {
              'nativeChangeIndicator': changeIndicator,
              'isRecordChanged': true,
              'isActive': changeIndicator != 'X',
              'nameNative': (row['Name'] ?? '').toString().trim(),
              'nameEn': (row['NameWoDiacritics'] ?? '').toString().trim(),
              'lastImportedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            updateCounter++;
          }
        }

        if (updateCounter >= 400) {
          await batch.commit();
          print('📦 Intermediate batch updates committed safely.');
          batch = _firestore.batch();
          updateCounter = 0;
        }
      }

      if (updateCounter > 0) {
        await batch.commit();
      }

      await _logEngineAnalysis(deviationReports);
    } catch (e) {
      print('❌ Error handling scheduled loop execution step: $e');
    }
  }

  /// Helper tool map constructor matching your embedded structure properties
  Map<String, dynamic> _buildTownMap(
    Map<String, dynamic> row,
    String unLocodeKey,
    String locationCode, {
    required bool isChanged,
    required bool active,
  }) {
    // 🚨 FIXED DEFINITION: Added 'final String' to properly declare the variable local type scope
    final String rawFunctions = (row['Function'] ?? '').toString().trim();

    List<String> functionsList = rawFunctions.codeUnits
        .map((c) => String.fromCharCode(c))
        .where((s) => int.tryParse(s) != null)
        .toList();

    return {
      "unLocodeKey": unLocodeKey,
      "locationCode": locationCode,
      "nameNative": (row['Name'] ?? '').toString().trim(),
      "nameEn": (row['NameWoDiacritics'] ?? '').toString().trim(),
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

  /// Writes findings directly to an admin alert log stream
  Future<void> _logEngineAnalysis(List<String> deviations) async {
    print(
      '📢 Summary processing completed. Total changes captured: ${deviations.length}',
    );

    if (deviations.isNotEmpty) {
      await _firestore.collection('system_notifications').add({
        'type': 'UNLOCODE_REGISTRY_DRIFT',
        'timestamp': FieldValue.serverTimestamp(),
        'requiresAdminMigrationReview': true,
        'summaryReport': deviations,
        'reviewed': false,
      });
      print(
        '🔔 Admin system notification dispatched to database panel successfully.',
      );
    }
  }
}
