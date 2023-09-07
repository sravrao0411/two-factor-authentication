import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/utils/constants/spaces.dart';
import 'package:login_app/utils/constants/styles.dart';
import 'package:login_app/utils/routes/route_names.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  void logoutUser() async {
    try {
      // Update the 'loginStatus' field in Firestore to 'logged out'
      updateLoginStatus('logged out');

      // Sign out the user from Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Navigate to the login page
      // ignore: use_build_context_synchronously
       Navigator.pushReplacementNamed(context, RoutesName.login);
    } catch (e) {
      // Handle the error here, such as displaying an error message
      // or logging the error for debugging purposes
      if (kDebugMode) {
        print("Error updating login status: $e");
      }
      // Optionally, show a snackbar or dialog to inform the user about the error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while logging out.'),
        ),
      );
    }
  }

  void updateLoginStatus(String newStatus) async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the 'loginStatus' field in Firestore to the newStatus
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use the user's UID as the document ID
            .update({'loginStatus': "logged out"});

        if (kDebugMode) {
          print('Login status updated successfully to $newStatus.');
        }
      } else {
        if (kDebugMode) {
          print('User is not logged in.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating login status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Home", style: display),
            largeVertical,
            const Text("Welcome"),
            Text(user.email!),
            extraLargeVertical,
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: logoutUser,
                child: const Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
