import 'package:auth_app/services/functions/auth_functions.dart';
import 'package:auth_app/utils/constants/spaces.dart';
import 'package:auth_app/utils/constants/styles.dart';
import 'package:auth_app/utils/routes/route_names.dart';
import 'package:auth_app/utils/validation/string_extensions.dart';
import 'package:auth_app/widgets/inputs/email_input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final emailFocus = FocusNode();

  final UserAuthentication userAuth = UserAuthentication();

  bool isLoading = false;

  void signInUser() async {
    try {
      setState(() {
        isLoading = true; // Show the loading indicator while signing in
      });

      UserCredential? userCredential = await userAuth.signInUser(
        context: context,
        email: _emailController.text.trim(),
        password: "password",
      );

      setState(() {
        isLoading = false; // Hide the loading indicator after signing in
      });

      if (userCredential != null) {
        // User successfully logged in, do something (e.g., navigate to home page)
        // ignore: use_build_context_synchronously
        _sendLoginStatusToServer(userCredential.user?.uid);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, RoutesName.home);
      } else {
        // Handle unsuccessful login
        // For example, show an error message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to log in')),
        );
      }
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

  void _sendLoginStatusToServer(String? userId) {
    if (userId != null && userId.isNotEmpty) {
      final channel =
          IOWebSocketChannel.connect('ws://10.0.2.2:3000/login?userId=$userId');
      channel.sink.add('login_attempt?userId=$userId');
      channel.stream.listen((message) {
        if (message == 'logged_in') {
          // Handle login success, for example, navigate to home page
          Navigator.pushNamed(context, RoutesName.home);
        } else if (message == 'logged_out') {
          // Handle login denied, for example, show a dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Denied'),
                content: const Text('Your login attempt has been denied.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        // You can handle any other messages or errors received from the server here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 325,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Login Page", style: display)),
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
                      if (EmailValidator.validate(_emailController.text) ==
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
            ],
          ),
        ),
      ),
    );
  }
}
