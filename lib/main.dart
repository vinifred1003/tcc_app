import 'dart:ui';
import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/initial_screen.dart';
import './screens/register_screen.dart';

void main() {
  runApp(MeproviApp());
}

class MeproviApp extends StatelessWidget {
  MeproviApp({super.key});
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: RegisterScreen(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.lightBlue,
          secondary: Color.fromARGB(255, 162, 222, 250),
        ),
        textTheme: tema.textTheme.copyWith(
          titleLarge: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelLarge: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Theme.of(context).colorScheme.primary,
          titleTextStyle: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
