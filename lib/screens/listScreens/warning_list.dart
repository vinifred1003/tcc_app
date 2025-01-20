import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tcc_app/models/student_warning.dart';
import 'package:tcc_app/screens/editScreens/edit_warning.dart';
import 'package:tcc_app/screens/formScreens/warning_form.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/config.dart';

class WarningList extends StatefulWidget {
  const WarningList({Key? key}) : super(key: key);

  @override
  State<WarningList> createState() => _WarningListState();
}

class _WarningListState extends State<WarningList> {
  List<StudentWarning> warnings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWarnings();
  }

  Future<void> _fetchWarnings() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/students-warning'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        warnings = data.map((json) => StudentWarning.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar advertências.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteWarning(int id) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/students-warning/$id'),
    );
    if (response.statusCode == 200) {
      setState(() {
        warnings.removeWhere((warning) => warning.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Advertência deletada com sucesso.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao deletar advertência.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir esta advertência?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Confirmar'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteWarning(id);
            },
          ),
        ],
      ),
    );
  }

  void _selectWarningForm(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const WarningForm();
    })).then((result) {
      _fetchWarnings();
    });
  }

  _editWarning(StudentWarning warningChanged) {
    int index = warnings.indexWhere((warn) => warn.id == warningChanged.id);
    setState(() {
      _fetchWarnings();
    });
  }

  _openEditWarningForm(
      BuildContext context, StudentWarning studentWarningSelected) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditWarning(_editWarning, studentWarningSelected);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Registros de Advertências")),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {},
                        onChanged: (_) {},
                        leading: const Icon(Icons.search),
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            controller.closeView(item);
                          },
                        );
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: warnings.length,
                    itemBuilder: (ctx, index) {
                      final warning = warnings[index];

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            DateFormat('dd/MM/yyyy').format(warning.issuedAt),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(warning.reason),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openEditWarningForm(context, warning);
                              } else if (value == 'delete') {
                                _confirmDelete(context, warning.id);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Editar'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Deletar'),
                              ),
                            ],
                            icon: const Icon(Icons.menu),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () => _selectWarningForm(context),
        child: Icon(color: Theme.of(context).colorScheme.primary, Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
