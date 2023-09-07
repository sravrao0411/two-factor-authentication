import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/utils/constants/colors.dart';
import 'package:login_app/utils/routes/all_routes.dart';
import 'package:login_app/utils/routes/route_names.dart';
import 'package:login_app/utils/themes/button_theme.dart';
import 'package:login_app/utils/themes/input_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCkW6PDgxim10TbRz7L4IFnf7AgWVLxFmY",
          projectId: "intuitive-app-3f9fb",
          messagingSenderId: "125867429985",
          appId: "1:125867429985:web:865394eb5f881cff55da20",));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intuitive App',
      theme: ThemeData(
        primaryColor: white,
        fontFamily: "Lato",
        inputDecorationTheme: MyInputTheme().theme(),
        elevatedButtonTheme: MyElevatedButtonTheme().theme(),
        floatingActionButtonTheme: MyFloatingActionButtonTheme().theme(),
        textButtonTheme: MyTextButtonTheme().theme(),
        textSelectionTheme: MyTextSelectionTheme().theme(),
      ),
      initialRoute: RoutesName.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
