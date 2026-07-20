import 'package:flutter/material.dart';
import '../screens/landing_hub_view.dart';
import '../screens/donate.dart';
import '../screens/donate_logged.dart';
import '../screens/volunteer_screen.dart';
import '../screens/volunteer_logged.dart';
import '../screens/membership_screen.dart';
import '../screens/membership_logged.dart';
import '../screens/system_settings.dart';
import '../screens/sign_up_screen.dart';
import '../screens/profile.dart';
import '../screens/sign_off.dart';
import '../screens/about_us.dart';
import '../screens/contact_us.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0=Home, 1=About, 2=Donate, 3=Volunteer, 4=Membership, 5=System Settings, 6=Profile/Auth
  int _currentStep = 0;
  bool _mockIsLoggedIn = false;

  void _handleNavigation(int selectedValue) {
    if (selectedValue == 99) {
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

  @override
  Widget build(BuildContext context) {
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
                  '../../assets/branding/vicinumShield_TranspBG.png',
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
                  const PopupMenuItem(value: 7, child: Text('Contact Us')),
                  const PopupMenuItem(value: 99, child: Text('Sign Out')),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: _buildActivePageLayout(),
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
          floatingActionButton: FloatingActionButton.small(
            backgroundColor: Colors.amber,
            onPressed: () => setState(() => _mockIsLoggedIn = !_mockIsLoggedIn),
            child: const Icon(Icons.cached, color: Colors.indigo),
          ),
        );
      },
    );
  }

  Widget _buildActivePageLayout() {
    switch (_currentStep) {
      case 1:
        return const AboutUsPage();
      case 2:
        return _mockIsLoggedIn ? DonateLoggedPage() : const DonatePage();
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
        return _mockIsLoggedIn ? const ProfilePage() : const SignUpScreen();
      case 7:
        return ContactUsPage();
      case 0:
      default:
        return LandingHubView(onNavigate: _handleNavigation);
    }
  }
}
