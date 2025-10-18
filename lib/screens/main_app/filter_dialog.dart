import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final List<String> allStatuses;
  final List<String> allEligibilityTags;
  final List<String> selectedStatuses;
  final List<String> selectedEligibilityTags;

  const FilterDialog({
    super.key,
    required this.allStatuses,
    required this.allEligibilityTags,
    required this.selectedStatuses,
    required this.selectedEligibilityTags,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> _selectedStatuses;
  late List<String> _selectedEligibilityTags;
  String? _statusFilter;
  String? _eligibilityFilter;

  @override
  void initState() {
    super.initState();
    _selectedStatuses = List.from(widget.selectedStatuses);
    _selectedEligibilityTags = List.from(widget.selectedEligibilityTags);

    // Set initial radio button states
    if (_selectedStatuses.isEmpty) {
      _statusFilter = 'All Status';
    } else if (_selectedStatuses.length == widget.allStatuses.length) {
      _statusFilter = 'All Status';
    }

    if (_selectedEligibilityTags.isEmpty) {
      _eligibilityFilter = 'All Eligibility';
    } else if (_selectedEligibilityTags.length ==
        widget.allEligibilityTags.length) {
      _eligibilityFilter = 'All Eligibility';
    }
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'statuses': _selectedStatuses,
      'eligibilityTags': _selectedEligibilityTags,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status section
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<String>(
                      title: const Text('All Status'),
                      value: 'All Status',
                      groupValue: _statusFilter,
                      onChanged: (value) {
                        setState(() {
                          _statusFilter = value;
                          _selectedStatuses.clear();
                        });
                      },
                    ),
                    ...widget.allStatuses.map((status) {
                      return CheckboxListTile(
                        title: Text(status),
                        value: _selectedStatuses.contains(status),
                        onChanged: (bool? value) {
                          setState(() {
                            _statusFilter = null;
                            if (value == true) {
                              _selectedStatuses.add(status);
                            } else {
                              _selectedStatuses.remove(status);
                            }
                          });
                        },
                      );
                    }),

                    const SizedBox(height: 24),

                    // Eligibility section
                    const Text(
                      'Eligibility',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<String>(
                      title: const Text('All Eligibility'),
                      value: 'All Eligibility',
                      groupValue: _eligibilityFilter,
                      onChanged: (value) {
                        setState(() {
                          _eligibilityFilter = value;
                          _selectedEligibilityTags.clear();
                        });
                      },
                    ),
                    ...widget.allEligibilityTags.map((tag) {
                      return CheckboxListTile(
                        title: Text(tag),
                        value: _selectedEligibilityTags.contains(tag),
                        onChanged: (bool? value) {
                          setState(() {
                            _eligibilityFilter = null;
                            if (value == true) {
                              _selectedEligibilityTags.add(tag);
                            } else {
                              _selectedEligibilityTags.remove(tag);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Show Results',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
