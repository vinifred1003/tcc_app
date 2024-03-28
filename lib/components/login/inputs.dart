import 'package:flutter/material.dart';

class Inputs extends StatefulWidget {
  Inputs({super.key});

  @override
  State<Inputs> createState() => _InputsState();
}

class _InputsState extends State<Inputs> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
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
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
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
