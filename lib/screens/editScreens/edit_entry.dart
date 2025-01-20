import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_app/config.dart';
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
  final _controllerHour = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedHour;

  @override
  void initState() {
    super.initState();

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

  Future<void> _submitForm() async {
    DateTime combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedHour.hour,
      _selectedHour.minute,
    );

    final response = await http.patch(
      Uri.parse(
          '${AppConfig.baseUrl}/students-attendance/entry/${widget.studentEntry.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'entryAt': combinedDateTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final entryResponse = StudentEntry.fromJson(json.decode(response.body));

      widget.onSubmit(entryResponse);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrada atualizada com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final errorMessage = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Erro ao atualizar entrada.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Advertência'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'N° Matricula: ${widget.studentEntry.student!.registrationNumber}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nome: ${widget.studentEntry.student!.name}',
                    style: TextStyle(fontSize: 18),
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
                          child: Text(
                              'Hora Selecionada: ${DateFormat('HH:mm').format(
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
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
          ),
        ));
  }
}
