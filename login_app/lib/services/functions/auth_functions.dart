import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/utils/routes/route_names.dart'; // Import the http package

class UserAuthentication {
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Congrats"),
              content: Text('Welcome: ${userCredential.user!.email}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.login);
                  },
                  child: const Text("Login"),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('The account already exists for that email.')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  Future<UserCredential?> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        String userId = userCredential.user!.uid;

        try {
          // Use HTTP requests for web platforms
          await sendLoginRequest(userId);
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error during login attempt: $e')),
          );
        }

        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('No user found for that email.')),
        );
      } else if (e.code == 'wrong-password') {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('Wrong password provided for that user.')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }

    return null;
  }

  Future<void> sendLoginRequest(String userId) async {
    try {
      // ignore: unused_local_variable
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/login'), // Replace 'localhost' with your server's URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
        }),
      );
    } catch (e) {
      if (kDebugMode) {
        print("There has been an error");
      }
    }
  }
}
