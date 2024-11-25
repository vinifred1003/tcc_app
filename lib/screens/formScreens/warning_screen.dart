import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';

const Duration fakeAPIDuration = Duration(seconds: 1);

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentsController = TextEditingController();
  final List<String> _studentsSelected = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];
  late Color _transparent = Colors.black;
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Color changeColor() {
    _transparent = Color(0x00000000);
    return _transparent;
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
                            changeColor;
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
                              margin: EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _studentsSelected[index][0]
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 30,
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
