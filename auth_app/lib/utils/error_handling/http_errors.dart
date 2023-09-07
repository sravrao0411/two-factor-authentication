import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('The entered code was incorrect.')));
      break;
    case 404:
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('User not found.')));
      break;
    case 500:
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('Error verifying code.')));
      break;
    default:
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('An unexpected error occurred.')));
  }
}
