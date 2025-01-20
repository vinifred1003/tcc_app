import 'package:flutter/material.dart';

class FooterButtons extends StatelessWidget {
  final void Function() selectedRegister;
  FooterButtons({super.key, required this.selectedRegister});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Não tem cadastro?',
            style: TextStyle(fontSize: 16),
          ),
          TextButton(
            onPressed: selectedRegister,
            child: const Text(
              "Cadastrar",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue, // Set the color you want
                decorationThickness: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
