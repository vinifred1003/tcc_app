import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
        // Busca o primeiro estudante com o registrationNumber igual a '812'
        final student = dummyStudents.firstWhere(
          (student) => student.registrationNumber == barcodeScanRes,
          orElse: () => Student(
            id: 0,
            name: 'Não encontrado',
            registrationNumber: '',
            birthDate: DateTime.now(),
            classId: 0,
            qrCode: '',
            photo: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            studentClass: Class(id: 0, name: 'Sem classe'),
            guardians: [],
            warnings: [],
            entries: [],
            exits: [],
          ),
        );
        _guardiansOptions =
            student.guardians.map((guardian) => guardian.name).toList();
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('QR Scan Result'),
            content: Text('Scanned content: $barcodeScanRes'),
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
                onPressed: () {
                  final selectedGuardian = student.guardians.firstWhere(
                      (guardian) => guardian.name == _selectedOption);

                  // Chama o método addExit
                  addExit(student, selectedGuardian);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to scan QR code';
    }
  }

  void addEntry(String studentRegistration) {
    // Busca o estudante pelo código de registro
    final student = dummyStudents.firstWhere(
      (student) => student.registrationNumber == studentRegistration,
      orElse: () => Student(
        id: 0,
        name: 'Não encontrado',
        registrationNumber: '',
        birthDate: DateTime.now(),
        classId: 0,
        qrCode: '',
        photo: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        studentClass: Class(id: 0, name: 'Sem classe'),
        guardians: [],
        warnings: [],
        entries: [],
        exits: [],
      ),
    );
    // Adiciona entrada à lista de entradas
    dummyStudentEntry.add(StudentEntry(
      id: dummyStudentEntry.length + 1,
      studentId: student.id,
      student: student,
      entryAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    // Exibe mensagem informando que a entrada foi registrada
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          student.id != 0
              ? 'Entrada registrada para o estudante ${student.name}!'
              : 'Estudante não encontrado!',
        ),
        duration: Duration(seconds: 2),
      ),
    );
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
        return StudentProfile(studentSelected);
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
