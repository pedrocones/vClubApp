import 'package:flutter/widgets.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobieBody;
  final Widget deskTopBody;
  final Widget tabletBody;
  const ResponsiveLayout({
    super.key,
    required this.mobieBody,
    required this.deskTopBody,
    required this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobieBody;
        } else if (constraints.maxWidth < 1200) {
          return tabletBody;
        } else {
          return deskTopBody;
        }
      },
    );
  }
}
