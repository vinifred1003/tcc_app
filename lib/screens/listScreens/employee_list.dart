import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/screens/editScreens/edit_employee.dart';
import 'package:tcc_app/screens/formScreens/employee_form.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';

class EmployeeList extends StatefulWidget {
  final List<Employee>? employees;
  const EmployeeList(this.employees, {Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  void _selectManagerSignupForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EmployeeForm();
      }),
    ).then((result) {
      if (result[1] != null && result[0] != null) {
        setState(() {
          dummyUser.add(result[0]);
          dummyEmployee.add(result[1]);
        });
      }
    });
  }

  void _selectEditEmployeeForm(BuildContext context, Employee e) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditEmployee(e);
      },
    ).then((result) {
      if (result[1] != null && result[0] != null) {
        int indexUser = dummyUser.indexWhere((user) => user.id == result[0].id);
        int indexEmployee =
            dummyEmployee.indexWhere((employee) => employee.id == result[1].id);
        setState(() {
          dummyUser[indexUser] = result[0];
          dummyEmployee[indexEmployee] = result[1];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Registros de Usuários")),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
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
                      // Since this is StatelessWidget, you can't use setState.
                      controller.closeView(item);
                    },
                  );
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.employees?.length,
              itemBuilder: (ctx, index) {
                final employee = widget.employees![index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: FittedBox(child: Text('foto')),
                      ),
                    ),
                    title: Text(
                      employee?.name ?? "Fail",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                        employee?.occupation?.name ?? "Cargo não informado"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _selectEditEmployeeForm(context, employee);
                        } else if (value == 'delete') {
                          // Ação para Deletar
                          print('Deletar item $index');
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
