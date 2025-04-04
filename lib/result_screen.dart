import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autism_helper/base_screen.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> answers;
  final int studentAge;
  final String studentGender;

  const ResultScreen({super.key, required this.answers, required this.studentAge, required this.studentGender});

  Future<void> saveAnswersToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('responses').add({
        'userId': user.uid,
        'studentAge': studentAge,
        'studentGender': studentGender,
        'answers': answers,
        'timestamp': Timestamp.now(),
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    saveAnswersToFirestore();

    return BaseScreen(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Answers Submitted!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Here’s a summary of your responses:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: answers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final question = answers.keys.elementAt(index);
                  final answer = answers.values.elementAt(index);
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            answer.toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
