import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/student_warning.dart';
import 'package:tcc_app/screens/editScreens/edit_warning.dart';
import 'package:tcc_app/screens/formScreens/warning_form.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import 'package:intl/intl.dart';
class WarningList extends StatefulWidget {
  final List<StudentWarning>? warnings;
  const WarningList(this.warnings, {Key? key}) : super(key: key);

  @override
  State<WarningList> createState() => _WarningListState();
}

class _WarningListState extends State<WarningList> {
  void _selectWarningForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return WarningForm();
      }),
    );
  }

  _editWarning(StudentWarning warningChanged) {
    int index =
        dummyWarnings.indexWhere((warn) => warn.id == warningChanged.id);
    setState(() {
      dummyWarnings[index] = warningChanged;
    });
  }

  _openEditWarningForm(BuildContext context, studentWarningSelected) {
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
              itemCount: widget.warnings?.length,
              itemBuilder: (ctx, index) {
                final warning = widget.warnings?[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    
                    title: Text(
                      warning != null
                          ? DateFormat('dd/MM/yyyy').format(warning.issuedAt)
                          : 'Data indisponível',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(warning?.reason ?? "Motivo não informado"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _openEditWarningForm(context, warning);
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
        onPressed: () => _selectWarningForm(context),
        child: Icon(color: Theme.of(context).colorScheme.primary, Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
    );
  }
}
