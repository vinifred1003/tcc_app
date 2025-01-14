import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_entry.dart';

class EditEntry extends StatefulWidget {
  final void Function(StudentEntry) onSubmit;
  final StudentEntry studentEntry;
  const EditEntry(this.onSubmit, this.studentEntry, {Key? key})
      : super(key: key);

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late TextEditingController _rNController;
  final _controllerHour = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedHour;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com o valor recebido
    _rNController = TextEditingController(
        text: widget.studentEntry.student.registrationNumber);

    _selectedDate = DateTime(
      widget.studentEntry.entryAt.year,
      widget.studentEntry.entryAt.month,
      widget.studentEntry.entryAt.day,
    );
    _selectedHour = TimeOfDay(
      hour: widget.studentEntry.entryAt.hour,
      minute: widget.studentEntry.entryAt.minute,
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
    
    final StudentEntry entrySelected = widget.studentEntry;

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
    final StudentEntry newStudentEntry = StudentEntry(
        id: entrySelected.id,
        studentId: student.id,
        student: student,
        entryAt: combinedDateTime,
        createdAt: entrySelected.createdAt,
        updatedAt: DateTime.now());
    widget.onSubmit(newStudentEntry);
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
