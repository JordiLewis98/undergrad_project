import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

/// Widget for adding a new school and linking it to a user.
class NewSchool extends StatefulWidget {
  final String userId;

  /// Constructor requires a [userId] to associate the school with a user.
  const NewSchool({required this.userId, super.key});

  @override
  State<NewSchool> createState() {
    return _NewSchoolState();
  }
}

class _NewSchoolState extends State<NewSchool> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _schoolNameController =
      TextEditingController(); // Controller for input field
  String? _selectedSchoolId; // Stores the selected school ID
  Timer? _debounce; // Timer for debouncing search queries

  @override
  void dispose() {
    _schoolNameController.dispose();
    _debounce?.cancel(); // Cancel any ongoing debounce timer
    super.dispose();
  }

  /// Saves the selected school to Firestore.
  Future<void> _saveSchool() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSchoolId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a school')),
        );
        return;
      }
      try {
        // Save school data in Firestore
        await FirebaseFirestore.instance.collection('schools').add({
          'userId': widget.userId, // Link the school to the user
          'schoolId': _selectedSchoolId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School saved successfully!')),
        );

        // Navigate to authentication screen and remove all previous routes
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth', (route) => false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save school: $error')),
        );
      }
    }
  }

  /// Fetches schools from Firestore that match the search query.
  Future<List<Map<String, dynamic>>> _getSchools(String query) async {
    if (query.isEmpty) {
      return []; // No results if the query is empty
    }

    // Query Firestore for schools whose names start with the query text
    final snapshot = await FirebaseFirestore.instance
        .collection('uk_schools')
        .where('EstablishmentName', isGreaterThanOrEqualTo: query)
        .where('EstablishmentName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    // Convert query results into a list of maps
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'EstablishmentName': doc['EstablishmentName'],
      };
    }).toList();
  }

  /// Handles search input changes with a debounce mechanism.
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Only update results when the user stops typing
      if (query.isNotEmpty) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New School')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _schoolNameController,
                onChanged: _onSearchChanged, // Listen for text change
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'School Name',
                ),
              ),
              const SizedBox(height: 8),

              /// Displays search results after the user stops typing.
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _getSchools(_schoolNameController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator(
                      color: Colors.orange,
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No schools found');
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final school = snapshot.data![index];
                        return ListTile(
                          title: Text(school['EstablishmentName']),
                          onTap: () {
                            setState(() {
                              _selectedSchoolId = school['id'];
                              _schoolNameController.text =
                                  school['EstablishmentName'];
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// Button to save the selected school.
              ElevatedButton(
                onPressed: _saveSchool,
                child: const Text('Save School'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
