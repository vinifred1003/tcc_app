import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  void Function() selectedLoginScreen;
  Footer({super.key, required this.selectedLoginScreen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, right: 40),
      child: Column(
        children: [
          TextButton(
            onPressed: selectedLoginScreen,
            child: const Text(
              "Logar em outra conta",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Sair",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
