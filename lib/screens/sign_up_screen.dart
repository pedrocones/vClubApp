import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/location_selector_widget.dart';

class SignUpScreen extends StatefulWidget {
  final String? recruiterID;
  const SignUpScreen({super.key, this.recruiterID});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppAuthProvider>().initializeReferral(widget.recruiterID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Join Vicinum Club")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Unlock Club Benefits",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.go('/about'),
                child: const Text("Learn More"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pass,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          _buildHubSection(auth),
          const SizedBox(height: 40),
          auth.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: const Size.fromHeight(55),
                  ),

                  // Inside SignUpScreen onPressed:
                  onPressed: () async {
                    // 1. Capture values before the async gap
                    final email = _email.text.trim();
                    final pass = _pass.text.trim();

                    // 2. Perform the async call
                    bool success = await auth.signUpWithEmail(
                      email: email,
                      password: pass,
                    );

                    // 3. FIX: Properly guard the BuildContext across the async gap
                    // We check context.mounted specifically before using context.go
                    if (success && context.mounted) {
                      context.go('/membership');
                    }
                  },

                  child: const Text(
                    "ACTIVATE ROOKIE PASS",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHubSection(AppAuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Community Hub",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.indigo),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  auth.sessionTownName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showPicker(context),
                child: const Text(
                  "UPDATE",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height:
            MediaQuery.of(context).size.height *
            0.4, // Constrained height [User Query]
        child: const Column(
          children: [
            Text(
              "Select Local Community",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(child: LocationSelectorWidget()),
          ],
        ),
      ),
    );
  }
}
