import 'package:autism_helper/student_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:autism_helper/base_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Pushes content down a bit from the top
            const Text(
              'Welcome to the Autism Questionnaire.\n\nThis short quiz will help you better understand certain traits and behaviours typically shown in children with diagnosed Autism Spectrum Discorder (ASD).',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 140),// Pushes the button to the bottom
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentInfoScreen()),
                );
              },
              child: const Text('Start questionnaire'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Disclaimer: This questionnaire is not a diagnostic tool and should not be used as a substitute for professional medical advice.\n\nIf you believe a child is displaying traits of Autism please seek out professional help',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ),
    );
  }
}
