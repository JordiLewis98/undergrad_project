import 'package:autism_helper/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autism_helper/base_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  Map<String, dynamic> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      questions = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void nextQuestion(String selectedOption) {
    selectedAnswers[questions[currentIndex]['text']] = selectedOption;
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(answers: selectedAnswers),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return BaseScreen(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BaseScreen(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              questions[currentIndex]['text'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ...questions[currentIndex]['options'].map<Widget>((option) {
              return ElevatedButton(
                onPressed: () => nextQuestion(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
