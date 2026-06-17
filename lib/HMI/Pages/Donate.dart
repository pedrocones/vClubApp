import 'package:flutter/material.dart';

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Top-aligned list engine that ignores screen centering parameters entirely
    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: 15, // Long list layout to trigger scrolling
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.shade50,
            child: const Icon(Icons.favorite, color: Colors.indigo, size: 18),
          ),
          title: Text('Public Donation Listing Asset Record #${index + 1}'),
          subtitle: const Text(
            'Status: Active • Awaiting mock backend routing sync',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
        );
      },
    );
  }
}
