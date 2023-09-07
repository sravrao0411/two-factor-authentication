import 'package:auth_app/pages/home_page.dart';
import 'package:auth_app/pages/login_page.dart';
import 'package:auth_app/utils/error_handling/redirection.dart';
import 'package:flutter/material.dart';
import 'route_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => const HomePage());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const LoginPage());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorPage());
    }
  }
}
