import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_entry.dart';
import 'package:tcc_app/models/student_exit.dart';
import 'package:tcc_app/screens/editScreens/edit_employee.dart';
import 'package:tcc_app/screens/login_screen.dart';
import 'package:tcc_app/screens/profileScreens/student_profile.dart';

import '../models/user.dart';
import 'components/global/app_drawer.dart';
import 'components/global/base_app_bar.dart';
import 'components/home/center_buttons.dart';
import 'components/home/footer.dart';
import 'components/home/profile_display.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final Employee employee;

  const HomeScreen({super.key, required this.employee});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> _guardiansOptions = [];
  String? _selectedOption;
  String scanResult = "";
  @override
  void initState() {
    super.initState();
  }

  void _selectLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return LoginScreen();
      }),
    );
  }

  void addExit(Student student, Guardian guardian) {
    dummyExits.add(StudentExit(
        id: dummyStudents.length + 1,
        studentId: student.id,
        student: student,
        guardianId: guardian.id,
        exitAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        guardian: guardian));

    Navigator.pop(context, 'OK');
  }

  Future<void> exitScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        scanResult = barcodeScanRes;
      });

      if (barcodeScanRes != '-1') {
        final url = Uri.parse(
            '${AppConfig.baseUrl}/student/registration-number/$barcodeScanRes');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final student = Student.fromJson(responseData);

          _guardiansOptions =
              student.guardians.map((guardian) => guardian.name).toList();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: const Text('QR Scan Result'),
              content: Text('Registrar saída do estudante ${student.name}'),
              actions: <Widget>[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Selecione o Responsável",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: _selectedOption,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _guardiansOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione uma opção';
                    }
                    return null;
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final selectedGuardian = student.guardians.firstWhere(
                        (guardian) => guardian.name == _selectedOption);

                    final exitUrl = Uri.parse(
                        '${AppConfig.baseUrl}/students-attendance/exit');
                    final payload = jsonEncode({
                      'registrationNumber': barcodeScanRes,
                      'guardianId': selectedGuardian.id,
                    });

                    final exitResponse = await http.post(
                      exitUrl,
                      headers: {'Content-Type': 'application/json'},
                      body: payload,
                    );

                    if (exitResponse.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saída registrada com sucesso!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      final errorMessage =
                          jsonDecode(exitResponse.body)['message'];

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage ??
                              'Ocorreu um erro ao tentar registrar a entrada do estudante.'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          final errorMessage = jsonDecode(response.body)['message'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ??
                  'Ocorreu um erro ao tentar registrar a enytrada do estudante.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to scan QR code';
    }
  }

  void addEntry(String studentRegistration) async {
    final url = Uri.parse('${AppConfig.baseUrl}/students-attendance/entry');
    final payload = jsonEncode({'registrationNumber': studentRegistration});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrada registrada com sucesso!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ??
              'Ocorreu um erro ao tentar registrar a enytrada do estudante.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> entryScan() async {
    String barcodeScanRes;
    try {
      // Inicia o fluxo de leitura do QR code
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (!mounted) return;

      if (barcodeScanRes != '-1') {
        // Chama a função de adicionar entrada
        addEntry(barcodeScanRes);
      }
    } on PlatformException {
      print('Erro ao tentar acessar a câmera para leitura do QR code.');
    }
  }

  void _selectStudentProfile(BuildContext context, Student studentSelected) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return StudentProfile(student: studentSelected);
      }),
    );
  }

  Future<void> profileScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    Student? student;
    try {
      student = dummyStudents.firstWhere(
        (student) => student.registrationNumber == barcodeScanRes,
      );
    } catch (e) {
      student = null;
      const SnackBar(
        content: Text(
          'Estudante não encontrado!',
        ),
        duration: Duration(seconds: 2),
      );
    }
    if (student != null) {
      _selectStudentProfile(context, student);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.employee;
    // Use MediaQuery with constraints to make the layout more responsive
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate paddings as a percentage of screen size with minimum values
    final horizontalPadding = max(screenWidth * 0.1, 20.0);
    final verticalPadding = max(screenHeight * 0.1, 20.0);
    final topPaddingFooter = max(screenHeight * 0.05, 15.0);
    final bottomPaddingFooter = max(screenHeight * 0.02, 10.0);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const BaseAppBar(screen_title: Text("Home")),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: ProfileDisplay(
                      employee: e,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          child: CenterButtons(
                            exitScan: exitScan,
                            entryScan: entryScan,
                            profileScan: profileScan,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: topPaddingFooter,
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: bottomPaddingFooter,
                    ),
                    child: Footer(
                      selectedLoginScreen: () => _selectLoginScreen(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
