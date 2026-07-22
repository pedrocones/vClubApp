import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/signup_incentive.dart';

class SignInScreen extends StatefulWidget {
  final String? recruiterID;
  const SignInScreen({super.key, this.recruiterID});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  //mock-up location while we develop widget
  // 1. Placeholder for the selected location (Defaulting to your visitor town)
  //final String _selectedTownUnicode = "US-CA-M0180";

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
                    //bool success = await authProv.signInWithEmail()
                    //mock up sign-in success = true,
                    bool success = true;
                    if (success && context.mounted) {
                      context.go('/membership');
                    }
                  },
                  child: const Text('SIGNED IN'),
                ),
        ],
      ),
    );
  }
}
