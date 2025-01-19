import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryAndExit extends StatefulWidget {
  final TextEditingController selectedDateController;
  final TextEditingController selectedHourController;

  EntryAndExit(this.selectedDateController, this.selectedHourController,
      {Key? key})
      : super(key: key);

  @override
  State<EntryAndExit> createState() => _EntryAndExitState();
}

class _EntryAndExitState extends State<EntryAndExit> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedHour = TimeOfDay.now();

  // Validator function
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  DateTime currentDateAndTime() {
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay.now();

    // Combinar DateTime.now() com TimeOfDay.now()
    DateTime combinedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      currentTime.hour,
      currentTime.minute,
    );
    return combinedDateTime;
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
        widget.selectedDateController.text =
            DateFormat('dd/MM/y').format(_selectedDate);
      });
    });
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
        widget.selectedHourController.text = DateFormat('HH:mm').format(
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

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: TextFormField(
            readOnly: true,
            onTap: _showDatePicker,
            controller: widget.selectedDateController,
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
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: TextFormField(
            readOnly: true,
            onTap: _showTimePicker,
            controller: widget.selectedHourController,
            validator: validateField,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              labelText: 'Hora do Ocorrido',
              suffixIcon: IconButton(
                onPressed: _showTimePicker,
                icon: const Icon(
                  Icons.access_alarm,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
