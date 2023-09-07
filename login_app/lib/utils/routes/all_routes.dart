import 'package:flutter/material.dart';
import 'package:login_app/pages/home_page.dart';
import 'package:login_app/pages/login_page.dart';
import 'package:login_app/pages/signup_page.dart';
import 'package:login_app/utils/error_handling/redirection.dart';
import 'route_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpPage());
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => const HomePage());

      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorPage());
    }
  }
}
