import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Adjust path based on your lib structure

class SignupIncentive extends StatelessWidget {
  const SignupIncentive({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the global provider for the 'Default Rookie' state
    final auth = context.watch<AppAuthProvider>();

    // Logic: Only show this if the user is the Guest Rookie (not logged in via Firebase)
    if (auth.isLoggedIn) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.amber.shade200, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Appealing Icon: Using 'stars' to represent rewards/benefits
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.amber,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Club Benefits',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join your local community to start collecting vCoins and supporting causes.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: const Text('SIGN UP NOW'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      context.go('/about'), // Links to About Us as requested
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('LEARN MORE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
