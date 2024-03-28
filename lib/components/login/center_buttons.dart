import 'package:flutter/material.dart';
import 'package:tcc_app/screens/initial_screen.dart';

class CenterButtons extends StatelessWidget {
  const CenterButtons({super.key});
  void _selectInitial(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return InitialScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _selectInitial(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).textTheme.labelLarge?.color,
              foregroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: Size(200, 70),
            ),
            child: const Text(
              "Entrar",
              style: TextStyle(fontSize: 25),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Esqueci minha senha",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                decorationThickness: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
