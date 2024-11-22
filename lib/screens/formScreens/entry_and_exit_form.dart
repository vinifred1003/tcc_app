import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? _selectedOption;
 
  final List<String> _options = ['Opção 1', 'Opção 2', 'Opção 3', 'Opção 4'];

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;
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
                  EntryAndExit(),
                ],
              ),
            ),
            Form(
              key: _ExitFormKey,
              child: Column(
                children: [
                  EntryAndExit(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding),
                    child: DropdownButtonFormField<String>(
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
                      items: _options.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).textTheme.labelLarge?.color,
                        foregroundColor: Theme.of(context).colorScheme.primary,
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
          ],
        ),
       
      ),
    );
  }
}
