import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          'Privacy Policy for Vicinum Club LLC',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Effective Date: 19-Feb-2025',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'This Privacy Policy describes how vicinum.com collects, uses, and shares your personal information when you visit or interact with our website (the "Site") dedicated to marketing campaigns for fundraising on behalf of non-profit organizations. We are committed to protecting your privacy and complying with applicable data protection laws, including the California Consumer Privacy Act (CCPA) and other relevant regulations. This policy also addresses our compliance with 10DLC regulations for SMS/MMS messaging.',
          style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
        ),
        const SizedBox(height: 10),

        _section(
          '1. Information We Collect',
          'We may collect the following types of information:\n\n'
              '• Personal Information You Provide: When you donate, sign up for updates, contact us, or otherwise interact with the Site, you may provide us with personal information such as your name, email address, postal address, phone number, payment information (processed by a secure third-party payment processor), and any other information you choose to share.\n\n'
              '• Automatically Collected Information: When you visit the Site, we may automatically collect certain information about your device and usage, including your IP address, browser type, operating system, referring website, pages viewed, and timestamps. We may use cookies, web beacons, and other tracking technologies to collect this information.\n\n'
              '• SMS/MMS Information (if applicable): If you opt-in to receive SMS/MMS messages from us or the non-profit organizations we represent, we will collect your phone number and information related to your engagement with our messaging campaigns. We will comply with all applicable 10DLC regulations, including obtaining your express consent to receive messages, providing clear opt-out instructions, and adhering to message content and frequency guidelines.',
        ),

        _section(
          '2. How We Use Your Information',
          'We may use your information for the following purposes:\n\n'
              '• Providing and Improving the Site: We use your information to operate and maintain the Site, personalize your experience, and improve its functionality.\n\n'
              '• Processing Donations: We use your payment information to process your donations to the non-profit organizations we represent. We do not store your payment card details directly; this information is handled by our secure third-party payment processor.\n\n'
              '• Communicating with You: We may use your contact information to send you updates about our campaigns, fundraising efforts, and the non-profit organizations we support. We will only send you marketing communications if you have opted-in to receive them, and you can opt-out at any time.\n\n'
              '• SMS/MMS Messaging (if applicable): We will use your phone number to send you SMS/MMS messages related to the campaigns you opted into. These messages may include donation requests, event updates, and other relevant information.\n\n'
              '• Legal Compliance: We may use your information to comply with applicable laws and regulations.\n\n'
              '• Analytics: We may use your information to analyze website usage and trends to improve the Site and our marketing efforts.',
        ),

        _section(
          '3. Sharing Your Information',
          'We may share your information with the following third parties:\n\n'
              '• Direct Donors: We will share your information with the non-profit organization(s) for which you have donated or expressed interest. These organizations may use your information for their own fundraising and communication purposes, in accordance with their own privacy policies. We encourage you to review the privacy policies of the non-profit organizations you support.\n\n'
              '• Service Providers: We may share your information with third-party service providers who assist us with website hosting, data analytics, payment processing, email marketing, and other services. These service providers are contractually obligated to protect your information and only use it for the purposes we specify.\n\n'
              '• Legal Authorities: We may disclose your information to legal authorities if required by law or legal process.\n\n'
              '• Exclusions: All other categories exclude text messaging originator opt-in data and consent will not be shared with any third parties.',
        ),

        _section(
          '4. Your Choices',
          '• Opt-Out: You can opt-out of receiving marketing communications from us at any time by clicking the "unsubscribe" link in our emails or contacting us directly. For SMS/MMS messages, you can reply "STOP" to opt-out.\n\n'
              '• Cookies: You can control the use of cookies through your browser settings. However, disabling cookies may affect the functionality of the Site.',
        ),

        _section(
          '5. Data Security',
          'We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no data transmission over the internet or electronic storage method is 100% secure.',
        ),

        _section(
          '6. Children\'s Privacy',
          'Our Site is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.',
        ),

        _section(
          '7. Changes to this Privacy Policy',
          'We may update this Privacy Policy from time to time. We will post any changes on the Site and encourage you to review it periodically.',
        ),

        _section(
          '8. Contact Us',
          'If you have any questions about this Privacy Policy, please contact us at:\n'
              'Vicinum Club LLC\n'
              '379 Cheney Hwy. #396, Titusville, FL 32780, US',
        ),

        _section(
          '9. 10DLC Compliance',
          'We adhere to all applicable 10DLC regulations for SMS/MMS messaging, including:\n\n'
              '• Express Consent: We will only send SMS/MMS messages to individuals who have provided their express consent to receive them.\n\n'
              '• Opt-Out: We will provide clear and conspicuous opt-out instructions in all SMS/MMS messages. Message and Data Rates may apply. You can STOP messaging by sending STOP and get more help by sending HELP.\n\n'
              '• Content and Frequency: We will adhere to message content and frequency guidelines established by mobile carriers and CTIA.\n\n'
              '• Campaign Registration: We will register our SMS/MMS campaigns with the appropriate authorities.',
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _section(String heading, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
