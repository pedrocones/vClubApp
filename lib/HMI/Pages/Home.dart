import 'package:flutter/material.dart';
import 'landing_hub_view.dart';
import 'donate.dart';
import 'donate_logged.dart';
import 'volunteer.dart';
import 'volunteer_logged.dart';
import 'membership.dart';
import 'membership_logged.dart';
import 'system_settings.dart';
import 'sign_up.dart';
import 'profile.dart';
import 'sign_off.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation Index Tracking:
  // 0=Home, 1=About, 2=Donate, 3=Volunteer, 4=Membership, 5=System Settings, 6=Profile/Auth
  int _currentStep = 0;

  // Foundational Session Variable: Drives the conditional view-switching behavior
  bool _mockIsLoggedIn = false;

  /// Centralized navigation state processor
  void _handleNavigation(int selectedValue) {
    if (selectedValue == 99) {
      // Sign-off remains an external workflow that gracefully routes outside the shell
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignOffPage()),
      );
    } else {
      setState(() {
        _currentStep = selectedValue;
      });
    }
  }

  /// Interactive session toggler (Placed here to test active vs guest layout switches instantly)
  void _toggleDevelopmentAuth() {
    setState(() {
      _mockIsLoggedIn = !_mockIsLoggedIn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _mockIsLoggedIn ? 'Session Auth: ACTIVE' : 'Session Auth: GUEST',
        ),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
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
              // Profile Action: Triggers uniform inside-the-body workspace switches
              IconButton(
                icon: Icon(
                  _mockIsLoggedIn
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  color: _mockIsLoggedIn ? Colors.amber : Colors.white,
                ),
                onPressed: () => _handleNavigation(6),
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

          // 2. UNIFORM MAIN BODY WRAPPER
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

          // Floating toggle switch used only to evaluate Auth vs Guest layouts effortlessly
          floatingActionButton: FloatingActionButton.small(
            backgroundColor: Colors.amber,
            onPressed: _toggleDevelopmentAuth,
            child: const Icon(Icons.cached, color: Colors.indigo),
          ),
        );
      },
    );
  }

  /// Evaluates state to determine exactly which component module updates the inline workspace
  Widget _buildActivePageLayout() {
    switch (_currentStep) {
      case 1:
        return const Center(child: Text('About Us Content View'));
      case 2:
        return _mockIsLoggedIn ? const DonateLoggedPage() : const DonatePage();
      case 3:
        return _mockIsLoggedIn
            ? const VolunteerLoggedPage()
            : const VolunteerPage();
      case 4:
        return _mockIsLoggedIn
            ? const MembershipLoggedPage()
            : const MembershipPage();
      case 5:
        return const SystemSettingsPage();
      case 6:
        // Dynamic profile management routing block embedded straight into the application frame body
        return _mockIsLoggedIn ? const ProfilePage() : const SignUpPage();
      case 0:
      default:
        return LandingHubView(onNavigate: _handleNavigation);
    }
  }
}
