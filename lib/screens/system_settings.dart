import 'package:flutter/material.dart';

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        // Restricts the width on large desktop screens so text lines don't stretch too far
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
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
            ListTile(
              leading: const Icon(Icons.language, color: Colors.indigo),
              title: const Text('Language Options'),
              subtitle: const Text(
                'Configure native internationalization strings',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // Future localization route target
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.indigo),
              title: const Text('Theme Customization Engine'),
              subtitle: const Text(
                'Toggle visual light and dark interface balances',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // Future theme provider hook target
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.indigo,
              ),
              title: const Text('Push Alerts Configuration'),
              subtitle: const Text('Manage system event messaging updates'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // Future notifications permissions hook target
              },
            ),
          ],
        ),
      ),
    );
  }
}
