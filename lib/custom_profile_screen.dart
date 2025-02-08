import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomProfileScreen extends StatefulWidget {
  const CustomProfileScreen({super.key});

  @override
  State<CustomProfileScreen> createState() {
    return _CustomProfileScreenState();
  }
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  String? userEmail;
  String? schoolName; // The actual school name from 'uk_schools'

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });

      try {
        // Step 1: Get the schoolId where userId == current user's ID
        QuerySnapshot schoolQuery = await FirebaseFirestore.instance
            .collection('schools')
            .where('userId', isEqualTo: user.uid)
            .limit(1) // We only need one match
            .get();

        if (schoolQuery.docs.isNotEmpty) {
          String schoolId = schoolQuery.docs.first['schoolId'];

          // Step 2: Fetch the school name from 'uk_schools' using schoolId
          DocumentSnapshot schoolDoc = await FirebaseFirestore.instance
              .collection('uk_schools')
              .doc(schoolId)
              .get();

          setState(() {
            schoolName = schoolDoc.exists
                ? schoolDoc['EstablishmentName']
                : 'School not found';
          });
        } else {
          setState(() {
            schoolName = 'No school linked';
          });
        }
      } catch (e) {
        setState(() {
          schoolName = 'Error fetching school';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text("Email"),
                      subtitle: Text(userEmail ?? "Loading..."),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.school, color: Colors.green),
                      title: const Text("Linked School"),
                      subtitle: Text(schoolName ?? "Loading..."),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Sign Out Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Sign Out"),
                    ),

                    // Delete Account Button
                    ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        await FirebaseAuth.instance.currentUser?.delete();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text("Delete Account",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
