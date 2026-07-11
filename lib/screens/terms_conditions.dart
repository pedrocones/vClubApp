import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          'Terms and Conditions for Vicinum Club LLC',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Effective Date: 14-Feb-2025',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),

        _section(
          '1. Introduction',
          'Welcome to Vicinum.com operated by Vicinum Club LLC. These Terms and Conditions ("Terms") govern your access to and use of the Website, including all content, features, and services available on or through the Website. By accessing or using the Website, you agree to be bound by these Terms. If you do not agree with these Terms, please do not access or use the Website.',
        ),

        _section(
          '2. Purpose of the Website',
          'This Website is a platform designed to facilitate marketing campaigns for fundraising purposes on behalf of non-profit organizations ("Non-Profits"). We act as an intermediary, connecting Non-Profits with potential donors and providing tools to promote their fundraising initiatives. We are not a Non-Profit ourselves, however acting as LLC which have taxable implications only for our own fees collection and distributions.',
        ),

        _section(
          '3. User Responsibilities',
          '• Accuracy of Information: You are responsible for providing accurate and up-to-date information when using the Website, including when making donations or registering for events.\n\n'
              '• Compliance with Laws: You agree to comply with all applicable laws and regulations when using the Website, including those related to charitable donations, data privacy, and marketing communications.\n\n'
              '• Prohibited Activities: You agree not to: use the Website for any illegal purpose; impersonate any person or entity; interfere with or disrupt the operation of the Website; use automated tools like robots, spiders, or scrapers to collect data; engage in activity that overburdens the infrastructure; or distribute spam, viruses, or harmful code.',
        ),

        _section(
          '4. Non-Profit Responsibilities',
          'Non-Profits using the Website are responsible for: ensuring the accuracy and completeness of all information provided about their organization; complying with all applicable laws related to charitable solicitations; utilizing donated funds solely for the purposes stated in their campaigns; providing regular updates to donors; and complying with all applicable data privacy laws, including obtaining necessary user consents.',
        ),

        _section(
          '5. Donations',
          '• Donation Processing: Donations made through the Website will be processed by our Selected Payment Processor(s). You agree to be bound by the terms and conditions of the payment processor.\n\n'
              '• Donation Receipts: Non-Profits are responsible for providing donation receipts to donors.\n\n'
              '• Refunds: Refunds of donations are subject to the policies of the individual Non-Profit and applicable law. We are not responsible for processing refunds.\n\n'
              '• Tax Deductibility: We do not guarantee the tax deductibility of any donation. Donors should consult with their tax advisor.',
        ),

        _section(
          '6. SMS/MMS Marketing (10DLC Compliance)',
          '• Consent: For SMS/MMS marketing, Non-Profits must obtain express prior written consent from recipients before sending any messages. This consent must comply with all applicable regulations, including those related to TCPA and CTIA guidelines.\n\n'
              '• Message Content: All SMS/MMS messages must clearly identify the Non-Profit sending the message and provide a clear description of the campaign.\n\n'
              '• Opt-Out: Recipients must be provided with an easy way to opt-out. Instructions must be included in every message. Standard keywords like "STOP," "QUIT," "END," "UNSUBSCRIBE," and "CANCEL" must be recognized and honored.\n\n'
              '• Campaign Registration: Non-Profits are responsible for registering their SMS/MMS campaigns with the appropriate 10DLC campaign registry and obtaining Carrier vetting.\n\n'
              '• Content Restrictions: Prohibited content includes but is not limited to: profane language, hate speech, misleading information, and unsolicited commercial messages unrelated to the Non-Profit’s mission.\n\n'
              '• Compliance: Non-Profits must ensure their marketing practices comply with the Telephone Consumer Protection Act (TCPA), Cellular Telecommunications Industry Association (CTIA) guidelines, and all other relevant regulations.',
        ),

        _section(
          '7. Intellectual Property',
          'All content on the Website, including text, graphics, logos, images, and software, is the property of Vicinum Club LLC or its licensors and is protected by copyright and other intellectual property laws.',
        ),

        _section(
          '8. Disclaimer of Warranties',
          'The Website is provided "as is" and without any warranties of any kind, either express or implied. We do not warrant that the Website will be uninterrupted, error-free, or that any defects will be corrected.',
        ),

        _section(
          '9. Limitation of Liability',
          'We will not be liable for any damages arising out of or in connection with your use of the Website, including but not limited to direct, indirect, incidental, consequential, or punitive damages.',
        ),

        _section(
          '10. Governing Law',
          'These Terms will be governed by and construed in accordance with the laws of Florida, USA.',
        ),

        _section(
          '11. Changes to Terms',
          'We reserve the right to modify these Terms at any time. We will post the updated Terms on the Website, and the revised Terms will be effective upon posting. Your continued use of the Website following the posting of revised Terms means that you accept the changes.',
        ),

        _section(
          '12. Contact Us',
          'If you have any questions about these Terms, please contact us at:\n'
              'Vicinum Club LLC\n'
              '379 Cheney Hwy. #396, Titusville, FL 32780, US',
        ),

        _section(
          '13. Entire Agreement',
          'These Terms constitute the entire agreement between you and Vicinum Club LLC regarding the Website and supersede all prior and contemporaneous agreements and understandings, whether written or oral.',
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
