import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mygrants/models/grant.dart';

class GrantService {
  static List<Grant>? _cachedGrants;

  static Future<List<Grant>> loadGrants() async {
    if (_cachedGrants != null) {
      return _cachedGrants!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/grants.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> grantsJson = jsonData['grants'] as List;

      _cachedGrants = grantsJson.map((json) => Grant.fromJson(json)).toList();
      return _cachedGrants!;
    } catch (e) {
      print('Error loading grants: $e');
      return [];
    }
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
