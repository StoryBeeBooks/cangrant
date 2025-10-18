import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Last updated: October 17, 2025',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '1. Information We Collect',
                content:
                    'We collect information you provide directly to us, including your name, email address, and any other information you choose to provide when using CanGrant.',
              ),
              _buildSection(
                title: '2. How We Use Your Information',
                content:
                    'We use the information we collect to provide, maintain, and improve our services, to communicate with you, and to personalize your experience with grant discovery.',
              ),
              _buildSection(
                title: '3. Information Sharing',
                content:
                    'We do not share your personal information with third parties except as described in this privacy policy or with your consent.',
              ),
              _buildSection(
                title: '4. Data Security',
                content:
                    'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
              ),
              _buildSection(
                title: '5. Your Rights',
                content:
                    'You have the right to access, update, or delete your personal information at any time. You can do this through your account settings or by contacting us.',
              ),
              _buildSection(
                title: '6. Cookies and Tracking',
                content:
                    'We use cookies and similar tracking technologies to track activity on our service and hold certain information to improve and analyze our service.',
              ),
              _buildSection(
                title: '7. Changes to This Policy',
                content:
                    'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.',
              ),
              _buildSection(
                title: '8. Contact Us',
                content:
                    'If you have any questions about this privacy policy, please contact us at privacy@cangrant.app',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
