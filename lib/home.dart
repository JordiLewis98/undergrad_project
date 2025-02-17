import 'package:autism_helper/base_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset('assets/images/Autism_Logo_Transparent.png'),
            ),
          ],
        ),
      ),
    );
  }
}
