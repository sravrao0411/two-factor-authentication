import 'dart:async';
import 'package:auth_app/utils/constants/styles.dart';
import 'package:auth_app/utils/routes/route_names.dart';
import 'package:flutter/material.dart';

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
        () => Navigator.pushNamed(context, RoutesName.home));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Oops, there has been an error", style: headline1))
    );
  }
}
