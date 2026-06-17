import 'package:flutter/material.dart';

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Text(
          'Join as a Volunteer',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Explore upcoming local cleanups, safe-walk programs, and community gardens. Sign up or log in to lock in open slots.',
          style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          3,
          (index) => Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.indigo),
              title: Text('Public Event Opening #${index + 1}'),
              subtitle: const Text(
                'Open to public registration • Location verified',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 12),
            ),
          ),
        ),
      ],
    );
  }
}
