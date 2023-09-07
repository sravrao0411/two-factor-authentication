import 'package:auth_app/utils/constants/spaces.dart';
import 'package:auth_app/utils/constants/styles.dart';
import 'package:auth_app/utils/routes/route_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final emailFocus = FocusNode();

  late IOWebSocketChannel channel;

  bool isLoading = false;

  void onApprove() async {
    try {
      // Your existing code for approving the login attempt

      // Save the approval status in Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update({"loginStatus": "approve"});

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your login attempt has been approved.'),
        ),
      );
      // Approval status successfully updated in Firestore
    } catch (e) {
      // Handle failure to update approval status in Firestore
    }
  }

  void onDeny() async {
    try {
      // Your existing code for denying the login attempt

      // Save the denial status in Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update({"loginStatus": "deny"});
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your login attempt has been denied.'),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Login denied");
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    emailFocus.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize the WebSocket channel and connect to the server

    String userId = FirebaseAuth.instance.currentUser!.uid;
    channel =
        IOWebSocketChannel.connect('ws://10.0.2.2:3000/login?userId=$userId');

    // Listen to incoming messages from the WebSocket channel
    channel.stream.listen((message) {
      if (message == 'Login attempt') {
        // Show the alert dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Attempt'),
              content: const Text('Do you want to approve the login attempt?'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Send the 'deny' message to the server
                    channel.sink.add('deny');
                    onDeny();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Deny'),
                ),
                TextButton(
                  onPressed: () {
                    // Send the 'approve' message to the server
                    channel.sink.add('approve');
                    onApprove();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Approve'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void logoutUser() async {
    try {
      // Sign out the user from Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Navigate to the login page
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RoutesName.login);
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Home", style: display),
              extraLargeVertical,
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: logoutUser,
                  child: const Text("Log Out"),
                ),
              ),
              mediumVertical,
            ],
          ),
        ),
      ),
      if (isLoading)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ]);
  }
}
