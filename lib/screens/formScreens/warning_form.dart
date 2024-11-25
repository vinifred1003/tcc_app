import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';

const Duration fakeAPIDuration = Duration(seconds: 1);

class WarningForm extends StatefulWidget {
  const WarningForm({super.key});

  @override
  State<WarningForm> createState() => _WarningFormState();
}

class _WarningFormState extends State<WarningForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDate = TextEditingController();
  final List<String> _studentsSelected = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];
  DateTime _selectedDate = DateTime.now();
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: BaseAppBar(screen_title: Text("Ocorrências")),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: Column(
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
                  labelText: 'Emissor da Ocorrência',
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
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                children: [
                  SearchAnchor(
                    isFullScreen: false,
                    builder:
                        (BuildContext context, SearchController controller) {
                      return CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            controller.openView();
                          },
                        ),
                      );
                    },
                    suggestionsBuilder: (BuildContext context,
                        SearchController controller) async {
                      _searchingWithQuery = controller.text;
                      final List<String> options =
                          (await _FakeAPI.search(_searchingWithQuery!))
                              .toList();

                      if (_searchingWithQuery != controller.text) {
                        return _lastOptions;
                      }

                      _lastOptions =
                          List<ListTile>.generate(options.length, (int index) {
                        final String item = options[index];
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              _studentsSelected.add(item);
                            });
                            controller.closeView(null);
                          },
                        );
                      });

                      return _lastOptions;
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _studentsSelected.length,
                        itemBuilder: (ctx, index) {
                          return SizedBox(
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.all(horizontalPadding),
                              child: Card(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: horizontalPadding),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _studentsSelected[index][0]
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _studentsSelected.removeAt(index);
                                          });
                                        },
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: TextFormField(
                validator: validateField,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  hintText: '',
                  labelText: 'Descrição',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
    );
  }
}

class _FakeAPI {
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  static Future<Iterable<String>> search(String query) async {
    await Future<void>.delayed(fakeAPIDuration);
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return _kOptions.where((String option) {
      return option.contains(query.toLowerCase());
    });
  }
}
