import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';

class WarningForm extends StatefulWidget {
  const WarningForm({super.key});

  @override
  State<WarningForm> createState() => _WarningFormState();
}

class _WarningFormState extends State<WarningForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final List<String> _studentsSelected = [];
  final List<Student> _studentsEnvolved = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];
  List<Student> students = [];
  List<Employee> employees = [];
  Employee? _selectedEmployee;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchStudents(), _fetchEmployees()]);
  }

  Future<void> _fetchStudents() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/student'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        students = data.map((json) => Student.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar estudantes.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchEmployees() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/employee'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        employees = data.map((json) => Employee.fromJson(json)).toList();
        print(employees);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar funcionários.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> warningScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (!mounted) return;

      if (barcodeScanRes != '-1') {
        final student = students.firstWhere(
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
        if (!_studentsSelected.contains(student.name)) {
          // Para a apresentação, apenas 1 estudante está sendo inserido
          _studentsEnvolved.clear();

          _studentsEnvolved.add(student);
          setState(() {
            // Para a apresentação, apenas 1 estudante está sendo inserido
            _studentsSelected.clear();

            _studentsSelected.add(student.name);
          });
        }
      }
    } on PlatformException {
      print('Erro ao tentar acessar a câmera para leitura do QR code.');
    }
  }

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1924),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _controllerDate.text = DateFormat('dd/MM/y').format(_selectedDate);
      });
    });
  }

  Future<void> _submitWarningForm() async {
    if (_formKey.currentState!.validate()) {
      final DateTime issuedAtDate =
          DateFormat('dd/MM/y').parse(_controllerDate.text);
      final List<int> studentIds =
          _studentsEnvolved.map((student) => student.id).toList();

      final url = Uri.parse('${AppConfig.baseUrl}/students-warning');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'issuedBy': _selectedEmployee!.id,
          'issuedAt': issuedAtDate.toIso8601String(),
          'reason': _controllerDescricao.text,
          'studentId': studentIds[0],
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Advertência registrada com sucesso.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData.containsKey('message')
            ? responseData['message']
            : 'Erro ao registrar advertência.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: BaseAppBar(screen_title: Text("Ocorrências")),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: DropdownButtonFormField<Employee>(
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    labelText: 'Emissor da Ocorrência',
                  ),
                  value: _selectedEmployee,
                  items: employees.map((Employee employee) {
                    return DropdownMenuItem<Employee>(
                      value: employee,
                      child: Text(employee.name),
                    );
                  }).toList(),
                  onChanged: (Employee? newValue) {
                    setState(() {
                      _selectedEmployee = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione um emissor';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: TextFormField(
                  controller: _controllerDate,
                  validator: validateField,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'Data do Ocorrido',
                      suffixIcon: IconButton(
                          onPressed: _showDatePicker,
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                            size: 30,
                          ))),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: Row(
                  children: [
                    SearchAnchor(
                      isFullScreen: false,
                      builder:
                          (BuildContext context, SearchController controller) {
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  controller.openView();
                                },
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(Icons.qr_code),
                                onPressed: () => warningScan(),
                              ),
                            ),
                          ],
                        );
                      },
                      suggestionsBuilder: (BuildContext context,
                          SearchController controller) async {
                        _searchingWithQuery = controller.text;

                        if (_searchingWithQuery != controller.text) {
                          return _lastOptions;
                        }

                        _lastOptions = List<ListTile>.generate(students.length,
                            (int index) {
                          final String item = students[index].name;
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              if (!_studentsSelected.contains(item)) {
                                setState(() {
                                  // Para a apresentação, apenas 1 estudante está sendo inserido
                                  _studentsEnvolved.clear();
                                  _studentsSelected.clear();

                                  _studentsSelected.add(item);
                                  _studentsEnvolved.add(students[index]);
                                });
                              }
                              controller.closeView(null);
                            },
                          );
                        });

                        return _lastOptions;
                      },
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _studentsSelected.length,
                          itemBuilder: (ctx, index) {
                            return SizedBox(
                              child: Container(
                                // width: 80,
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.all(horizontalPadding),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: horizontalPadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            // Para a apresentação, apenas 1 estudante está sendo inserido
                                            // _studentsSelected[index][0]
                                            //     .toUpperCase(),
                                            _studentsSelected[index],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _studentsEnvolved.removeWhere(
                                                  (student) =>
                                                      student.name ==
                                                      _studentsSelected[index]);
                                              _studentsSelected.removeAt(index);
                                            });
                                          },
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: TextFormField(
                  controller: _controllerDescricao,
                  validator: validateField,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: '',
                    labelText: 'Descrição',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPadding),
                child: ElevatedButton(
                  onPressed: _submitWarningForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).textTheme.labelLarge?.color,
                    foregroundColor: Theme.of(context).colorScheme.primary,
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
    );
  }
}
