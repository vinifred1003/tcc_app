import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import '../components/entry_and_exit_form/entry_and_exit.dart';

class EntryAndExitForm extends StatefulWidget {
  const EntryAndExitForm({super.key});

  @override
  State<EntryAndExitForm> createState() => _EntryAndExitFormState();
}

class _EntryAndExitFormState extends State<EntryAndExitForm>
    with TickerProviderStateMixin {
  final _EntryFormKey = GlobalKey<FormState>();
  final _ExitFormKey = GlobalKey<FormState>();
  Guardian? _selectedOption;
  Student? studentIdentified;
  late List<Guardian> studentGuardians = [];
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final TextEditingController rNController = TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();
  final TextEditingController selectedHourController = TextEditingController();

  Future<void> _fetchStudent() async {
    final registrationNumber = rNController.text;
    if (registrationNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha o número de matrícula.')),
      );
      return;
    }

    final url = Uri.parse(
        '${AppConfig.baseUrl}/student/registration-number/$registrationNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        studentIdentified = Student.fromJson(responseData);
        studentGuardians = studentIdentified!.guardians;
        _selectedOption = null; // Reset the selected guardian
      });
    } else {
      setState(() {
        studentIdentified = null;
        studentGuardians = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estudante não encontrado.')),
      );
    }
  }

  Future<void> _submitEntryForm() async {
    final registrationNumber = rNController.text;
    final date = selectedDateController.text;
    final hour = selectedHourController.text;

    if (registrationNumber.isEmpty || date.isEmpty || hour.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum campo pode estar vazio.')),
      );
      return;
    }

    final completeDate = date + " " + hour;
    DateTime parsedDate = _dateFormat.parse(completeDate);

    final url = Uri.parse('${AppConfig.baseUrl}/students-attendance/entry');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'entryAt': parsedDate.toIso8601String(),
        'registrationNumber': registrationNumber,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entrada registrada com sucesso.')),
      );
      Navigator.of(context).pop('success');
    } else {
      final responseData = json.decode(response.body);
      final errorMessage = responseData.containsKey('message')
          ? responseData['message']
          : 'Erro ao registrar entrada.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _submitExitForm() async {
    final registrationNumber = rNController.text;
    final date = selectedDateController.text;
    final hour = selectedHourController.text;
    final guardian = _selectedOption;

    if (registrationNumber.isEmpty ||
        date.isEmpty ||
        hour.isEmpty ||
        guardian == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum campo pode estar vazio.')),
      );
      return;
    }

    final completeDate = date + " " + hour;
    DateTime parsedDate = _dateFormat.parse(completeDate);

    final url = Uri.parse('${AppConfig.baseUrl}/students-attendance/exit');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'exitAt': parsedDate.toIso8601String(),
        'registrationNumber': registrationNumber,
        'guardianId': guardian.id,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entrada registrada com sucesso.')),
      );
      Navigator.of(context).pop('success');
    } else {
      final responseData = json.decode(response.body);
      final errorMessage = responseData.containsKey('message')
          ? responseData['message']
          : 'Erro ao registrar saída.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _scanQRCode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        setState(() {
          rNController.text = barcodeScanRes;
        });
        _fetchStudent();
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text("Novo Registro"),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.door_front_door_outlined,
                    color: Theme.of(context).colorScheme.inversePrimary),
                child: Text(
                  "Entrada",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              Tab(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                child: Text(
                  "Saida",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Form(
              key: _EntryFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: TextFormField(
                        controller: rNController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: '',
                          labelText: 'N° Matricula',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.qr_code_scanner),
                            onPressed: _scanQRCode,
                          ),
                        ),
                      ),
                    ),
                    EntryAndExit(
                        selectedDateController, selectedHourController),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_EntryFormKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            _submitEntryForm().then((_) {
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(50, 75),
                        ),
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _ExitFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: TextFormField(
                        controller: rNController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: '',
                          labelText: 'N° Matricula',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.qr_code_scanner),
                            onPressed: _scanQRCode,
                          ),
                        ),
                      ),
                    ),
                    EntryAndExit(
                        selectedDateController, selectedHourController),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Guardian>(
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
                              items: studentGuardians.map((Guardian option) {
                                return DropdownMenuItem<Guardian>(
                                  value: option,
                                  child: Text(option.name),
                                );
                              }).toList(),
                              onChanged: (Guardian? newValue) {
                                setState(() {
                                  _selectedOption = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.name.isEmpty) {
                                  return 'Selecione uma opção';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: _fetchStudent,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_ExitFormKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            _submitExitForm().then((_) {
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(50, 75),
                        ),
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
