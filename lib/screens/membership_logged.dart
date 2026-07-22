import 'package:flutter/material.dart';
import '../models/members/member_model.dart'; // Ensure correct path to your synced model

class MembershipLoggedPage extends StatelessWidget {
  // 1. Define the required member field
  final MemberModel member;

  // 2. Add it to the constructor (Removes the compiler error)
  const MembershipLoggedPage({super.key, required this.member});

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
        _buildMemberCard(context),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Icon(Icons.verified_user, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          // Using the passed member data dynamically [Source 10]
          Text(
            member.username ?? 'Rookie Member',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Status: ${member.member_status.name.toUpperCase()}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
