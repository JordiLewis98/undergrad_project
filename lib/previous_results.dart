import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autism_helper/base_screen.dart'; // Import the BaseScreen file

class PreviousResults extends StatefulWidget {
  const PreviousResults({super.key});

  @override
  State<PreviousResults> createState() {
    return _PreviousResults();
  }
}

class _PreviousResults extends State<PreviousResults> {
  // Function to retrieve answers from Firestore
  Future<List<Map<String, dynamic>>> retrieveAnswers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return []; // Return an empty list if user is not authenticated
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('responses')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true) // You need the index for this
          .get();

      // Map over the documents and retrieve the answers field
      final responses = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'timestamp': data['timestamp'],
          'answers': data['answers'], // Here we retrieve the answers field
        };
      }).toList();

      return responses;
    } catch (e) {
      print('Error retrieving answers: $e');
      return []; // Return empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        body: FutureBuilder<List<Map<String, dynamic>>>(
      future: retrieveAnswers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No responses found.'));
        }

        final responses = snapshot.data!;

        return ListView.builder(
          itemCount: responses.length,
          itemBuilder: (context, index) {
            final response = responses[index];
            final answers =
                response['answers']; // This will be your answers map

            return Card(
              child: ListTile(
                title: Text('Response #${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // If answers is a Map, display each key-value pair
                    if (answers is Map) ...[
                      ...answers.entries.map<Widget>((entry) {
                        return Text('${entry.key}: ${entry.value}');
                      }).toList(),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
