import 'package:flutter/material.dart';

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Top-aligned list template matching the structural design of your other views
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'System Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.language, color: Colors.indigo),
          title: Text('Language Options'),
          subtitle: Text('Configure native internationalization strings'),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.dark_mode, color: Colors.indigo),
          title: Text('Theme Customization Engine'),
          subtitle: Text('Toggle visual light and dark interface balances'),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.notifications_active, color: Colors.indigo),
          title: Text('Push Alerts Configuration'),
          subtitle: Text('Manage system event messaging updates'),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
        ),
      ],
    );
  }
}
