import 'package:flutter/material.dart';

class CenterButtons extends StatelessWidget {
  final void Function() selectedHome;
  CenterButtons({super.key, required this.selectedHome});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: selectedHome,
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
