import 'package:flutter/material.dart';

// --- SUB-VIEW 1: CORE STRATEGY DASHBOARD ---
class AboutUsStrategyView extends StatelessWidget {
  const AboutUsStrategyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Happier By Belonging',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pli Feliĉa Per Aparteno',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo.shade300,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.favorite, color: Colors.amber, size: 36),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3L Philosophy',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Loving Local Living',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _card(
          Icons.visibility,
          'Vision - Why',
          'Facilitate personal growth by strengthening our connection with our Neighborhood.',
        ),
        _card(
          Icons.rocket_launch,
          'Mission - What',
          'Create Synergy between People, Government, Businesses and Non-For-Profit Working together toward local sustainability.',
        ),
        _card(
          Icons.explore,
          'Purpose - How',
          'Digital platform for volunteering, fundraising, and collaboration within local communities.',
        ),
      ],
    );
  }

  Widget _card(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.indigo),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SUB-VIEW 2: TERMS AND CONDITIONS PANEL ---
class AboutUsTermsView extends StatelessWidget {
  const AboutUsTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const Text(
          'Effective Date: 14-Feb-2025',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),
        _section(
          '1. Introduction',
          'Welcome to Vicinum.com operated by Vicinum Club LLC. These Terms and Conditions govern your access to and use of the Website.',
        ),
        _section(
          '2. Purpose',
          'This Website is a platform designed to facilitate marketing campaigns for fundraising purposes on behalf of non-profit organizations.',
        ),
        _section(
          '3. 10DLC Compliance Criterion',
          'Non-Profits must obtain express prior written consent from recipients before triggering messaging campaigns.',
        ),
      ],
    );
  }

  Widget _section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// --- SUB-VIEW 3: PRIVACY STATEMENT PANEL ---
class AboutUsPrivacyView extends StatelessWidget {
  const AboutUsPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const Text(
          'Effective Date: 19-Feb-2025',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),
        _section(
          '1. Data Processing Metrics',
          'We collect voluntary personal identifiers such as name, email parameters, and tokenized billing inputs managed strictly by external checkout systems.',
        ),
        _section(
          '2. Text Opt-In Exclusion Rules',
          'All telephony metadata remains completely ring-fenced. Originator opt-in parameters and consent logs will not be transferred to third-party tracking arrays.',
        ),
      ],
    );
  }

  Widget _section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
