import 'package:auth_app/utils/constants/styles.dart';
import 'package:flutter/material.dart';

class DigitDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onPressed;
  final String actionText;

  const DigitDialog(
      {super.key, required this.title, required this.content, required this.onPressed, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // change the dialog box shape
      ),
      title: Text(
        title,
        style: headline1
      ),
      content: Text(
        content,
        style: bodyText1
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            actionText,
            style: headline2
          ),
        ),
      ],
    );
  }
}
