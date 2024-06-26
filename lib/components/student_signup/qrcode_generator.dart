import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import '../global/base_app_bar.dart';
import '../global/app_drawer.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_painter.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

class QRCodeGenerator extends StatefulWidget {
  final String? qrDataStudent;
  QRCodeGenerator({super.key, required this.qrDataStudent});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  late final QrImage qrImage;
  bool get _isNestedImagesSupported => true;
  String? qrData;
  late QrCode qrCode;
  late final qrImageGenerate;
  late final showQrCode;
  late String qrCodeStringData;
  @override
  void initState() {
    super.initState();
    qrData = widget.qrDataStudent; // Set your QR data
    generateQRCode();
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

  Future<void> generateQRCode() async {
    qrCode = QrCode.fromData(
      data: qrData ?? '',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    qrImageGenerate = QrImage(qrCode);
    final ByteData? byteQrImage = await qrImageGenerate.toImageAsBytes(
      decoration: const PrettyQrDecoration(),
      format: ui.ImageByteFormat.png,
      size: 400,
    );
    setState(() {
      qrCodeStringData = qrData ?? "valor padrão";
      showQrCode = PrettyQrView.data(
        data: qrCodeStringData,
        decoration: const PrettyQrDecoration(
          image: PrettyQrDecorationImage(
            image: AssetImage('images/flutter.png'),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        alignment: Alignment.center,
        child: qrImageGenerate != null
            ? Image.file(
                showQrCode,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Text('Nenhuma Imagem!'),
      ),
      // TextField(
      //   onSubmitted: (value) {
      //     setState(() {
      //       qrData = value;
      //       generateQRCode();
      //     });
      //   },
      // ),
    ) // PrettyQrView.data(data: qrData!)),
        );
  }
}
