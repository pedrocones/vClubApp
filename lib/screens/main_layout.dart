import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/main_top_bar.dart';
import '../widgets/main_bottom_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 📱 Hide bottom navigation bar completely if screen height is constrained (e.g. mobile landscape)
        final bool isSpaceConstrained = constraints.maxHeight < 500;

        return Scaffold(
          appBar:
              const MainTopBar(), // ⚡ Handles branding, languages, account, and navigation dropdowns
          body: child, // ⚡ go_router structural view targets mount here cleanly

          bottomNavigationBar: isSpaceConstrained
              ? null
              : const MainBottomBar(),

          floatingActionButton: FloatingActionButton.small(
            backgroundColor: Colors.amber,
            onPressed: () => authProvider.toggleLogin(),
            child: Icon(authProvider.isLoggedIn ? Icons.lock_open : Icons.lock),
          ),
        );
      },
    );
  }
}
