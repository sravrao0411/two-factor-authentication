import 'package:flutter/material.dart';
import 'package:auth_app/utils/constants/colors.dart';
import 'package:auth_app/utils/constants/spaces.dart';
import 'package:auth_app/utils/constants/styles.dart';

class MyElevatedButtonTheme {
  ElevatedButtonThemeData theme() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: sharedPadding,
          backgroundColor: black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
}

class MyTextButtonTheme {
  TextButtonThemeData theme() => TextButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: textButtonPadding,
          textStyle: text,
          foregroundColor: black,
        ),
      );
}

class MyFloatingActionButtonTheme {
  FloatingActionButtonThemeData theme() => FloatingActionButtonThemeData(
        foregroundColor: white,
        backgroundColor: black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
       ),
      );
}
