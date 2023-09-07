import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final FocusNode? nextFocusNode;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const EmailInput({
    Key? key,
    required this.validator,
    required this.nextFocusNode,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: (_) => nextFocusNode?.requestFocus(),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        helperText: "",
        hintText: "Email",
        filled: true,
      ),
      validator: validator,
    );
  }
}
