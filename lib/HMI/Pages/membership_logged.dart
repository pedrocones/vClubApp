import 'package:flutter/material.dart';

class MembershipLoggedPage extends StatelessWidget {
  const MembershipLoggedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          'Active Club Member Pass',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 30),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Icon(Icons.verified_user, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Premium Console Member',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Verification ID: VIC-77321-2026',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Member Voting Rights & Benefits'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
