import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tcc_app/screens/login_screen.dart';
import 'package:tcc_app/screens/manager_signup.dart';
import 'package:tcc_app/screens/profileScreens/student_profile.dart';
import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
// import 'package:camera/camera.dart'; // Certifique-se de importar a biblioteca da câmera se ainda não o fez

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MeproviApp());
}

class MeproviApp extends StatelessWidget {
  MeproviApp({super.key});
  final ThemeData tema = ThemeData();
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MaterialApp(
      home: ManagerSignup(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.lightBlue,
          secondary: const Color.fromARGB(255, 162, 222, 250),
          inversePrimary: Colors.white,
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
