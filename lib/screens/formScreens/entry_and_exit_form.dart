import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_entry.dart';
import 'package:tcc_app/models/student_exit.dart';
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
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final TextEditingController rNController = TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();
  final TextEditingController selectedHourController = TextEditingController();

  _submitEntryForm() {
    final registrationNumber = rNController.text;
    final date = selectedDateController.text;
    final hour = selectedHourController.text;
    print(registrationNumber);
    print(date);
    print(hour);
    if (registrationNumber.isEmpty || date.isEmpty || hour.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum campo pode estar vazio.')),
      );
      return;
    }
    final completeDate = date + " " + hour;
    print(completeDate);
    DateTime parsedDate = _dateFormat.parse(completeDate);

    Student? student;
    try {
      student = dummyStudents.firstWhere(
        (student) => student.registrationNumber == registrationNumber,
      );
    } catch (e) {
      student = null;
    }
    if (student == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estudante não encontrado.')),
      );
      return;
    }

    final StudentEntry newStudentEntry = StudentEntry(
        id: dummyStudentEntry.length + 1,
        studentId: student.id,
        student: student,
        entryAt: parsedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    _addNewStudentEntry(newStudentEntry);
    Navigator.of(context).pop();
  }

  void _addNewStudentEntry(StudentEntry entry) {
    final newEntry = StudentEntry(
        id: dummyStudentEntry.length + 1,
        studentId: entry.studentId,
        student: entry.student,
        entryAt: entry.entryAt,
        createdAt: entry.createdAt,
        updatedAt: entry.updatedAt);
    setState(() {
      dummyStudentEntry.add(newEntry);
    });
  }

  _submitExitForm() {
    final registrationNumber = rNController.text;
    final date = selectedDateController.text;
    final hour = selectedHourController.text;
    print(registrationNumber);
    print(date);
    print(hour);
    if (registrationNumber.isEmpty || date.isEmpty || hour.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum campo pode estar vazio.')),
      );
      return;
    }
    final completeDate = date + " " + hour;
    DateTime parsedDate = _dateFormat.parse(completeDate);
    Student? student;
    try {
      student = dummyStudents.firstWhere(
        (student) => student.registrationNumber == registrationNumber,
      );
    } catch (e) {
      student = null;
    }
    if (student == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estudante não encontrado.')),
      );
      return;
    }

    final StudentEntry newStudentEntry = StudentEntry(
        id: dummyStudentEntry.length + 1,
        studentId: student.id,
        student: student,
        entryAt: parsedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    _addNewStudentExit(newStudentEntry, _selectedOption!);
    Navigator.of(context).pop();
  }

  void _addNewStudentExit(StudentEntry exitIncomplete, Guardian guardian) {
    final newExit = StudentExit(
        id: dummyExits.length + 1,
        studentId: exitIncomplete.studentId,
        student: exitIncomplete.student,
        guardianId: guardian.id,
        exitAt: exitIncomplete.entryAt,
        createdAt: exitIncomplete.createdAt,
        updatedAt: exitIncomplete.updatedAt,
        guardian: guardian);
    dummyExits.add(newExit);
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
                    EntryAndExit(rNController, selectedDateController,
                        selectedHourController),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: ElevatedButton(
                        onPressed: () {
                          _submitEntryForm();
                          if (_EntryFormKey.currentState!.validate()) {
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
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
                    EntryAndExit(rNController, selectedDateController,
                        selectedHourController),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: DropdownButtonFormField<Guardian>(
                        onTap: () {
                          setState(() {
                            studentIdentified = dummyStudents.firstWhere(
                              (student) =>
                                  student.registrationNumber ==
                                  rNController.text,
                            );
                          });
                        },
                        
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
                        items: studentIdentified != null
                            ? studentIdentified!.guardians
                                .map((Guardian option) {
                                return DropdownMenuItem<Guardian>(
                                  value: option,
                                  child: Text(option.name),
                                );
                              }).toList()
                            : [],
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_ExitFormKey.currentState!.validate()) {
                            _submitExitForm();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
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
