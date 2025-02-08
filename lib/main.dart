import 'package:autism_helper/auth_gate.dart';
import 'package:autism_helper/firebase_options.dart';
import 'package:autism_helper/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/auth', // Set the initial route
      routes: {
        '/auth': (context) => const AuthGate(), // Authentication screen
        '/home': (context) => HomeScreen(), // Home screen route
      },
    );
  }
}
