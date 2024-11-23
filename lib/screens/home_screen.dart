import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tcc_app/models/attendance.dart';
import 'package:tcc_app/screens/login_screen.dart';

import '../models/user.dart';
import 'components/global/app_drawer.dart';
import 'components/global/base_app_bar.dart';
// import 'package:camera/camera.dart';
// import './camera_screen.dart';
import 'components/home/center_buttons.dart';
import 'components/home/footer.dart';
import 'components/home/profile_display.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User u;

  String scanResult = "";

  @override
  void initState() {
    super.initState();
    u = widget.user;
  }

  Future<void> scanCode() async {
    String? barcodeScanRes;
    try {
      // Explicitly cast the stream to Stream<String>
      Stream<String>? barcodeStream =
          await FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", true, ScanMode.QR) as Stream<String>?;

      if (barcodeStream != null) {
        final newEntry = Attendance(
          name: barcodeScanRes ?? "nenhum", // Nome vindo do QR Code
          type: "Entrada", // Ajuste conforme necessário (Entrada/Saída)
          date: DateTime.now(),
        );
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
            ProfileDisplay(
                name: u.name,
                classOrInstitution:
                    u.employee?.occupation?.name ?? 'Não informado'),
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
