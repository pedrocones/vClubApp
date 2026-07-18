import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/drift_test_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DriftTestService _driftService = DriftTestService();
  bool _isProcessing = false;
  List<Map<String, dynamic>> _detectedDrifts = [];

  @override
  void initState() {
    super.initState();
    _loadActiveDrifts(); // Check for changed records immediately on window init
  }

  /// 🔍 Live Audit Scan: Fetches all town rows globally flagged with isRecordChanged == true
  Future<void> _loadActiveDrifts() async {
    setState(() => _isProcessing = true);
    try {
      final QuerySnapshot driftedTownsSnapshot = await FirebaseFirestore
          .instance
          .collectionGroup('towns')
          .where('isRecordChanged', isEqualTo: true)
          .get();

      final List<Map<String, dynamic>> loadedChanges = [];
      for (var doc in driftedTownsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Reconstruct hierarchical positioning context directly from the path string
        final List<String> pathSegments = doc.reference.path.split('/');
        final String countryCode = pathSegments[1];
        final String stateCode = pathSegments[3];

        loadedChanges.add({
          'docRefPath': doc.reference.path,
          'unLocodeKey': data['unLocodeKey'] ?? doc.id,
          'country': countryCode,
          'state': stateCode,
          'town': doc.id,
          'nameNative': data['nameNative'] ?? 'Unknown',
          'indicator': data['nativeChangeIndicator'] ?? '',
          'docId': doc.id,
          'docRef': doc.reference,
        });
      }

      setState(() {
        _detectedDrifts = loadedChanges;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      debugPrint("❌ Failed to query drifted town groups: $e");
    }
  }

  /// Dismisses / Clears the record change flag after the admin manually audits it
  Future<void> _dismissDriftFlag(DocumentReference docRef) async {
    try {
      await docRef.update({'isRecordChanged': false});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Record reviewed and dismissed successfully!'),
        ),
      );
      _loadActiveDrifts(); // Re-refresh lists
    } catch (e) {
      debugPrint("Error clearing item flag: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ System Admin Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isProcessing ? null : _loadActiveDrifts,
          ),
        ],
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION 1: SIMULATION COMMAND CONTROLS ---
                  Card(
                    elevation: 3,
                    color: Colors.grey[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Developer Testing Pipelines",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Trigger a simulated UNECE update execution cycle to verify drift capture workflows against your running emulator container.",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[50],
                              ),
                              icon: const Icon(Icons.bolt, color: Colors.blue),
                              label: const Text(
                                "Simulate Registry Updates & Check Drift",
                              ),
                              onPressed: () async {
                                setState(() => _isProcessing = true);
                                await _driftService
                                    .simulateRegistryDriftAndCheck();
                                await _loadActiveDrifts(); // auto reload changes view
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SECTION 2: LIVE CHANGE DETECTOR LIST ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pending Modifications Queue (${_detectedDrifts.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_detectedDrifts.isNotEmpty)
                        const Icon(
                          Icons.warning,
                          color: Colors.amber,
                          size: 20,
                        ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),

                  if (_detectedDrifts.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          "☀️ Complete system convergence. No changes require review.",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _detectedDrifts.length,
                      itemBuilder: (context, index) {
                        final driftItem = _detectedDrifts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: driftItem['indicator'] == 'X'
                                  ? Colors.red[50]
                                  : Colors.orange[50],
                              child: Text(
                                driftItem['indicator'].isEmpty
                                    ? '#'
                                    : driftItem['indicator'],
                                style: TextStyle(
                                  color: driftItem['indicator'] == 'X'
                                      ? Colors.red
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              "${driftItem['nameNative']} (${driftItem['unLocodeKey']})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Location Node: /${driftItem['country']}/${driftItem['state']}/${driftItem['town']}\nIndicator column tracking flag: ${driftItem['indicator']}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[50],
                              ),
                              onPressed: () => _dismissDriftFlag(
                                driftItem['docRef'] as DocumentReference,
                              ),
                              child: const Text(
                                "Dismiss Flag",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
