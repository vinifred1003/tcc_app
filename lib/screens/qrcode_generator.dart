import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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
    matrix: PrettyQrMatrix.fromQrImage(this),
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
 
  void initState()  async{
    super.initState();
     qrCode = QrCode.fromData(
      data: qrData ?? '',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final qrImage = QrImage(qrCode);
    final pngQrImage = await qrImage. toImageAsBytes(size: 600, format: ImageByteFormat.png , decoration: const PrettyQrDecoration(),);
     PrettyQrView.data(  data: qrData!);
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
                      child: 
                      
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
