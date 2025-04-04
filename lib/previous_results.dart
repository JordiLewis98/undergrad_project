import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autism_helper/base_screen.dart'; 
import 'package:intl/intl.dart';


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
      return [];
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('responses')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      // Map over the documents and retrieve the answers field
      final responses = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'timestamp': data['timestamp'],
          'studentAge': data['studentAge'],
          'studentGender': data['studentGender']
        };
      }).toList();

      return responses;
    } catch (e) {
      return [];
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
            final date = response['timestamp'];
            final studentAge = response['studentAge'];
            final studentGender = response['studentGender'];

            return Card(
              child: ListTile(
                title: Text('Response #${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${DateFormat.yMMMMd().add_jm().format(date.toDate().toLocal())}'),
                    Text('Age: $studentAge'),
                    Text('Gender: ${studentGender.toString()}'),
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
