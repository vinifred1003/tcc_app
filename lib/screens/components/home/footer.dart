import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  void Function() selectedLoginScreen;

  void _selectLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false, 
    );
  }
  Footer({super.key, required this.selectedLoginScreen});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onPressed: () => _selectLogin(context),
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
    );
  }
}
