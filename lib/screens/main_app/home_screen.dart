import 'package:flutter/material.dart';
import 'package:cangrant/models/grant.dart';
import 'package:cangrant/services/grant_service.dart';
import 'package:cangrant/services/supabase_service.dart';
import 'package:cangrant/screens/main_app/filter_dialog.dart';
import 'package:cangrant/screens/main_app/grant_detail_screen.dart';
import 'package:cangrant/screens/paywall/metered_paywall_screen.dart';
import 'package:cangrant/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Grant> _allGrants = [];
  List<Grant> _filteredGrants = [];
  String _searchQuery = '';
  List<String> _selectedStatuses = [];
  List<String> _selectedEligibilityTags = [];

  @override
  void initState() {
    super.initState();
    _loadGrants();
  }

  Future<void> _loadGrants() async {
    try {
      final grants = await GrantService.loadGrants();
      if (mounted) {
        setState(() {
          _allGrants = grants;
          _filteredGrants = List.from(grants);
          _sortGrants(); // Apply sorting on initial load
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading grants: $e')));
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredGrants = GrantService.filterGrants(
        grants: _allGrants,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        statusFilters: _selectedStatuses.isEmpty ? null : _selectedStatuses,
        eligibilityFilters: _selectedEligibilityTags.isEmpty
            ? null
            : _selectedEligibilityTags,
      );
      // Apply custom sorting after filtering
      _sortGrants();
    });
  }

  void _sortGrants() {
    _filteredGrants.sort((a, b) {
      // Priority order: Open -> Rolling Basis -> Coming Soon -> Closed
      final statusPriority = {
        'Open': 1,
        'Rolling Basis': 2,
        'Coming Soon': 3,
        'Closed': 4,
      };

      final aPriority = statusPriority[a.status] ?? 999;
      final bPriority = statusPriority[b.status] ?? 999;

      // First, sort by status priority
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }

      // If both are "Open", sort by deadline (closest first)
      if (a.status == 'Open' && b.status == 'Open') {
        if (a.deadline != null && b.deadline != null) {
          try {
            final aDate = DateTime.parse(a.deadline!);
            final bDate = DateTime.parse(b.deadline!);
            return aDate.compareTo(bDate); // Earlier dates first
          } catch (e) {
            // If parsing fails, maintain current order
            return 0;
          }
        }
        // If one has deadline and other doesn't, prioritize the one with deadline
        if (a.deadline != null) return -1;
        if (b.deadline != null) return 1;
      }

      // For same status but not Open, maintain current order
      return 0;
    });
  }

  Future<void> _showFilterDialog() async {
    // Predefined status options
    final allStatuses = ['Open', 'Closed', 'Coming Soon', 'Rolling Basis'];

    // Predefined eligibility options (only these 3)
    final allTags = ['Non-profit', 'Corporation', 'Charity'];

    final result = await showDialog<Map<String, List<String>>>(
      context: context,
      builder: (context) => FilterDialog(
        allStatuses: allStatuses,
        allEligibilityTags: allTags,
        selectedStatuses: _selectedStatuses,
        selectedEligibilityTags: _selectedEligibilityTags,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedStatuses = result['statuses'] ?? [];
        _selectedEligibilityTags = result['eligibilityTags'] ?? [];
      });
      _applyFilters();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  Future<void> _openGrantDetail(Grant grant) async {
    final supabaseService = SupabaseService();
  
    // Check if user has active subscription
    final hasSubscription = await supabaseService.hasActiveSubscription();
  
    if (hasSubscription) {
      // Premium user - direct access
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GrantDetailScreen(grant: grant),
          ),
        );
      }
      return;
    }
  
    // Free user - check view count
    final freeViewsRemaining = await supabaseService.getFreeViewsRemaining();
  
    if (freeViewsRemaining > 0) {
      // Has free views left - allow access and decrement
      final newCount = await supabaseService.decrementFreeViews();
    
      // Show subtle notification
      if (mounted && newCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$newCount free view${newCount == 1 ? '' : 's'} remaining'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange[700],
          ),
        );
      }
    
      // Navigate to detail
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GrantDetailScreen(grant: grant),
          ),
        );
      }
    } else {
      // No free views left - show paywall
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MeteredPaywallScreen(viewsUsed: 3),
          ),
        );
      
        // If user subscribed, refresh and allow access
        if (result == true && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GrantDetailScreen(grant: grant),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title only, no icon, no subtitle
                  Text(
                    localizations.translate('discover_grants'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  TextField(
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: localizations.translate('search_grants'),
                      hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFBDBDBD),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filters button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showFilterDialog,
                      icon: const Icon(Icons.filter_list),
                      label: Text(localizations.translate('filter')),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grants count
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredGrants.length} ${localizations.translate('grants_found')}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF424242),
                  ),
                ),
              ),
            ),

            // Grants list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredGrants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.translate('no_grants_found'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.translate('adjust_filters'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _filteredGrants.length,
                      itemBuilder: (context, index) {
                        final grant = _filteredGrants[index];
                        return _buildGrantCard(grant);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: InkWell(
        onTap: () => _openGrantDetail(grant),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                grant.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Tags - show status first, then all other tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusChip(grant),
                  ...grant.getAllTags().map((tag) => _buildTagChip(grant, tag)),
                ],
              ),

              const SizedBox(height: 16),

              // Amount
              Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 18,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatNumber(grant.amountMax),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}
