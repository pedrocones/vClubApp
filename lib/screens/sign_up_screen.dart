import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/signup_incentive.dart';

class SignUpScreen extends StatefulWidget {
  final String? recruiterID;
  const SignUpScreen({super.key, this.recruiterID});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  //mock-up location while we develop widget
  // 1. Placeholder for the selected location (Defaulting to your visitor town)
  final String _selectedTownUnicode = "US-CA-M0180";

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AppAuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Join Vicinum")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SignupIncentive(), // Show visitor benefits
          if (widget.recruiterID != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Referral from: ${widget.recruiterID}",
                style: const TextStyle(color: Colors.green),
              ),
            ),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: _pass,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          authProv.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    bool success = await authProv.signUpWithEmail(
                      email: _email.text.trim(),
                      password: _pass.text.trim(),
                      townUnicode: _selectedTownUnicode, // Passed to provider
                      recruiterID:
                          widget.recruiterID, // Passed from URL state [7]
                    );
                    if (success && context.mounted) {
                      context.go('/membership');
                    }
                  },
                  child: const Text('ACTIVATE ROOKIE PASS'),
                ),
        ],
      ),
    );
  }
}
