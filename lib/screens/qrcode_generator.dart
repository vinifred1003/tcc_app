import 'package:flutter/material.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String? qrData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(screen_title: Text("Gerador de QRCode")),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onSubmitted: (value) {
                setState(() {
                  qrData = value;
                });
              },
            ),
            if (qrData != null) PrettyQrView.data(data: qrData!),
          ],
        ),
      ),
    );
  }
}
