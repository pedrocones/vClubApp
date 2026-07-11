import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  // Identifies which main step index is active based on the current URL
  int _calculateCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/about')) return 1;
    if (location.startsWith('/donate')) return 2;
    if (location.startsWith('/volunteer')) return 3;
    if (location.startsWith('/membership')) return 4;
    return 0; // Default fallback to home dashboard view
  }

  void _onNavigationChanged(BuildContext context, int value) {
    if (value == 99) {
      context.read<AppAuthProvider>().logout();
      context.push('/sign-off');
      return;
    }
    final paths = {
      0: '/',
      1: '/about',
      2: '/donate',
      3: '/volunteer',
      4: '/membership',
      5: '/settings',
      6: '/profile',
      7: '/contact',
      99: '/sing-off',
    };
    if (paths.containsKey(value)) {
      context.go(paths[value]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();
    final int currentIndex = _calculateCurrentIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool isMobileLandscape = height < 500 && width > height;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                Image.asset(
                  'Assets/img/vicinumShield_TranspBG.png',
                  height: 32,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.shield, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Loving Local Living',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  authProvider.isLoggedIn
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  color: authProvider.isLoggedIn ? Colors.amber : Colors.white,
                ),
                onPressed: () => _onNavigationChanged(context, 6),
              ),
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (val) => _onNavigationChanged(context, val),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(value: 0, child: Text('Home')),
                  const PopupMenuItem(value: 1, child: Text('About Us')),
                  const PopupMenuItem(value: 2, child: Text('Donate')),
                  const PopupMenuItem(value: 3, child: Text('Volunteer')),
                  const PopupMenuItem(value: 4, child: Text('Membership')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 5, child: Text('System Settings')),
                  const PopupMenuItem(value: 7, child: Text('Contact Us')),
                  const PopupMenuItem(value: 99, child: Text('Sign Out')),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
          // GoRouter safely projects the target view component directly into this container
          body: child,
          bottomNavigationBar: isMobileLandscape
              ? null
              : Container(
                  color: Colors.indigo,
                  child: SafeArea(
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.indigo,
                      selectedItemColor: Colors.amber,
                      unselectedItemColor: Colors.white70,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      currentIndex: currentIndex,
                      onTap: (val) => _onNavigationChanged(context, val),
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.info),
                          label: 'About Us',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.favorite),
                          label: 'Donate',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.groups),
                          label: 'Volunteer',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.card_membership),
                          label: 'Membership',
                        ),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton.small(
            backgroundColor: Colors.amber,
            onPressed: () => authProvider.toggleLogin(),
            child: const Icon(Icons.cached, color: Colors.indigo),
          ),
        );
      },
    );
  }
}
