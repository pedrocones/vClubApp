import 'package:flutter/material.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          'Vicinum Club Tiers',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Unlock community voting privileges, local business benefits, and direct program governance channels.',
          style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 30),

        // Mock tier blocks
        _buildTierCard(
          'Community Tier',
          'Free baseline access to public event channels',
        ),
        _buildTierCard(
          'Premium Voting Tier',
          'Full access to localized budgeting votes & local discounts',
        ),
      ],
    );
  }

  Widget _buildTierCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.right,
              child: TextButton(
                onPressed: () {},
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
