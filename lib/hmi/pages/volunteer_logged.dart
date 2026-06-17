import 'package:flutter/material.dart';

class VolunteerLoggedPage extends StatelessWidget {
  const VolunteerLoggedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Text(
          'My Volunteer Activity Hub',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Upcoming Confirmed Assignments',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const ListTile(
          leading: Icon(Icons.event_available, color: Colors.green),
          title: Text('Neighborhood Public Greenery Restoration'),
          subtitle: Text('Scheduled Tracking: Saturday at 9:00 AM PST'),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.history, color: Colors.grey),
          title: Text('Completed Community Safe Walk Initiative'),
          subtitle: Text('Duration: 4.5 Credits Logged into Platform Records'),
        ),
      ],
    );
  }
}
