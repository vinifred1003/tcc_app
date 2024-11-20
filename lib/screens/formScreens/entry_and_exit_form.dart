import 'package:flutter/material.dart';

class EntryAndExitForm extends StatefulWidget {
  const EntryAndExitForm({super.key});

  @override
  State<EntryAndExitForm> createState() => _EntryAndExitFormState();
}

class _EntryAndExitFormState extends State<EntryAndExitForm>
    with TickerProviderStateMixin {
  final _EntryFormKey = GlobalKey<FormState>();
  final _ExistFormKey = GlobalKey<FormState>();

  DateTime? _selectedDateTime;

  // Validator function
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || date == null) return; // User canceled the date picker

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted || time == null) return; // User canceled the time picker

    // Combine date and time
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

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
                      validator: validateField,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          labelText: 'Hora e data da chegada',
                          suffixIcon: IconButton(
                              onPressed: _pickDateTime,
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
