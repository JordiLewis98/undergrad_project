import 'package:autism_helper/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:autism_helper/base_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuestionScreen()),
            );
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
