import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:login_app/services/functions/auth_functions.dart';
import 'package:login_app/utils/constants/colors.dart';
import 'package:login_app/utils/constants/spaces.dart';
import 'package:login_app/utils/constants/styles.dart';
import 'package:login_app/utils/routes/route_names.dart';
import 'package:login_app/utils/validation/string_extensions.dart';
import 'package:login_app/widgets/inputs/email_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  final UserAuthentication userAuth = UserAuthentication();

  void signUpUser() {
    userAuth.signUpUser(
        context: context,
        email: _emailController.text.trim(),
        password: "password");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          largeVertical,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                child: Text("Sign Up below or", style: headline3),
              ),
              smallHorizontal,
              Flexible(
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize:
                          20.0, // Change the font size as per your requirement
                      fontWeight: FontWeight.w900, // Make the text bold
                    ),
                  ),
                  onPressed: () async {
                      Navigator.pushNamed(context, RoutesName.login);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: black)),
                    ),
                    child: const Text("Login Here"),
                  ),
                ),
              ),
            ],
          ),
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
                  if (EmailValidator.validate(_emailController.text) == false) {
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
          mediumVertical,
          SizedBox(
            width: 200,
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final isValid = formKey.currentState!.validate();
                if (isValid) {
                  signUpUser();
                }
              },
              label: const Text("Sign Up"),
            ),
          ),
          mediumVertical,
        ],
      ),
    );
  }
}
