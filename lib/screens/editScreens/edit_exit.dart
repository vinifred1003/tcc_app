import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_exit.dart';

class EditExit extends StatefulWidget {
  final void Function(StudentExit) onSubmit;
  final StudentExit studentExit;
  const EditExit(this.onSubmit, this.studentExit, {Key? key}) : super(key: key);

  @override
  State<EditExit> createState() => _EditExitState();
}

class _EditExitState extends State<EditExit> {
  late TextEditingController _rNController;
  late TextEditingController _guardianController;
  late Guardian? _selectedGuardian;
  final _controllerHour = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedHour;

  @override
  void initState() {
    super.initState();
    
    _rNController = TextEditingController(
        text: widget.studentExit.student.registrationNumber);

    _guardianController =
        TextEditingController(text: widget.studentExit.guardian.name);

    _selectedGuardian = widget.studentExit.guardian;

    _selectedDate = DateTime(
      widget.studentExit.exitAt.year,
      widget.studentExit.exitAt.month,
      widget.studentExit.exitAt.day,
    );
    _selectedHour = TimeOfDay(
      hour: widget.studentExit.exitAt.hour,
      minute: widget.studentExit.exitAt.minute,
    );
  }

  _submitForm() {
    final registrationNumber = _rNController.text;
    if (registrationNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('O número de matrícula não pode estar vazio.')),
      );
      return;
    }

    final StudentExit exitSelected = widget.studentExit;

    final student = dummyStudents.firstWhere(
      (student) => student.registrationNumber == registrationNumber,
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
    if (student.id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estudante não encontrado.')),
      );
      return;
    }
    DateTime combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedHour.hour,
      _selectedHour.minute,
    );
    

    final StudentExit newStudentExit = StudentExit(
        id: exitSelected.id,
        studentId: student.id,
        student: student,
        exitAt: combinedDateTime,
        guardianId: _selectedGuardian!.id,
        guardian: _selectedGuardian!,
        createdAt: exitSelected.createdAt,
        updatedAt: DateTime.now());
    widget.onSubmit(newStudentExit);
    Navigator.of(context).pop();
  }

  _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    ).then((selectedTime24Hour) {
      if (selectedTime24Hour == null) {
        return;
      }
      setState(() {
        _selectedHour = selectedTime24Hour;
        _controllerHour.text = DateFormat('HH:mm').format(
          DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _selectedHour.hour,
            _selectedHour.minute,
          ),
        );
      });
    });
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final guardiansOptions = widget.studentExit.student.guardians
        
        .toList();
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _rNController,
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'N° Matricula',
              ),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}'),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Selecionar Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text('Hora Selecionada: ${DateFormat('HH:mm').format(
                      DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedHour.hour,
                        _selectedHour.minute,
                      ),
                    )}'),
                  ),
                  TextButton(
                    onPressed: _showTimePicker,
                    child: Text(
                      'Selecionar Hora',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            DropdownButtonFormField<Guardian>(
              value: _selectedGuardian,
              icon: const Icon(Icons.arrow_drop_down),
              items: guardiansOptions.map((Guardian option) {
                return DropdownMenuItem<Guardian>(
                  value: option,
                  child: Text(option.name),
                );
              }).toList(),
              onChanged: (Guardian? newValue) {
                setState(() {
                  _selectedGuardian = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione uma opção';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        Theme.of(context).textTheme.labelLarge?.color,
                  ),
                  child: const Text(
                    'Enviar',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
