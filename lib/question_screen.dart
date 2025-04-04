import 'package:autism_helper/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autism_helper/base_screen.dart';

class QuestionScreen extends StatefulWidget {
  final int studentAge;
  final String studentGender;

  const QuestionScreen({
    super.key,
    required this.studentAge,
    required this.studentGender,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
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

    // Filter and sort questions based on gender
    final allQuestions = snapshot.docs.map((doc) => doc.data()).toList();

    final gender = widget.studentGender.toLowerCase();

    // Gender-specific first
    final genderSpecific = allQuestions.where((q) =>
        q['targetGender'] != null &&
        q['targetGender'].toString().toLowerCase() == gender);

    // Then gender-neutral
    final general = allQuestions.where((q) =>
        q['targetGender'] == null ||
        q['targetGender'].toString().toLowerCase() == 'all');

    setState(() {
      questions = [...genderSpecific, ...general];
    });
  }

  void nextQuestion(String selectedOption) {
    final currentQuestion = questions[currentIndex];
    selectedAnswers[currentQuestion['question']] = selectedOption;

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(answers: selectedAnswers, studentAge: widget.studentAge, studentGender: widget.studentGender,),
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

    final current = questions[currentIndex];
    final questionText = current['question'] ?? 'No question';
    final answers = current['answers'] as List<dynamic>;
    final extraInfo = current['extraInfo'];

    return BaseScreen(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${currentIndex + 1} of ${questions.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (extraInfo != null && extraInfo.toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ExpansionTile(
                  title: const Text(
                    'More info',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        extraInfo,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            ...answers.map<Widget>((option) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => nextQuestion(option),
                  child: Text(option),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
