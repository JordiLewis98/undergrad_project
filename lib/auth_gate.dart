import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'new_school.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> _hasSchool(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('schools')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      debugPrint('Error checking school: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // User not signed in, show sign-in screen
          return SignInScreen(
            providers: [EmailAuthProvider()],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child:
                      Image.asset('assets/images/Autism_Logo_Transparent.png'),
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

        final userId = snapshot.data!.uid;

        return FutureBuilder<bool>(
          future: _hasSchool(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred.'));
            }

            if (snapshot.data == true) {
              // User has a school, navigate to HomeScreen
              return const HomeScreen();
            } else {
              // User doesn't have a school, navigate to NewSchool
              return NewSchool(userId: userId);
            }
          },
        );
      },
    );
  }
}
