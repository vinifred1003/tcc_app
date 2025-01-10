import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_warning.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:flutter/services.dart';

const Duration fakeAPIDuration = Duration(seconds: 1);

class WarningForm extends StatefulWidget {
  const WarningForm({super.key});

  @override
  State<WarningForm> createState() => _WarningFormState();
}

class _WarningFormState extends State<WarningForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerEmissor = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final List<String> _studentsSelected = [];
  final List<Student> _studentsEnvolved = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];
  final List<String> studentsName =
      dummyStudents.map((student) => student.name).toList().cast<String>();
  DateTime _selectedDate = DateTime.now();
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<void> warningScan() async {
    String barcodeScanRes;
    try {
      // Inicia o fluxo de leitura do QR code
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (!mounted) return;

      if (barcodeScanRes != '-1') {
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
        _studentsEnvolved.add(student);
        setState(() {
          _studentsSelected.add(student.name);
        });
      }
    } on PlatformException {
      print('Erro ao tentar acessar a câmera para leitura do QR code.');
    }
  }

  int getEmployeeIdByName(String name) {
    final employee = dummyEmployee.firstWhere(
      (employee) => employee.name.toLowerCase() == name.toLowerCase(),
    );
    print(employee.name);
    return employee.id;
  }

  Employee getEmployeeByName(String name) {
    final employee = dummyEmployee.firstWhere(
      (employee) => employee.name.toLowerCase() == name.toLowerCase(),
    );
    return employee;
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: TextFormField(
                validator: validateField,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  hintText: '',
                  labelText: ' Nome Completo do Emissor da Ocorrência',
                ),
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

                      _lastOptions =
                          List<ListTile>.generate(
                          studentsName.length, (int index) {
                        final String item = studentsName[index];
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              _studentsSelected.add(item);
                            });
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
                              width: 80,
                              margin: EdgeInsets.all(horizontalPadding),
                              child: Card(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: horizontalPadding),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _studentsSelected[index][0]
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _studentsSelected.removeAt(index);
                                          });
                                        },
                                        color:
                                            Theme.of(context).colorScheme.error,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    final DateTime issuedAtDate =
                        DateFormat('dd/MM/y').parse(_controllerDate.text);
                    dummyWarnings.add(StudentWarning(
                        id: dummyWarnings.length + 1,
                        studentId: _studentsEnvolved[0].id,
                        issuedBy: getEmployeeIdByName(_controllerEmissor.text),
                        issuedAt: issuedAtDate,
                        reason: _controllerDescricao.text,
                        severity: "Grave",
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        student: _studentsEnvolved[0],
                        issuedByEmployee:
                            getEmployeeByName(_controllerEmissor.text)));
                  }

                },
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
    );
  }
}


