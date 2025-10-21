import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mygrants/services/supabase_service.dart';
import 'dart:convert';

class UpdateBusinessProfileScreen extends StatefulWidget {
  const UpdateBusinessProfileScreen({super.key});

  @override
  State<UpdateBusinessProfileScreen> createState() =>
      _UpdateBusinessProfileScreenState();
}

class _UpdateBusinessProfileScreenState
    extends State<UpdateBusinessProfileScreen> {
  int _currentStep = 0;
  final int _totalSteps = 9;

  // Store user's answers
  Map<String, dynamic> _answers = {};
  bool _isLoading = true;

  // Question configuration
  final List<Map<String, dynamic>> _questions = [
    {
      'title': 'What is your legal structure?',
      'key': 'legal_structure',
      'type': 'options',
      'options': [
        'Non-Profit',
        'For-Profit',
        'Sole Proprietor',
        'Partnership',
        'Other',
      ],
    },
    {
      'title': 'Which province are you located in?',
      'key': 'province',
      'type': 'dropdown',
      'options': [
        'Alberta',
        'British Columbia',
        'Manitoba',
        'New Brunswick',
        'Newfoundland and Labrador',
        'Nova Scotia',
        'Ontario',
        'Prince Edward Island',
        'Quebec',
        'Saskatchewan',
      ],
    },
    {
      'title': 'What is your industry?',
      'key': 'industry',
      'type': 'text',
      'hint': 'e.g., Technology, Agriculture, Arts',
    },
    {
      'title': 'What is your annual revenue?',
      'key': 'annual_revenue',
      'type': 'options',
      'options': [
        'Under \$100,000',
        '\$100,000 - \$500,000',
        '\$500,000 - \$1,000,000',
        'Over \$1,000,000',
      ],
    },
    {
      'title': 'How many employees do you have?',
      'key': 'employee_count',
      'type': 'options',
      'options': ['1-5', '6-20', '21-50', '51-100', '100+'],
    },
    {
      'title': 'What is your primary goal?',
      'key': 'primary_goal',
      'type': 'options',
      'options': [
        'Expansion',
        'Research & Development',
        'Hiring',
        'Equipment',
        'Marketing',
      ],
    },
    {
      'title': 'Are you Indigenous-owned?',
      'key': 'indigenous_owned',
      'type': 'boolean',
    },
    {
      'title': 'Are you minority-owned?',
      'key': 'minority_owned',
      'type': 'boolean',
    },
    {'title': 'Are you woman-owned?', 'key': 'woman_owned', 'type': 'boolean'},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('business_profile');

    if (profileJson != null) {
      setState(() {
        _answers = Map<String, dynamic>.from(json.decode(profileJson));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _saveProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      // Save to local storage (for offline access)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('business_profile', json.encode(_answers));

      // Save to Supabase database
      final supabaseService = SupabaseService();
      final userId = supabaseService.getCurrentUser()?.id;

      if (userId == null) {
        print('DEBUG: No user ID found - user might not be logged in');
        throw Exception('User not logged in');
      }

      print('DEBUG: Saving business profile for user: $userId');
      print('DEBUG: Profile data: $_answers');
      print(
        'DEBUG: Auth session: ${supabaseService.client.auth.currentSession?.user.email}',
      );

      // Try the update with better error handling
      try {
        final response = await supabaseService.client
            .from('profiles')
            .update({'business_profile': _answers})
            .eq('user_id', userId)
            .select()
            .single();

        print('DEBUG: Update successful! Response: $response');
      } catch (dbError) {
        print('DEBUG: Database error: $dbError');
        print('DEBUG: Error type: ${dbError.runtimeType}');
        rethrow;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      print('DEBUG: Error saving profile: $e');
      print('DEBUG: Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildQuestionWidget() {
    final question = _questions[_currentStep];
    final String type = question['type'];

    switch (type) {
      case 'options':
        return _buildOptionsQuestion(question);
      case 'dropdown':
        return _buildDropdownQuestion(question);
      case 'text':
        return _buildTextQuestion(question);
      case 'boolean':
        return _buildBooleanQuestion(question);
      default:
        return const SizedBox();
    }
  }

  Widget _buildOptionsQuestion(Map<String, dynamic> question) {
    final options = question['options'] as List<String>;
    final key = question['key'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: options.map((option) {
        final isSelected = _answers[key] == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _answers[key] = option;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: isSelected
                  ? const Color(0xFF5E35B1)
                  : Colors.grey[200],
              foregroundColor: isSelected ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(option, style: const TextStyle(fontSize: 16)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownQuestion(Map<String, dynamic> question) {
    final options = question['options'] as List<String>;
    final key = question['key'] as String;

    return DropdownButtonFormField<String>(
      initialValue: _answers[key],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: options.map((option) {
        return DropdownMenuItem(value: option, child: Text(option));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _answers[key] = value;
        });
      },
    );
  }

  Widget _buildTextQuestion(Map<String, dynamic> question) {
    final key = question['key'] as String;
    final hint = question['hint'] as String?;

    return TextFormField(
      initialValue: _answers[key],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        hintText: hint,
      ),
      onChanged: (value) {
        _answers[key] = value;
      },
    );
  }

  Widget _buildBooleanQuestion(Map<String, dynamic> question) {
    final key = question['key'] as String;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _answers[key] = true;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: _answers[key] == true
                  ? const Color(0xFF5E35B1)
                  : Colors.grey[200],
              foregroundColor: _answers[key] == true
                  ? Colors.white
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Yes', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _answers[key] = false;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: _answers[key] == false
                  ? const Color(0xFF5E35B1)
                  : Colors.grey[200],
              foregroundColor: _answers[key] == false
                  ? Colors.white
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('No', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _questions[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of $_totalSteps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentStep > 0
              ? _previousStep
              : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF5E35B1),
                ),
              ),
              const SizedBox(height: 32),

              // Question title
              Text(
                question['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Question content
              Expanded(
                child: SingleChildScrollView(child: _buildQuestionWidget()),
              ),

              // Next button for non-option questions
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentStep < _totalSteps - 1 ? 'Next' : 'Save Profile',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
