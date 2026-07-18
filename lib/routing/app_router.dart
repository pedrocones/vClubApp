import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Import your page modules here
import '../screens/admin_dashboard_screen.dart';
import '../screens/main_layout.dart';
import '../screens/landing_hub_view.dart';
import '../screens/about_us.dart';
import '../screens/donate.dart';
import '../screens/donate_logged.dart';
import '../screens/volunteer_screen.dart';
import '../screens/volunteer_logged.dart';
import '../screens/membership_screen.dart';
import '../screens/membership_logged.dart';
import '../screens/system_settings.dart';
import '../screens/profile.dart';
import '../screens/profile_form.dart';
import '../screens/sign_up_screen.dart';
import '../screens/contact_us.dart';
import '../screens/sign_off.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // 1. Pages wrapped inside the shared navigation interface shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => LandingHubView(
              onNavigate: (index) => _handleOldIndexNav(context, index),
            ),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutUsPage(),
          ),
          GoRoute(
            path: '/donate',
            builder: (context, state) {
              final loggedIn = context.watch<AppAuthProvider>().isLoggedIn;
              return loggedIn ? DonateLoggedPage() : const DonatePage();
            },
          ),
          GoRoute(
            path: '/volunteer',
            builder: (context, state) {
              final loggedIn = context.watch<AppAuthProvider>().isLoggedIn;
              return loggedIn
                  ? const VolunteerLoggedPage()
                  : const VolunteerPage();
            },
          ),
          GoRoute(
            path: '/membership',
            builder: (context, state) {
              final loggedIn = context.watch<AppAuthProvider>().isLoggedIn;
              return loggedIn
                  ? const MembershipLoggedPage()
                  : const MembershipPage();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SystemSettingsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              final loggedIn = context.watch<AppAuthProvider>().isLoggedIn;
              return loggedIn ? const ProfilePage() : const SignUpScreen();
            },
          ),
          GoRoute(
            path: '/contact',
            builder: (context, state) => ContactUsPage(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) {
              final incomingRecruiterID = state
                  .uri
                  .queryParameters['memberID']; // Extracts ?memberId= from URL
              return SignUpScreen(recruiterID: incomingRecruiterID);
            },
          ),

          // 🛡️ Secured Admin Dashboard Console Route
          GoRoute(
            path: '/admin-dashboard',
            builder: (BuildContext context, GoRouterState state) =>
                const AdminDashboardScreen(),

            /*             redirect: (BuildContext context, GoRouterState state) {
              // 1. Set your authorization check variables FIRST
              bool isMockUserAdmin = true; // Replace with your state management: userProfile.role == 'Admin'

              // 2. Evaluate access logic and branch rules
              if (!isMockUserAdmin) {
                debugPrint(
                  "🔒 Unauthorized access attempt recorded. Redirecting...",
                );
                return '/unauthorized'; // Reroute out instantly
              }

              // 3. CRITICAL: Put your fallback return null at the ABSOLUTE BOTTOM of the block.
              // This lets the user through smoothly if they pass the admin check above.
              return null;
            }, */
          ),

          // 🔒 Unauthorized Access Catch Route
          GoRoute(
            path: '/unauthorized',
            builder: (BuildContext context, GoRouterState state) =>
                const Scaffold(
                  body: Center(
                    child: Text(
                      "🔒 Access Denied.\nAdministrative privileges required.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
          ),

          GoRoute(
            path: '/complete-profile',
            builder: (context, state) => const ProfileFormScreen(),
          ),
        ],
      ),
      // 2. Standalone paths built outside the standard top/bottom navigation shell
      GoRoute(
        path: '/sign-off',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignOffPage(),
      ),
    ],
  );

  // Fallback map to translate your legacy index-based steps into clean web URLs
  static void _handleOldIndexNav(BuildContext context, int index) {
    final paths = {
      0: '/',
      1: '/about',
      2: '/donate',
      3: '/volunteer',
      4: '/membership',
      5: '/settings',
      6: '/profile',
      7: '/contact',
    };
    if (index == 99) {
      context.push('/sign-off');
    } else if (paths.containsKey(index)) {
      context.go(paths[index]!);
    }
  }
}
