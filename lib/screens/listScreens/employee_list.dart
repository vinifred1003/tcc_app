import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/screens/editScreens/edit_employee.dart';
import 'package:tcc_app/screens/formScreens/employee_form.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import 'package:tcc_app/config.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/employee'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        employees = data.map((json) => Employee.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar funcionários.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEmployee(int id) async {
    final response =
        await http.delete(Uri.parse('${AppConfig.baseUrl}/employee/$id'));
    if (response.statusCode == 200) {
      setState(() {
        employees.removeWhere((employee) => employee.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Funcionário deletado com sucesso.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao deletar funcionário.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Deleção'),
        content:
            const Text('Você tem certeza que deseja deletar este funcionário?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteEmployee(employee.id!);
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  Future<Widget> fetchImage(String? photoFilename) async {
    if (photoFilename == null) {
      return const Icon(Icons.person);
    }

    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/upload/$photoFilename'));
    if (response.statusCode == 200) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(response.bodyBytes),
      );
    } else {
      return const Icon(Icons.person);
    }
  }

  void _selectManagerSignupForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EmployeeForm();
      }),
    ).then((result) {
      _fetchEmployees();
    });
  }

  void _selectEditEmployeeForm(BuildContext context, Employee e) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditEmployee(e);
      },
    ).then((result) {
      _fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Registros de Educadores")),
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
                    itemCount: employees.length,
                    itemBuilder: (ctx, index) {
                      final employee = employees[index];

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        child: ListTile(
                          leading: FutureBuilder<Widget>(
                            future: fetchImage(employee.photo),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.data ??
                                    const Icon(Icons.person);
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                          title: Text(
                            employee.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(employee.occupation?.name ??
                              "Cargo não informado"),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _selectEditEmployeeForm(context, employee);
                              } else if (value == 'delete') {
                                _confirmDelete(context, employee);
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
        onPressed: () => _selectManagerSignupForm(context),
        child: Icon(color: Theme.of(context).colorScheme.primary, Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
