import 'package:mygrants/models/grant.dart';
import 'package:mygrants/services/supabase_service.dart';

class GrantService {
  static List<Grant>? _cachedGrants;
  static final _supabase = SupabaseService();

  /// Load grants from Supabase database
  static Future<List<Grant>> loadGrants({bool forceRefresh = false}) async {
    // Return cached grants if available and not forcing refresh
    if (_cachedGrants != null && !forceRefresh) {
      return _cachedGrants!;
    }

    try {
      // Fetch grants with all their tags from Supabase
      final response = await _supabase.client
          .from('grants')
          .select('''
            id,
            title,
            list_summary,
            full_details,
            status,
            application_open_date,
            deadline,
            amount_max,
            issuing_body,
            grant_link,
            grant_eligibility!inner(eligibility_tags(name)),
            grant_industries!inner(industry_tags(name)),
            grant_types!inner(type_tags(name))
          ''')
          .eq('is_active', true)
          .order('updated_at', ascending: false);

      // Convert response to Grant objects
      final grants = (response as List).map((grantData) {
        // Extract tags from the nested structure
        final eligibilityTags =
            (grantData['grant_eligibility'] as List?)
                ?.map((e) => e['eligibility_tags']['name'] as String)
                .toList() ??
            [];

        final industryTags =
            (grantData['grant_industries'] as List?)
                ?.map((e) => e['industry_tags']['name'] as String)
                .toList() ??
            [];

        final typeTags =
            (grantData['grant_types'] as List?)
                ?.map((e) => e['type_tags']['name'] as String)
                .toList() ??
            [];

        // Create Grant object with database data
        return Grant(
          id: grantData['id'] as int,
          title: grantData['title'] as String,
          listSummary: grantData['list_summary'] as String,
          fullDetails: grantData['full_details'] as String,
          status: grantData['status'] as String,
          applicationOpenDate: grantData['application_open_date'] as String?,
          deadline: grantData['deadline'] as String?,
          amountMax: grantData['amount_max'] as int,
          issuingBody: grantData['issuing_body'] as String,
          grantLink: grantData['grant_link'] as String,
          eligibilityTags: eligibilityTags,
          industryTags: industryTags,
          typeTags: typeTags,
        );
      }).toList();

      // Cache the results
      _cachedGrants = grants;
      return grants;
    } catch (e) {
      print('Error loading grants from database: $e');
      return [];
    }
  }

  /// Clear the cache to force fresh data on next load
  static void clearCache() {
    _cachedGrants = null;
  }

  static List<Grant> filterGrants({
    required List<Grant> grants,
    String? searchQuery,
    List<String>? statusFilters,
    List<String>? eligibilityFilters,
  }) {
    List<Grant> filtered = List.from(grants);

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((grant) {
        final query = searchQuery.toLowerCase();
        return grant.title.toLowerCase().contains(query) ||
            grant.listSummary.toLowerCase().contains(query) ||
            grant.issuingBody.toLowerCase().contains(query);
      }).toList();
    }

    // Apply status filters
    if (statusFilters != null && statusFilters.isNotEmpty) {
      filtered = filtered.where((grant) {
        return statusFilters.contains(grant.status);
      }).toList();
    }

    // Apply eligibility filters
    if (eligibilityFilters != null && eligibilityFilters.isNotEmpty) {
      filtered = filtered.where((grant) {
        return grant.eligibilityTags.any(
          (tag) => eligibilityFilters.contains(tag),
        );
      }).toList();
    }

    return filtered;
  }

  static Set<String> getAllStatuses(List<Grant> grants) {
    return grants.map((g) => g.status).toSet();
  }

  static Set<String> getAllEligibilityTags(List<Grant> grants) {
    final Set<String> allTags = {};
    for (var grant in grants) {
      allTags.addAll(grant.eligibilityTags);
    }
    return allTags;
  }
}
