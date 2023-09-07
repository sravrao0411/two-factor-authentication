import 'package:auth_app/utils/constants/colors.dart';
import 'package:auth_app/utils/routes/all_routes.dart';
import 'package:auth_app/utils/routes/route_names.dart';
import 'package:auth_app/utils/themes/button_theme.dart';
import 'package:auth_app/utils/themes/input_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
