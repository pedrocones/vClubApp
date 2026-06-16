import 'package:flutter/widgets.dart';

/* Small Screens: max-width: 600px (smartphones)
Medium Screens: 601px — 1024px (tablets)
Large Screens: 1025px — 1440px (desktops)
Extra Large Screens: min-width: 1441px */

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget deskTopBody;
  final Widget tabletBody;
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.deskTopBody,
    required this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileBody;
        } else if (constraints.maxWidth < 1024) {
          return tabletBody;
        } else {
          return deskTopBody;
        }
      },
    );
  }
}
