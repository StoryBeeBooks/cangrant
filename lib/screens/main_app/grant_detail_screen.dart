import 'package:flutter/material.dart';
import 'package:cangrant/models/grant.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GrantDetailScreen extends StatefulWidget {
  final Grant grant;

  const GrantDetailScreen({super.key, required this.grant});

  @override
  State<GrantDetailScreen> createState() => _GrantDetailScreenState();
}

class _GrantDetailScreenState extends State<GrantDetailScreen> {
  bool _isSaved = false;

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    // TODO: Persist save state
  }

  Future<void> _launchGrantWebsite() async {
    // TODO: Add actual grant website URL to JSON
    final Uri url = Uri.parse(
      'https://www.canada.ca/en/services/business/grants.html',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch website')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Purple header with title
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.grant.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.white,
                            ),
                            onPressed: _toggleSave,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Issuing body
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E35B1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            color: Color(0xFF5E35B1),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.grant.issuingBody,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Status tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildStatusChip(widget.grant.status),
                        ...widget.grant.eligibilityTags.map(
                          (tag) => _buildTagChip(tag),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Award amount
                    _buildInfoCard(
                      icon: Icons.attach_money,
                      iconColor: const Color(0xFF4CAF50),
                      iconBgColor: const Color(0xFF4CAF50).withOpacity(0.1),
                      title: 'Award Amount',
                      value:
                          '\$${NumberFormat('#,###').format(widget.grant.amountMax)}',
                    ),

                    const SizedBox(height: 16),

                    // Application deadline
                    if (widget.grant.deadline != null)
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        iconColor: const Color(0xFFFF9800),
                        iconBgColor: const Color(0xFFFF9800).withOpacity(0.1),
                        title: 'Application Deadline',
                        value: _formatDate(widget.grant.deadline!),
                      ),

                    const SizedBox(height: 32),

                    // Status and Industry grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridItem('Status', widget.grant.status),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGridItem(
                            'Industry',
                            _getIndustryFromTags(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Eligibility and Funding Level grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridItem(
                            'Eligibility',
                            _getEligibilityFromTags(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGridItem(
                            'Funding Level',
                            _getFundingLevelFromTags(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // About This Grant
                    Row(
                      children: [
                        const Icon(Icons.description, color: Color(0xFF5E35B1)),
                        const SizedBox(width: 8),
                        const Text(
                          'About This Grant',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      widget.grant.fullDetails,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF424242),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Visit Grant Website button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _launchGrantWebsite,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text(
                          'Visit Grant Website',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.grant.getStatusColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.grant.getTagColor(tag),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Color(0xFF212121),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getIndustryFromTags() {
    final industries = ['Art', 'Education', 'Environment', 'Employment'];
    for (var tag in widget.grant.eligibilityTags) {
      if (industries.any((i) => tag.toLowerCase().contains(i.toLowerCase()))) {
        return tag;
      }
    }
    return 'General';
  }

  String _getEligibilityFromTags() {
    final eligibilities = ['Non-profit', 'Charity', 'For Corporations'];
    for (var tag in widget.grant.eligibilityTags) {
      if (eligibilities.any(
        (e) => tag.toLowerCase().contains(e.toLowerCase()),
      )) {
        return tag;
      }
    }
    return 'Open';
  }

  String _getFundingLevelFromTags() {
    final levels = ['Federal', 'Provincial', 'City', 'Company'];
    for (var tag in widget.grant.eligibilityTags) {
      if (levels.any((l) => tag.toLowerCase().contains(l.toLowerCase()))) {
        return tag;
      }
    }
    return 'N/A';
  }
}
