import 'package:flutter/material.dart';
import 'package:cangrant/models/grant.dart';
import 'package:cangrant/services/grant_service.dart';
import 'package:cangrant/services/saved_grants_service.dart';
import 'package:cangrant/screens/main_app/grant_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:cangrant/l10n/app_localizations.dart';

class SavedGrantsScreen extends StatefulWidget {
  const SavedGrantsScreen({super.key});

  @override
  State<SavedGrantsScreen> createState() => _SavedGrantsScreenState();
}

class _SavedGrantsScreenState extends State<SavedGrantsScreen> {
  List<Grant> _savedGrants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedGrants();
  }

  Future<void> _loadSavedGrants() async {
    final savedIds = await SavedGrantsService.getSavedGrantIds();
    final allGrants = await GrantService.loadGrants();

    final savedGrants = allGrants
        .where((grant) => savedIds.contains(grant.id))
        .toList();

    if (mounted) {
      setState(() {
        _savedGrants = savedGrants;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('saved_grants')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${_savedGrants.length} ${localizations.translate('grants_found')}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(
                    child: _savedGrants.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bookmark_border,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  localizations.translate('no_saved_grants'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localizations.translate(
                                    'save_grants_message',
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _savedGrants.length,
                            itemBuilder: (context, index) {
                              return _buildGrantCard(_savedGrants[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGrantCard(Grant grant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GrantDetailScreen(grant: grant),
            ),
          );
          // Reload saved grants when returning from detail page
          _loadSavedGrants();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and amount row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      grant.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 20,
                        color: Color(0xFF4CAF50),
                      ),
                      Text(
                        NumberFormat('#,###').format(grant.amountMax),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Summary
              Text(
                grant.listSummary,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Deadline - Prominent display
              if (grant.deadline != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFF9800).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Deadline: ${_formatDate(grant.deadline!)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                ),

              if (grant.deadline != null) const SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusChip(grant),
                  ...grant.getAllTags().map((tag) => _buildTagChip(grant, tag)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Grant grant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: grant.getStatusColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        grant.status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTagChip(Grant grant, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: grant.getTagColor(tag),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Color(0xFF212121),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
