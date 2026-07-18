import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  final String? recruiterID;
  const SignUpScreen({super.key, this.recruiterID});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AppAuthProvider>();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Join Vicinum Club',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),

                  // Display parsed coach connection context dynamically
                  if (widget.recruiterID != null)
                    Chip(
                      avatar: const Icon(
                        Icons.verified_user,
                        color: Colors.indigo,
                      ),
                      label: Text('Referred by Member: ${widget.recruiterID}'),
                      backgroundColor: Colors.amber.withValues(alpha: 0.2),
                    ),

                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  authProv.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            bool success = await authProv.signUpWithEmail(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            if (success && context.mounted) {
                              // Forward user directly to step 3 onboarding wizard
                              context.go(
                                '/complete-profile?coach=${widget.recruiterID ?? "none"}',
                              );
                            }
                          },
                          child: const Text('Register Account'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
