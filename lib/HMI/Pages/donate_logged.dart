import 'package:flutter/material.dart';

class DonateLoggedPage extends StatelessWidget {
  const DonateLoggedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Text(
          'My Contributions Portfolio',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          color: Colors.indigo,
          child: ListTile(
            title: Text(
              'Active Recurring Tier Level',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              '\$45.00 / mo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Contribution History Logs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...List.generate(
          3,
          (index) => ListTile(
            leading: const Icon(Icons.verified, color: Colors.green),
            title: Text(
              'Automated Monthly Community Grant Support #${index + 1}',
            ),
            subtitle: const Text(
              'Status: Settled successfully via card processing infrastructure',
            ),
          ),
        ),
      ],
    );
  }
}
