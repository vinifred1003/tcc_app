import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:tcc_app/screens/login_screen.dart';
import '../components/global/app_drawer.dart';
import '../components/global/base_app_bar.dart';
import '../models/user.dart';
import '../data/dummy_data.dart';

// import 'package:camera/camera.dart';
// import './camera_screen.dart';
import '../components/home/center_buttons.dart';
import '../components/home/profile_display.dart';
import '../components/home/footer.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  
  HomeScreen({super.key , required this.userId});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final Object u;
  String scanResult = "";
  
 void findUser(){
  User? foundUser = dummyUser.firstWhere(
  (user) => user.id == this.userId,
  orElse: () => null, // Handle case if not found
);

if (foundUser != null) {
   u = foundUser;
} else {
  print('No user found with ID $yourId');
}
 }
  
  Future<void> scanCode() async {
    String barcodeScanRes;
    try {
      // Explicitly cast the stream to Stream<String>
      Stream<String>? barcodeStream =
          await FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", true, ScanMode.QR) as Stream<String>?;
      if (barcodeStream != null) {
        barcodeStream.listen((barcode) {
          setState(() {
            scanResult = barcode;
          });
        });
      }
    } on PlatformException {
      barcodeScanRes = "Failed to scan: $e";
    }
  }

  void _selectLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return LoginScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Home")),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          children: [  
            ProfileDisplay(name:u0.username, classOrInstitution:u0.jobPosition),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 55),
              child: Column(
                children: [
                  CenterButtons(
                    selectedScanQRCode: () => scanCode(),
                  ),
                  Footer(
                    selectedLoginScreen: () => _selectLoginScreen(context),
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
