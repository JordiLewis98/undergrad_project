import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'new_school.dart';

/// A widget that manages authentication and navigates users accordingly.
///
/// If the user is not signed in, it shows a sign-in screen. If signed in, it
/// checks if they have an associated school and directs them to either the
/// `HomeScreen` or `NewSchool` screen.
class AuthGate extends StatelessWidget {
  /// Constructs an `AuthGate` widget.
  const AuthGate({super.key});

  /// Checks if the authenticated user has an associated school in Firestore.
  ///
  /// Returns `true` if the user has a school, otherwise `false`.
  Future<bool> _hasSchool(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('schools')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty; // Returns true if a school exists
    } catch (error) {
      debugPrint('Error checking school: $error');
      return false; // Return false in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      /// Listens to authentication state changes and updates the UI accordingly.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // If no user is signed in, show the sign-in screen
          return SignInScreen(
            providers: [EmailAuthProvider()], // Email authentication provider
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                      'assets/images/Autism_Logo_Transparent.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                      ? const Text('Welcome, please sign in!')
                      : const Text('Welcome, please sign up!'));
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        }

        final userId =
            snapshot.data!.uid; // Retrieve the authenticated user's ID

        return FutureBuilder<bool>(
          /// Checks if the user has an associated school in Firestore.
          future: _hasSchool(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while fetching data
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              // Display an error message if something goes wrong
              return const Center(child: Text('An error occurred.'));
            }

            if (snapshot.data == true) {
              // If the user has a school, navigate to the HomeScreen
              return const HomeScreen();
            } else {
              // If no school is found, navigate to NewSchool screen for setup
              return NewSchool(userId: userId);
            }
          },
        );
      },
    );
  }
}
