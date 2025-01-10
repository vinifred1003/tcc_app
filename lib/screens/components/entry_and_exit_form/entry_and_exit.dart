import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryAndExit extends StatefulWidget {
  const EntryAndExit({super.key});

  @override
  State<EntryAndExit> createState() => _EntryAndExitState();
}

class _EntryAndExitState extends State<EntryAndExit> {
  final TextEditingController _controllerDate = TextEditingController();

  final TextEditingController _controllerHour = TextEditingController();

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
        _controllerDate.text = DateFormat('dd/MM/y').format(_selectedDate);
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
            validator: validateField,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              hintText: '',
              labelText: 'N° Matricula',
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
          child: TextFormField(
            controller: _controllerHour,
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
                  Icons.hourglass_bottom,
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
