import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_app/services/functions/auth_functions.dart';
import 'package:login_app/utils/constants/colors.dart';
import 'package:login_app/utils/constants/spaces.dart';
import 'package:login_app/utils/constants/styles.dart';
import 'package:login_app/utils/routes/route_names.dart';
import 'package:login_app/utils/validation/string_extensions.dart';
import 'package:login_app/widgets/inputs/email_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final emailFocus = FocusNode();

  Stream<DocumentSnapshot>? userStream;

  final UserAuthentication userAuth = UserAuthentication();

  UserCredential? userCredential;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the authentication state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // If the user is signed in, update the userStream with the Firestore stream
        userStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots();
      } else {
        // If the user is signed out, set the userStream to null
        userStream = null;
      }
    });
  }

  void signInUser() async {
    try {
      setState(() {
        isLoading = true; // Show the loading indicator while signing in
      });
      // ignore: unused_local_variable
      UserCredential? userCredential = await userAuth.signInUser(
        context: context,
        email: _emailController.text.trim(),
        password: "password",
      );

      setState(() {
        isLoading = false; // Hide the loading indicator after signing in
      });
    } catch (e) {
      // Handle any exceptions that might occur during the login process
      setState(() {
        isLoading = false; // Hide the loading indicator if an error occurs
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $e')),
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
            .update({'loginStatus': newStatus});

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // Check for errors in the stream
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // Check if the stream has data and the loginStatus field exists
        if (snapshot.hasData && snapshot.data!.exists) {
          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('loginStatus')) {
            String loginStatus = data['loginStatus'];
            if (loginStatus == 'approve') {
              // Show a message indicating approval
              Navigator.pushReplacementNamed(context, RoutesName.home);
            } else if (loginStatus == 'deny') {
              // Show a message indicating denial
              if (kDebugMode) {
                print("denied");
              }
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Login Denied'),
                    content: const Text('Your login attempt has been denied.'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          updateLoginStatus('logged out');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }

        // If no data or loginStatus not found, show the regular login UI
        return Stack(
          children: [
            // Your current Scaffold
            Scaffold(
              body: Center(
                child: SizedBox(
                  width: 325,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(alignment: Alignment.centerLeft, child: Text("Login Page", style: display)),
                      extraLargeVertical,
                      Form(
                        key: formKey,
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: EmailInput(
                            validator: (input) {
                              if (_emailController.text.isWhitespace()) {
                                return "Email is required";
                              }
                              if (EmailValidator.validate(
                                      _emailController.text) ==
                                  false) {
                                return "Invalid email address";
                              }
                              return null;
                            },
                            nextFocusNode: null,
                            focusNode: emailFocus,
                            controller: _emailController,
                          ),
                        ),
                      ),
                      smallVertical,
                      SizedBox(
                        width: 325,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            final isValid = formKey.currentState!.validate();
                            if (isValid == true) {
                              signInUser();
                            }
                          },
                          label: const Text("Log In"),
                        ),
                      ),
                      largeVertical,
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.signup);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: black)),
                          ),
                          child: const Text("Create an Account"),
                        ),
                      ),
                      smallVertical
                    ],
                  ),
                ),
              ),
            ),

            // Loading indicator
            isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
