import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late List<Guardian> studentGuardians = [];
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
    
    Navigator.of(context).pop(newStudentEntry);
  }

  

  _submitExitForm() {
    final registrationNumber = rNController.text;
    final date = selectedDateController.text;
    final hour = selectedHourController.text;
    final guardian = _selectedOption;
    print(registrationNumber);
    print(date);
    print(hour);
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

    final StudentExit newStudentExit = StudentExit(
        id: dummyStudentEntry.length + 1,
        studentId: student.id,
        guardianId: guardian.id,
        student: student,
        exitAt: parsedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        guardian: guardian);
    Navigator.of(context).pop(newStudentExit);
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
                        onFieldSubmitted: (String value) {
                          try {
                            // Find the student based on the entered registration number
                            studentIdentified = dummyStudents.firstWhere(
                              (student) => student.registrationNumber == value,
                            );
                          } catch (e) {
                            // Handle the case where no student is found
                            studentIdentified = null;
                            studentGuardians = [];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Estudante não encontrado.')),
                            );
                          }
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: '',
                          labelText: 'N° Matricula',
                        ),
                      ),
                    ),
                    EntryAndExit(
                        selectedDateController, selectedHourController),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: TextFormField(
                        controller: rNController,
                        onFieldSubmitted: (String value) {
                          setState(() {
                            try {
                              // Find the student based on the entered registration number
                              studentIdentified = dummyStudents.firstWhere(
                                (student) =>
                                    student.registrationNumber == value,
                              );
                              // Update the list of guardians
                              studentGuardians = studentIdentified!.guardians;
                              // Reset the selected option
                              _selectedOption = null;
                            } catch (e) {
                              // Handle the case where no student is found
                              studentIdentified = null;
                              studentGuardians = [];
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Estudante não encontrado.')),
                              );
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: '',
                          labelText: 'N° Matricula',
                        ),
                      ),
                    ),
                    EntryAndExit(
                        
                        selectedDateController, selectedHourController),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
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
