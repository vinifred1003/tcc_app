import 'package:flutter/material.dart';

class FooterButtons extends StatelessWidget {
  const FooterButtons({super.key});

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
            onPressed: () {},
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
