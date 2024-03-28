import 'dart:ui';
import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/entry_record.dart';
import 'package:flutter/material.dart';
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
      home: LoginScreen(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.lightBlue,
          secondary: Color.fromARGB(255, 162, 222, 250),
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
