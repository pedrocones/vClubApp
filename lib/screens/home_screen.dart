import 'package:flutter/material.dart';
import '../widgets/main_top_bar.dart';
import '../widgets/main_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  final Widget child; // The page content from AppRouter

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSpaceConstrained = constraints.maxHeight < 500;

        return Scaffold(
          appBar: const MainTopBar(), // State logic moved here
          body: child,
          bottomNavigationBar: isSpaceConstrained
              ? null
              : const MainBottomBar(),
        );
      },
    );
  }
}
