import 'package:flutter/material.dart';
import 'landing_hub_view.dart';
import 'donate.dart';
import 'system_settings.dart';
import 'sign_off.dart';
import 'mock_auth_forms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation Index Tracking:
  // 0=Home, 1=About, 2=Donate, 3=Volunteer, 4=Membership, 5=System Settings
  int _currentStep = 0;

  // Development simulation toggle tracking session state
  bool _mockIsLoggedIn = false;

  /// Smart routing handler filtering out only the Sign-Out exit utility
  void _handleNavigation(int selectedValue) {
    if (selectedValue == 99) {
      // Sign out remains an isolated overlay step leading to a farewell scene
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignOffPage()),
      );
    } else {
      // Changes the active inner body layout instantly
      setState(() {
        _currentStep = selectedValue;
      });
    }
  }

  /// Triggers the dynamic development authentication state switch on click
  void _handleProfileRoute() {
    if (_mockIsLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MockProfileFormPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MockSignUpFormPage()),
      );
    }

    // Toggle automatically at the bottom of the execution track
    setState(() {
      _mockIsLoggedIn = !_mockIsLoggedIn;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _mockIsLoggedIn
              ? 'Switched to Authenticated state'
              : 'Switched to Guest state',
        ),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        // Hide bottom navigation bar in tight landscape views to conserve workspace height
        bool isMobileLandscape = height < 500 && width > height;

        return Scaffold(
          backgroundColor: Colors.white,

          // 1. TOP APP BAR
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
                  _mockIsLoggedIn
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  color: _mockIsLoggedIn ? Colors.amber : Colors.white,
                ),
                onPressed: _handleProfileRoute,
              ),
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: _handleNavigation,
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(value: 0, child: Text('Home')),
                  const PopupMenuItem(value: 1, child: Text('About Us')),
                  const PopupMenuItem(value: 2, child: Text('Donate')),
                  const PopupMenuItem(value: 3, child: Text('Volunteer')),
                  const PopupMenuItem(value: 4, child: Text('Membership')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 5, child: Text('System Settings')),
                  const PopupMenuItem(value: 99, child: Text('Sign Out')),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),

          // 2. PRIMARY CONTENT FRAME
          body: _buildActivePageLayout(),

          // 3. ADAPTIVE BOTTOM NAVIGATION BAR
          bottomNavigationBar: isMobileLandscape
              ? null
              : Container(
                  color: Colors.indigo,
                  child: SafeArea(
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.indigo,
                      selectedItemColor: _currentStep > 4
                          ? Colors.white70
                          : Colors.amber,
                      unselectedItemColor: Colors.white70,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      // Clamps the highlighted index to standard tabs; if settings (5) is active, no tab glows
                      currentIndex: _currentStep > 4 ? 0 : _currentStep,
                      onTap: _handleNavigation,
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
        );
      },
    );
  }

  /// Maps navigation state parameters directly to view widgets to overwrite body contents
  Widget _buildActivePageLayout() {
    switch (_currentStep) {
      case 1:
        return const Center(child: Text('About Us Content View'));
      case 2:
        return const DonatePage();
      case 3:
        return const Center(child: Text('Volunteer Directory Grid View'));
      case 4:
        return const Center(child: Text('Membership Enrollment Dashboard'));
      case 5:
        return const SystemSettingsPage(); // Uniform inner page container replacement
      case 0:
      default:
        return LandingHubView(onNavigate: _handleNavigation);
    }
  }
}
