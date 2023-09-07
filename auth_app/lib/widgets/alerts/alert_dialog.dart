import 'package:auth_app/utils/constants/styles.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onDeny;
  final VoidCallback onApprove;

  const MyAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onDeny,
    required this.onApprove,
  }) : super(key: key);

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
      actions: [
        TextButton(
          onPressed: onDeny,
          child: const Text('Deny'),
        ),
        TextButton(
          onPressed: onApprove,
          child: const Text('Approve'),
        ),
      ],
    );
  }
}

