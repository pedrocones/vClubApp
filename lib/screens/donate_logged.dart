import 'package:flutter/material.dart';
import '../api/abstracts/abstract_donate_service.dart';
import '../api/abstracts/mock_services_registry.dart';
import '../models/members/member_model.dart';

class DonateLoggedPage extends StatefulWidget {
  final AbstractDonateService donateService;

  // 1. Define the required member field
  final MemberModel member;

  DonateLoggedPage({
    super.key,
    required this.member,
    AbstractDonateService? service,
  }) : donateService = service ?? testDonateAPI;

  @override
  State<DonateLoggedPage> createState() => _DonateLoggedPageState();
}

class _DonateLoggedPageState extends State<DonateLoggedPage> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    // Directly fetch the list via interface futures instantly on load initialization
    _historyFuture = widget.donateService.fetchDonationHistory(
      'usr_mock_12345',
    );
  }

  void _triggerMockDonation() async {
    // Inject a dummy database transaction row to verify mutation capabilities
    await widget.donateService.processDonation(
      userId: 'usr_mock_12345',
      amount: 20.00,
      paymentMethodId: 'pm_card_visa',
      notes: 'Dynamic Injected Test Record',
    );

    // Refresh future timeline data instantly using local setState lifecycle methods
    setState(() {
      _historyFuture = widget.donateService.fetchDonationHistory(
        'usr_mock_12345',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio Logs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo),
                onPressed:
                    _triggerMockDonation, // Testing simulated writing cycles
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No database history rows found.'),
                  );
                }

                final logs = snapshot.data!;
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final item = logs[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.payment, color: Colors.green),
                        title: Text('Contribution identifier: ${item['id']}'),
                        subtitle: Text(
                          'Date: ${item['date']} • Notes: ${item['notes']}',
                        ),
                        trailing: Text(
                          '\$${item['amount']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
