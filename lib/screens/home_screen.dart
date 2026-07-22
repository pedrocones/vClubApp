import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Project Imports
import '../providers/auth_provider.dart';
import '../widgets/main_bottom_bar.dart';
import '../widgets/language_selector_widget.dart';

class HomeScreen extends StatelessWidget {
  /// The [child] is the active page injected by go_router (e.g., MembershipPage) [3]
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Accessing global state: member is guaranteed non-null
    final auth = context.watch<AppAuthProvider>();
    final member = auth.member; // Now we will use this!
    final bool isLoggedIn = auth.isLoggedIn;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSpaceConstrained = constraints.maxHeight < 500;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                // Branding Icon
                Image.asset(
                  'assets/branding/vicinumShield_TranspBG.png',
                  height: 32,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.shield, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 10),
                // Use the member's default or real status for the title context
                Text(
                  isLoggedIn
                      ? 'Hello, ${member.username}'
                      : 'Loving Local Living',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              const LanguageSelectorWidget(),

              // 2. Account Identity Icon - Now uses 'member' for the tooltip
              IconButton(
                tooltip:
                    "Profile: ${member.username} (${member.member_status.name})",
                icon: Icon(
                  isLoggedIn
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  color: isLoggedIn ? Colors.amber : Colors.white,
                ),
                onPressed: () => context.go('/profile'),
              ),

              // 3. System Navigation Dropdown
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (path) => context.go(path),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: '/', child: Text('Home')),
                  const PopupMenuItem(value: '/about', child: Text('About Us')),
                  const PopupMenuItem(
                    value: '/settings',
                    child: Text('System Settings'),
                  ),
                  const PopupMenuItem(
                    value: '/contact',
                    child: Text('Contact Us'),
                  ),
                  // Sign out only appears if the member isn't the default Guest
                  if (isLoggedIn) ...[
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: '/sign-off',
                      child: Text('Sign Out'),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: child, // Page content injected by AppRouter
          bottomNavigationBar: isSpaceConstrained
              ? null
              : const MainBottomBar(),
        );
      },
    );
  }
}
