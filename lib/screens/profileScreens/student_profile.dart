import 'package:flutter/material.dart';
import '../components/global/app_drawer.dart';
import '../components/global/base_app_bar.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const BaseAppBar(screen_title: Text("Home")),
        drawer: AppDrawer(),
        body: Center(
          
        ));
  }
}
