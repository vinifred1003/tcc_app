import 'dart:ffi';

import 'package:flutter/material.dart';

class Inputs extends StatelessWidget {
  final bool isChecked;
  final void Function(bool?) checkboxFunction;

  Inputs({super.key, required this.checkboxFunction, required this.isChecked});
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(
            height: 90,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '',
                labelText: 'E-mail',
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Theme.of(context).colorScheme.inversePrimary,
                      value: isChecked,
                        onChanged: checkboxFunction
                    ),
                    Text(
                      'Lembrar-se de mim',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
