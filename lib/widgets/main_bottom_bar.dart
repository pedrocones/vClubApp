import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({super.key});

  /// 🔍 Decoupled pure go_router inspection rule engine
  int _calculateActiveIndex(BuildContext context) {
    final String path = GoRouterState.of(context).uri.toString();
    if (path.startsWith('/about')) return 1;
    if (path.startsWith('/donate')) return 2;
    if (path.startsWith('/volunteer')) return 3;
    if (path.startsWith('/membership')) return 4;
    return 0; // Standard fallback root dashboard
  }

  @override
  Widget build(BuildContext context) {
    final int activeIndex = _calculateActiveIndex(context);

    // Mapped explicitly via clean lookups matching bottom nav order indexes
    final List<String> indexToRouteMap = [
      '/',
      '/about',
      '/donate',
      '/volunteer',
      '/membership',
    ];

    return Container(
      color: Colors.indigo,
      child: SafeArea(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.indigo,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white70,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: activeIndex,
          onTap: (int clickedIndex) {
            if (clickedIndex >= 0 && clickedIndex < indexToRouteMap.length) {
              context.go(indexToRouteMap[clickedIndex]);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About Us'),
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
    );
  }
}
