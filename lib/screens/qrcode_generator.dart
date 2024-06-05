import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_painter.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  late final QrImage qrImage;

  bool get _isNestedImagesSupported => true;
  String? qrData;
  ByteData? pngQrImage;
  late QrCode qrCode;
  late final qrImageGenerate;

  @override
  void initState() {
    super.initState();
    qrData = "Your QR data here"; // Set your QR data
    _generateQRCode();
  }

  Future<ui.Image> toImage({
    required final int size,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageConfiguration configuration = ImageConfiguration.empty,
  }) {
    PrettyQrDecoration safeDecoration = decoration;
    if (decoration.image != null && !_isNestedImagesSupported) {
      safeDecoration = PrettyQrDecoration(shape: decoration.shape);
    }

    final imageSize = Size.square(size.toDouble());
    final imageCompleter = Completer<ui.Image>();
    final pictureRecorder = ui.PictureRecorder();
    final imageConfiguration = configuration.copyWith(size: imageSize);

    final context = PrettyQrPaintingContext(
      Canvas(pictureRecorder),
      Offset.zero & imageSize,
      matrix: PrettyQrMatrix.fromQrImage(qrImage),
      textDirection: configuration.textDirection,
    );

    late PrettyQrPainter decorationPainter;
    try {
      decorationPainter = safeDecoration.createPainter(() {
        decorationPainter.paint(context, imageConfiguration);
        final picture = pictureRecorder.endRecording();
        imageCompleter.complete(picture.toImage(size, size));
      });
      decorationPainter.paint(context, imageConfiguration);

      final decorationImageStream = safeDecoration.image?.image.resolve(
        configuration,
      );

      if (decorationImageStream == null) {
        final picture = pictureRecorder.endRecording();
        imageCompleter.complete(picture.toImage(size, size));
      } else {
        late ImageStreamListener imageStreamListener;
        imageStreamListener = ImageStreamListener(
          (imageInfo, synchronous) {
            decorationImageStream.removeListener(imageStreamListener);
            imageInfo.dispose();
            if (synchronous) {
              final picture = pictureRecorder.endRecording();
              imageCompleter.complete(picture.toImage(size, size));
            }
          },
          onError: (error, stackTrace) {
            decorationImageStream.removeListener(imageStreamListener);
            imageCompleter.completeError(error, stackTrace);
          },
        );
        decorationImageStream.addListener(imageStreamListener);
      }
    } catch (error, stackTrace) {
      imageCompleter.completeError(error, stackTrace);
    }

    return imageCompleter.future.whenComplete(() {
      decorationPainter.dispose();
    });
  }

  Future<ByteData?> toImageAsBytes({
    required final int size,
    final ui.ImageByteFormat format = ui.ImageByteFormat.png,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageConfiguration configuration = ImageConfiguration.empty,
  }) async {
    final image = await toImage(
      size: size,
      decoration: decoration,
      configuration: configuration,
    );
    return image.toByteData(format: format);
  }

  Future<void> _generateQRCode() async {
    qrCode = QrCode.fromData(
      data: qrData ?? '',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    qrImageGenerate = QrImage(qrCode);
    final ByteData? generatedPngQrImage = await toImageAsBytes(
      decoration: const PrettyQrDecoration(),
      format: ui.ImageByteFormat.png,
      size: 600,
    );
    setState(() {
      pngQrImage = generatedPngQrImage;
    });
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
                  _generateQRCode();
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
