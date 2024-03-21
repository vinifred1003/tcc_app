import 'package:flutter/material.dart';
import '../components/global/app_drawer.dart';
import '../components/global/base_app_bar.dart';
// import 'package:camera/camera.dart';
// import './camera_screen.dart';
import '../components/initial/center_buttons.dart';
import '../components/initial/profile_display.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  // CameraDescription? firstCamera;

  // void _InitCamera(BuildContext context) {
  //   if (firstCamera != null) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (_) {
  //         return CameraScreen(camera: firstCamera!);
  //       }),
  //     );
  //   } else {
  //     // Tratar o caso em que firstCamera é null
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("sddsaa")),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          children: [
            ProfileDisplay(),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 55),
              child: Column(
                children: [
                  CenterButtons(),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, right: 40),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Logar em outra conta",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
