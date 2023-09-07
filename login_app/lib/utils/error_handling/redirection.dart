import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_app/utils/constants/styles.dart';
import 'package:login_app/utils/routes/route_names.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),
        () => Navigator.pushNamed(context, RoutesName.login));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Oops, there has been an error", style: headline1))
    );
  }
}
