import 'package:autism_helper/custom_profile_screen.dart';
import 'package:flutter/material.dart';
//import 'new_questionnaire_screen.dart'; // Import the new questionnaire screen
//import 'previous_results_screen.dart'; // Import previous results screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomProfileScreen(),
                ),
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Navigation',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose an option below',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Home Navigation
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),

            // New Questionnaire Navigation
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('New Questionnaire'),
              // onTap: () {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const NewQuestionnaireScreen(),
              //     ),
              //   );
              // },
            ),

            // Previous Results Navigation
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Previous Results'),
              // onTap: () {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const PreviousResultsScreen(),
              //     ),
              //   );
              // },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align content towards the top
          children: [
            const SizedBox(height: 50), // Adds space from the top
            SizedBox(
              width: 120, // Adjust width to make the image smaller
              height: 120, // Adjust height accordingly
              child: Image.asset('assets/images/Autism_Logo_Transparent.png'),
            ),
          ],
        ),
      ),
    );
  }
}
