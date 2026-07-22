import 'package:flutter/material.dart';
import '../models/members/member_model.dart';

class ProfilePage extends StatelessWidget {
  final MemberModel member;

  const ProfilePage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          'My Account Dashboard',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.indigo,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: 'John Doe',
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'member@vicinum.com',
          decoration: const InputDecoration(
            labelText: 'Registered Email',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
