import 'package:flutter/material.dart';

class Grant {
  final int id;
  final String title;
  final String listSummary;
  final String fullDetails;
  final String status;
  final String? deadline;
  final int amountMax;
  final String issuingBody;
  final List<String> eligibilityTags;

  Grant({
    required this.id,
    required this.title,
    required this.listSummary,
    required this.fullDetails,
    required this.status,
    this.deadline,
    required this.amountMax,
    required this.issuingBody,
    required this.eligibilityTags,
  });

  factory Grant.fromJson(Map<String, dynamic> json) {
    return Grant(
      id: json['id'] as int,
      title: json['title'] as String,
      listSummary: json['list_summary'] as String,
      fullDetails: json['full_details'] as String,
      status: json['status'] as String,
      deadline: json['deadline'] as String?,
      amountMax: json['amount_max'] as int,
      issuingBody: json['issuing_body'] as String,
      eligibilityTags: List<String>.from(json['eligibility_tags'] as List),
    );
  }

  // Get color for status badge
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF4CAF50);
      case 'closing soon':
        return const Color(0xFFFF9800);
      case 'closed':
        return const Color(0xFF9E9E9E);
      case 'rolling basis':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF757575);
    }
  }

  // Get color for tag categories
  Color getTagColor(String tag) {
    final tagLower = tag.toLowerCase();

    // Industry/Topic tags
    if (tagLower.contains('art')) return const Color(0xFFE1BEE7);
    if (tagLower.contains('education')) return const Color(0xFF90CAF9);
    if (tagLower.contains('environment')) return const Color(0xFFA5D6A7);
    if (tagLower.contains('employment')) return const Color(0xFFFFAB91);

    // Eligibility tags
    if (tagLower.contains('non-profit')) return const Color(0xFFCE93D8);
    if (tagLower.contains('charity')) return const Color(0xFFF48FB1);
    if (tagLower.contains('corporation') ||
        tagLower.contains('for corporations')) {
      return const Color(0xFFFFCC80);
    }

    // Level tags
    if (tagLower.contains('federal')) return const Color(0xFF80DEEA);
    if (tagLower.contains('provincial')) return const Color(0xFF9FA8DA);
    if (tagLower.contains('city') || tagLower.contains('municipal')) {
      return const Color(0xFFBCAAA4);
    }
    if (tagLower.contains('company')) return const Color(0xFFEF9A9A);

    return const Color(0xFFE0E0E0);
  }
}
