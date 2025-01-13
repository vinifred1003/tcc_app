import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/student.dart';

class EditEntry extends StatefulWidget {
  final void Function(/*title, _selectedDate, _selectedHour*/) onSubmit;

  const EditEntry(this.onSubmit, {Key? key}) : super(key: key);

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  final _rGController = TextEditingController();
  final _controllerHour = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedHour = TimeOfDay.now();

  _submitForm() {
    final title = _rGController.text;
    if (title.isEmpty) {
      return;
    }

    widget.onSubmit(/*title, _selectedDate, _selectedHour*/);
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
              controller: _rGController,
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
