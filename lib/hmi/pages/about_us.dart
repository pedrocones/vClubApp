import 'package:flutter/material.dart';
import 'about_us_documents.dart';
import 'terms_conditions.dart';
import 'privacy_policy.dart';
import 'contact_us.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  // 0 = Mission/Strategy, 1 = Terms, 2 = Privacy
  int _subViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top dynamic header switches local widget viewports
        Container(
          color: Colors.indigo.shade50,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSubTabButton('Our Mission', 0),
              _buildSubTabButton('Terms', 1),
              _buildSubTabButton('Privacy', 2),
              _buildSubTabButton('Contact Us', 3),
            ],
          ),
        ),

        // Replaced view box container
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: _buildActiveSubContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabButton(String label, int index) {
    bool isActive = _subViewIndex == index;
    return TextButton(
      onPressed: () => setState(() => _subViewIndex = index),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.indigo : Colors.grey.shade600,
        backgroundColor: isActive ? Colors.white : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: isActive ? 1 : 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildActiveSubContent() {
    switch (_subViewIndex) {
      case 1:
        return const TermsConditionsPage();
      case 2:
        return const PrivacyPolicyPage();
      case 3:
        return const ContactUsPage();
      case 0:
      default:
        return const AboutUsStrategyView();
    }
  }
}
