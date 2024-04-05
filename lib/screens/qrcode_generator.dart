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
  late QrCode qrCode;
  void initState() {
    super.initState();
    final qrCode = QrCode.fromData(
      data: qrData ?? '',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
  }

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
            Container(
              height: 400,
              width: 600,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: qrData != null
                  ? FittedBox(
                      child: PrettyQrView.data(
                        data: qrData!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : const Text("Digite o nome referenciado no QRCode"),
            ),
          ],
        ),
      ),
    );
  }
}
