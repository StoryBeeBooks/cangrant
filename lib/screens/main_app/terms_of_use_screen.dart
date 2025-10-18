import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
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
                'Terms of Use',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Last updated: October 17, 2025',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '1. Acceptance of Terms',
                content:
                    'By accessing and using CanGrant, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use this service.',
              ),
              _buildSection(
                title: '2. Use of Service',
                content:
                    'CanGrant provides a platform for discovering and accessing information about grant opportunities. You agree to use this service only for lawful purposes and in accordance with these terms.',
              ),
              _buildSection(
                title: '3. User Account',
                content:
                    'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use.',
              ),
              _buildSection(
                title: '4. Grant Information',
                content:
                    'While we strive to provide accurate and up-to-date information about grants, we do not guarantee the accuracy, completeness, or timeliness of any information. Users should verify all grant details with the official grant providers.',
              ),
              _buildSection(
                title: '5. Intellectual Property',
                content:
                    'The service and its original content, features, and functionality are owned by CanGrant and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
              ),
              _buildSection(
                title: '6. Limitation of Liability',
                content:
                    'CanGrant shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
              ),
              _buildSection(
                title: '7. Third-Party Links',
                content:
                    'Our service may contain links to third-party websites or services. We are not responsible for the content, privacy policies, or practices of any third-party websites.',
              ),
              _buildSection(
                title: '8. Termination',
                content:
                    'We may terminate or suspend your account and access to the service immediately, without prior notice, for any reason, including breach of these terms.',
              ),
              _buildSection(
                title: '9. Changes to Terms',
                content:
                    'We reserve the right to modify these terms at any time. We will notify users of any material changes. Continued use of the service after changes constitutes acceptance of the new terms.',
              ),
              _buildSection(
                title: '10. Governing Law',
                content:
                    'These terms shall be governed by and construed in accordance with the laws of Canada, without regard to its conflict of law provisions.',
              ),
              _buildSection(
                title: '11. Contact Information',
                content:
                    'For any questions about these Terms of Use, please contact us at legal@cangrant.app',
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
