import 'package:flutter/material.dart';
import 'package:mygrants/screens/main_app/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 0;
  final int _totalSteps = 9;

  // Store user's answers
  final Map<String, dynamic> _answers = {};

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
    // Save profile to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('business_profile', json.encode(_answers));

    // Navigate to main screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _answers[key] = option;
              });
              _nextStep();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: _answers[key] == option
                  ? Theme.of(context).primaryColor
                  : Colors.grey[200],
              foregroundColor: _answers[key] == option
                  ? Colors.white
                  : Colors.black,
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
      decoration: const InputDecoration(border: OutlineInputBorder()),
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
        border: const OutlineInputBorder(),
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
              _nextStep();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: _answers[key] == true
                  ? Theme.of(context).primaryColor
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
              _nextStep();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: _answers[key] == false
                  ? Theme.of(context).primaryColor
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
    final question = _questions[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of $_totalSteps'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress bar
              LinearProgressIndicator(value: (_currentStep + 1) / _totalSteps),
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
              if (question['type'] != 'options' &&
                  question['type'] != 'boolean')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep < _totalSteps - 1 ? 'Next' : 'Complete',
                      style: const TextStyle(fontSize: 16),
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
