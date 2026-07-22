import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Screens
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
import '../screens/sign_up_screen.dart';
import '../screens/contact_us.dart';
import '../screens/sign_off.dart';
import '../providers/auth_provider.dart';
import '../models/members/member_model.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const LandingHubView(), // Numeric callback removed [3]
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutUsPage(),
          ),
          GoRoute(
            path: '/donate',
            builder: (context, state) {
              final member = context.watch<AppAuthProvider>().member;
              // Access Gating: All statuses can donate, but Logged view provides ledger tools [1]
              return (member.member_id != 'GUEST_admin_L0')
                  ? DonateLoggedPage(member: member)
                  : const DonatePage();
            },
          ),
          GoRoute(
            path: '/volunteer',
            builder: (context, state) {
              final member = context.watch<AppAuthProvider>().member;
              // Gated by Benefits Map: Only verified tiers (Ambassador/Associated) can apply [1]
              bool isVerified =
                  member.member_status == MemberStatus.ambassador ||
                  member.member_status == MemberStatus.associated;
              return isVerified
                  ? VolunteerLoggedPage(member: member)
                  : const VolunteerPage();
            },
          ),
          GoRoute(
            path: '/membership',
            builder: (context, state) {
              final member = context.watch<AppAuthProvider>().member;
              // Decision based on status: Show dashboard for verified tiers [1]
              bool hasDashboardAccess =
                  member.member_status == MemberStatus.ambassador ||
                  member.member_status == MemberStatus.associated;
              return hasDashboardAccess
                  ? MembershipLoggedPage(member: member)
                  : const MembershipPage();
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              final auth = context.watch<AppAuthProvider>();
              // If not the Guest, show real profile [Conversation History]
              return auth.isLoggedIn
                  ? ProfilePage(member: auth.member)
                  : const SignUpScreen();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SystemSettingsPage(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) {
              final recruiterID = state.uri.queryParameters['memberID'];
              return SignUpScreen(recruiterID: recruiterID);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/sign-off',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignOffPage(),
      ),
      GoRoute(
        path: '/contact_us',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ContactUsPage(),
      ),
    ],
  );
}
