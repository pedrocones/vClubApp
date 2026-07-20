import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import 'language_selector_widget.dart';

class MainTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MainTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 2,
      // Clear out the leading icon entirely so the logo starts right at the edge
      leading: null,
      automaticallyImplyLeading: false,

      // 🛡️ 1. Restored original branding logo + subtitle layout bounds
      title: Row(
        children: [
          Image.asset(
            '../assets/branding/vicinumShield_TranspBG.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),

          // ⚠️ 2. FIX OVERFLOW: Wrapped in Expanded to force text to measure within available remaining width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Vicinum Club',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    height: 1.1,
                  ),
                ),
                Text(
                  '3L - Love Local Living',
                  overflow: TextOverflow.ellipsis, // Safe wrap constraint check
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        // Language Selector component item
        const LanguageSelectorWidget(),
        const SizedBox(width: 4),

        // Profile Action circle item
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          tooltip: 'Profile Settings',
          onSelected: (String path) {
            if (path == '/sign-off') {
              context.read<AppAuthProvider>().logout();
            }
            context.go(path);
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: '/profile', child: Text('My Profile')),
            const PopupMenuItem(
              value: '/membership',
              child: Text('Membership'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: '/settings',
              child: Text('System Settings'),
            ),
            const PopupMenuItem(value: '/contact', child: Text('Contact Us')),
            const PopupMenuItem(value: '/sign-off', child: Text('Sign Out')),
          ],
        ),

        // 🔮 3. Restored: Menu actions moved from leading to right-hand actions side
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          tooltip: 'Navigation Options',
          onSelected: (String path) => context.go(path),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: '/preferences',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 18, color: Colors.indigo),
                  SizedBox(width: 8),
                  Text('Preferences'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: '/help-desk',
              child: Row(
                children: [
                  Icon(Icons.help, size: 18, color: Colors.indigo),
                  SizedBox(width: 8),
                  Text('Help Desk'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
