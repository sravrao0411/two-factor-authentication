import 'package:flutter/material.dart';
import 'package:auth_app/utils/constants/colors.dart';
import 'package:auth_app/utils/constants/styles.dart';

class MyInputTheme {
  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular((5))),
      borderSide: BorderSide(color: color, width: 0.5),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
        //Padding
        contentPadding: const EdgeInsets.all(16),

        //Label
        floatingLabelBehavior: FloatingLabelBehavior.always,

        //Borders
        enabledBorder: buildBorder(extraLightGrey),
        errorBorder: buildBorder(red),
        focusedErrorBorder: buildBorder(red),
        border: buildBorder(black),
        focusedBorder: buildBorder(darkGrey),
        disabledBorder: buildBorder(lightGrey),
        
        //Text
        counterStyle: counter,
        floatingLabelStyle: floatingLabel,
        errorStyle: error,
        helperStyle: helper,
        hintStyle: hint,
      );
}

class MyTextSelectionTheme {
  TextSelectionThemeData theme() => const TextSelectionThemeData(
        cursorColor: blue,
        selectionColor: blue,
        selectionHandleColor: blue,
      );
}
