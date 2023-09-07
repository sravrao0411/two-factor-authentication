import 'package:auth_app/utils/routes/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';


class UserAuthentication {
  Future<UserCredential?> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (kDebugMode) {
        print('Attempting to sign in...');
      }
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('User signed in successfully.');
      }

      if (context.mounted) {
        // Notify the web app about the login attempt
        _sendLoginStatusToServer(context, 'login_attempt');

        // Navigate to the home page after successful login
        Navigator.pushNamed(context, RoutesName.home);
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FirebaseAuthException: ${e.code}');
      }
      if (e.code == 'user-not-found') {
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      }
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred: $e');
      }
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')));
    }
    return null;
  }

  void _sendLoginStatusToServer(BuildContext context, String message) {
    try {
      final channel = IOWebSocketChannel.connect('ws://your-server-domain.com:port');
      channel.sink.add(message);
      channel.sink.close();
    } catch (e) {
      if (kDebugMode) {
        print('Error sending login status to server: $e');
      }
    }
  }
}

