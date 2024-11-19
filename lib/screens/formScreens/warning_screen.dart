import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text("Advertência"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
        body: Form(child: Column(
          
        )),
    );
  }
}