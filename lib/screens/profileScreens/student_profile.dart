import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student.dart';

import 'package:tcc_app/screens/components/home/profile_display.dart';
import 'package:tcc_app/screens/components/student_profile/profile_display.dart';
import '../components/global/app_drawer.dart';
import '../components/global/base_app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class StudentProfile extends StatelessWidget {
  final Student student;
  final Response studentPhoto;
  late QrImage qrCode;

  StudentProfile(this.student, this.studentPhoto, {super.key});

  Future<void> exportQrCodeAsPng() async {
    final qrImageBytes = await qrCode.toImageAsBytes(
        size: 512,
        format: ui.ImageByteFormat.png,
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.lightBlue),
          image: PrettyQrDecorationImage(
            image: AssetImage('assets/images/MeproviLogoWithoutBg.png'),
          ),
          background: Colors.white,
        ));

    final bytes = qrImageBytes!.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final imagePath =
        '${directory.path}/qr_code_${student.registrationNumber}.png';

    final file = File(imagePath);
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(imagePath)],
      text: 'QR Code ${student.name}',
    );
  }

  Widget buildQrCodeWidget() {
    return PrettyQrView(
        qrImage: qrCode,
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(color: Colors.lightBlue),
          image: PrettyQrDecorationImage(
            image: AssetImage('assets/images/MeproviLogoWithoutBg.png'),
          ),
        ));
  }

  generateQrCode() {
    final qrCode = QrCode.fromData(
      data: student.registrationNumber,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    this.qrCode = QrImage(qrCode);
  }

  List<Widget> buildGuardianList(
      BuildContext context, List<Guardian> guardians) {
    final double horizontalPaddingText =
        MediaQuery.of(context).size.width * 0.1;
    final double verticalPaddingText =
        MediaQuery.of(context).size.height * 0.02;

    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPaddingText),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPaddingText),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.lightBlue, // Cor da borda
                width: 3, // Largura da borda
              ),
            ),
            height: 200,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: guardians.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        guardians[index].name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    generateQrCode();

    final String formattedBirthDate =
        DateFormat('dd/MM/yyyy').format(student.birthDate);

    final double verticalPadding = MediaQuery.of(context).size.height * 0.05;
    bool entryIsEmpty = student.entries!.isEmpty;
    bool exitIsEmpty = student.exits!.isEmpty;
    bool warningIsEmpty = student.warnings!.isEmpty;
    bool guardiansIsEmpty = student.guardians.isEmpty;

    final double horizontalPaddingText =
        MediaQuery.of(context).size.width * 0.1;
    final double verticalPaddingText =
        MediaQuery.of(context).size.height * 0.02;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Estudante")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 20.0), // Adicione um padding inferior
          child: Column(
            children: [
              SizedBox(
                width: 500,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: StudentProfileDisplay(
                    name: student.name,
                    classOrInstitution: student.studentClass!.name,
                    photoResponse: studentPhoto,
                  ),
                ),
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(15), // Bordas arredondadas
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Cor da sombra
                      spreadRadius: 2, // Distância de expansão da sombra
                      blurRadius: 8, // Nível de desfoque
                      offset: const Offset(
                          4, 6), // Deslocamento horizontal e vertical
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: verticalPaddingText),
                      child: SizedBox(
                        width: 500,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingText),
                          child: Text(
                            'Matrícula: ${student.registrationNumber}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: verticalPaddingText),
                      child: SizedBox(
                        width: 500,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPaddingText),
                          child: Text(
                            'Data de Nascimento: $formattedBirthDate',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPaddingText),
                        child: Text(
                          "Responsáveis: ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    guardiansIsEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPaddingText),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.lightBlue, // Cor da borda
                                      width: 3, // Largura da borda
                                    ),
                                  ),
                                  height: 200,
                                  child: const Text(
                                      "Não há nenhum responsável cadastrado"),
                                )))
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightBlue, // Cor da borda
                                    width: 3, // Largura da borda
                                  ),
                                ),
                                height: 200,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                      itemCount: student.guardians.length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                          child: ListTile(
                                            onTap: () {},
                                            title: Text(
                                              student.guardians[index].name,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPaddingText),
                        child: Text(
                          "Advertências: ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    warningIsEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.lightBlue, // Cor da borda
                                      width: 3, // Largura da borda
                                    ),
                                  ),
                                  height: 200,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "Não há nenhuma advertência cadastrada",
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightBlue, // Cor da borda
                                    width: 3, // Largura da borda
                                  ),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                      itemCount: student.guardians.length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                          child: ListTile(
                                            onTap: () {},
                                            title: Text(
                                              student.warnings![index].reason,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPaddingText),
                        child: Text(
                          "Entradas: ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    entryIsEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.lightBlue, // Cor da borda
                                      width: 3, // Largura da borda
                                    ),
                                  ),
                                  height: 200,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: const Text(
                                      "Não há nenhuma entrada cadastrada",
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightBlue, width: 3),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                    itemCount: student.entries!.length,
                                    itemBuilder: (ctx, index) {
                                      final entry = student.entries![index];
                                      final formattedDate =
                                          DateFormat('dd/MM/yyyy HH:mm')
                                              .format(entry.entryAt);
                                      return Container(
                                        child: ListTile(
                                          onTap: () {},
                                          title: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPaddingText),
                        child: Text(
                          "Saídas: ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    exitIsEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.lightBlue, // Cor da borda
                                      width: 3, // Largura da borda
                                    ),
                                  ),
                                  height: 200,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "Não há nenhuma saída cadastrada",
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: verticalPaddingText),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightBlue, // Cor da borda
                                    width: 3, // Largura da borda
                                  ),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                      itemCount: student.exits!.length,
                                      itemBuilder: (ctx, index) {
                                        final exit = student.exits![index];
                                        final formattedDate =
                                            DateFormat('dd/MM/yyyy HH:mm')
                                                .format(exit.exitAt);
                                        return Container(
                                          child: ListTile(
                                            onTap: () {},
                                            title: Text(
                                              formattedDate,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          buildQrCodeWidget(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: exportQrCodeAsPng,
                        child: const Text('Baixar QR Code'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
