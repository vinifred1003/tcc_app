import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class EntryAndExitForm extends StatefulWidget {
  const EntryAndExitForm({super.key});

  @override
  State<EntryAndExitForm> createState() => _EntryAndExitFormState();
}

class _EntryAndExitFormState extends State<EntryAndExitForm>
    with TickerProviderStateMixin {
  final _EntryFormKey = GlobalKey<FormState>();
  final _ExistFormKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();


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
        _controller.text = '${DateFormat('dd/MM/y').format(_selectedDate)}';
      });
    });
  }
  Future<void> _pickHour() async {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          title: const Text("Novo Registro"),
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
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      validator: validateField,
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _controller,
                      validator: validateField,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          labelText: 'Data da chegada',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _controller,
                      validator: validateField,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          labelText: 'Hora da Chegada',
                          suffixIcon: IconButton(
                              onPressed: _showDatePicker,
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                                size: 30,
                              ))),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _ExistFormKey,
              child: const Column(
                children: [],
              ),
            ),
          ],
        ), //
      ),
    );
  }
}
