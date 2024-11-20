import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';

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
      appBar: BaseAppBar(screen_title: Text("Ocorrências")),
        body: Form(child: Column(
          
        )),
    );
  }
}