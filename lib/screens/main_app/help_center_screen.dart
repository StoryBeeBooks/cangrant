import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  Future<void> _launchHelpCenter() async {
    // Fake link for now - replace with actual help center URL
    final Uri url = Uri.parse('https://cangrant.app/help-center');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.help_outline,
                size: 64,
                color: Color(0xFF5E35B1),
              ),
              const SizedBox(height: 24),
              const Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Visit our help center to submit a support request, browse FAQs, and find answers to common questions.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _launchHelpCenter,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text(
                    'Visit Help Center',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Quick Links',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickLink(
                icon: Icons.mail_outline,
                title: 'Email Support',
                subtitle: 'support@cangrant.app',
                onTap: () async {
                  final Uri emailUrl =
                      Uri.parse('mailto:support@cangrant.app?subject=Help Request');
                  if (await canLaunchUrl(emailUrl)) {
                    await launchUrl(emailUrl);
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildQuickLink(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                subtitle: 'Chat with our support team',
                onTap: () {
                  // TODO: Implement live chat
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Live chat coming soon!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLink({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5E35B1)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
