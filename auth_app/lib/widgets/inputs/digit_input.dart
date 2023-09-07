import 'package:flutter/material.dart';

class DigitInput extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final FocusNode? nextFocusNode;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const DigitInput({
    Key? key,
    required this.validator,
    required this.nextFocusNode,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (_) => nextFocusNode?.requestFocus(),
        keyboardType: TextInputType.number,
        obscureText: true,
        decoration: const InputDecoration(
          helperText: "",
        ),
        validator: validator,
      ),
    );
  }
}
