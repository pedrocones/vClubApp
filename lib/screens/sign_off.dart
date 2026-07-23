import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class SignOffPage extends StatefulWidget {
  const SignOffPage({super.key});

  @override
  State<SignOffPage> createState() => _SignOffPageState();
}

class _SignOffPageState extends State<SignOffPage> {
  @override
  void initState() {
    super.initState();
    // Reverts global state to GUEST_admin_L0 upon landing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppAuthProvider>().logout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          // FIX 1: Use constraints for maximum width
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.exit_to_app, color: Colors.amber, size: 80),
              const SizedBox(height: 24),
              const Text(
                "You have signed off",
                // FIX 2 & 3: Use the enum TextAlign.center, not the Type 'Center'
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Your session has ended safely. Vicinum Club remains active in your community.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.indigo.shade900,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => context.go('/'),
                child: const Text("RETURN TO VISITOR HUB"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
