import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
         title: const Text("Advertência"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
        body: Form(child: Column()),
    );
  }
}