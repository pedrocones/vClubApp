import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import './language_selector_widget.dart';

class MainTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MainTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // 1. Read Member Fields from the Single Source of Truth
    final auth = context.watch<AppAuthProvider>();
    final member = auth.member;

    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 2,
      automaticallyImplyLeading: false,
      title: _buildBranding(),
      actions: [
        const LanguageSelectorWidget(),
        const SizedBox(width: 4),

        IconButton(
          tooltip: auth.isLoggedIn ? "Member: ${member.username}" : "Sign In",
          icon: Icon(
            auth.isLoggedIn
                ? Icons.account_circle
                : Icons.account_circle_outlined,
            color: auth.isLoggedIn ? Colors.amber : Colors.white,
          ),
          onPressed: () =>
              auth.isLoggedIn ? context.go('/profile') : context.go('/signin'),
        ),

        // Complete Navigation (Three Dots) [2, 3]
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (path) => context.go(path),
          itemBuilder: (context) => _buildFullNavigationMenu(auth.isLoggedIn),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBranding() {
    return Row(
      children: [
        Image.asset(
          '../assets/branding/vicinumShield_TranspBG.png',
          height: 32,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vicinum Club',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '3L - Love Local Living',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildFullNavigationMenu(bool loggedIn) {
    return [
      const PopupMenuItem(value: '/', child: Text('Home')),
      const PopupMenuItem(value: '/about', child: Text('About Us')),
      const PopupMenuItem(value: '/donate', child: Text('Donate')),
      const PopupMenuItem(value: '/volunteer', child: Text('Volunteer')),
      const PopupMenuItem(value: '/membership', child: Text('Membership')),
      const PopupMenuDivider(),
      const PopupMenuItem(value: '/profile', child: Text('My Profile')),
      const PopupMenuItem(value: '/settings', child: Text('System Settings')),
      const PopupMenuItem(value: '/contact_us', child: Text('Contact Us')),
      const PopupMenuItem(value: '/sign-off', child: Text('Sign Out')),
      const PopupMenuDivider(),
      if (!loggedIn) ...[
        const PopupMenuItem(value: '/signin', child: Text('Sign In')),
        const PopupMenuItem(value: '/signup', child: Text('Join the Club')),
      ],
      const PopupMenuDivider(),
      if (loggedIn)
        const PopupMenuItem(value: '/sign-off', child: Text('Sign Out')),
    ];
  }
}
