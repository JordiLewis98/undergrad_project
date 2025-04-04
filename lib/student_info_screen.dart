import 'package:flutter/material.dart';
import 'package:autism_helper/question_screen.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  String? _selectedGender;

  void _startQuestionnaire() {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      int age = int.parse(_ageController.text.trim());
      String gender = _selectedGender!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionScreen(
            studentAge: age,
            studentGender: gender,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Information')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please enter the age and gender of the student:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Age is required';
                  }
                  final age = int.tryParse(value.trim());
                  if (age == null || age <= 0) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _startQuestionnaire,
                child: const Text('Continue to questionnaire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
