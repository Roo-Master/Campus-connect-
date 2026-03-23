import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // App Logo
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent.shade100,
              child: const Icon(
                Icons.privacy_tip,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Introduction Section
            _buildCard(
              title: 'Introduction',
              content:
              'This Privacy Policy explains what data we collect, how we use it, and your rights regarding your personal information. Your privacy is important to us.',
            ),

            const SizedBox(height: 16),

            // Data Collection
            _buildCard(
              title: 'Data Collection',
              content:
              'We collect personal information such as your name, email address, and preferences. Additionally, we may collect usage data, device information, and location data to improve app functionality.',
            ),

            const SizedBox(height: 16),

            // Data Usage
            _buildCard(
              title: 'Data Usage',
              content:
              'The information we collect is used to personalize your experience, provide services, send updates, and improve the app. Your data will never be sold to third parties.',
            ),

            const SizedBox(height: 16),

            // Data Sharing & Third Parties
            _buildCard(
              title: 'Data Sharing & Third Parties',
              content:
              'We do not share your personal information with third parties without your consent, except to comply with legal requirements or to provide services you request (e.g., payment processors, analytics services).',
            ),

            const SizedBox(height: 16),

            // User Rights
            _buildCard(
              title: 'Your Rights',
              content:
              'You have the right to access, correct, or delete your personal data at any time. You can also opt out of marketing communications. Contact us at support@yourcompany.com to exercise these rights.',
            ),

            const SizedBox(height: 16),

            // Security Measures
            _buildCard(
              title: 'Security',
              content:
              'We implement industry-standard security measures to protect your data from unauthorized access, disclosure, alteration, or destruction. However, no system is 100% secure, and you use the app at your own risk.',
            ),

            const SizedBox(height: 16),

            // Contact Information
            _buildCard(
              title: 'Contact Us',
              content:
              'For questions or concerns regarding your privacy, please contact us at:\n\nEmail: support@roomaster_company.com\nPhone: +254 759090440\nAddress: 40101 , Kisii, Kisii County\nWebsite: www.roomastercompany.com',
            ),

            const SizedBox(height: 16),

            // Updates to Privacy Policy
            _buildCard(
              title: 'Updates to Privacy Policy',
              content:
              'We may update this Privacy Policy from time to time. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Helper method to build a card section
  Widget _buildCard({required String title, required String content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}