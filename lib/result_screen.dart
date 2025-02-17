import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autism_helper/base_screen.dart'; // Import the BaseScreen file

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> answers;

  const ResultScreen({super.key, required this.answers});

  Future<void> saveAnswersToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('responses').add({
        'userId': user.uid,
        'answers': answers,
        'timestamp': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    saveAnswersToFirestore();

    return BaseScreen(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your Answers:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...answers.entries
                .map((entry) => Text("${entry.key}: ${entry.value}")),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () =>
            //       Navigator.popUntil(context, ModalRoute.withName('/')),
            //   child: const Text('Restart'),
            // ),
          ],
        ),
      ),
    );
  }
}
