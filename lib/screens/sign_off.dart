import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignOffPage extends StatelessWidget {
  const SignOffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.volunteer_activism,
                size: 90,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              const Text(
                'Thank You for Loving Your Neighborhood!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'You have been safely signed off your current active session profile track record.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.indigo.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  context
                      .read<AppAuthProvider>()
                      .logout(); // Triggers real signOut + Guest reset
                  context.go('/'); // Redirect to landing
                },

                icon: const Icon(Icons.login),
                label: const Text(
                  'Return to Console Hub',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
