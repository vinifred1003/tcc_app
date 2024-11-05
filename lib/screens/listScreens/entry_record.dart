import 'package:flutter/material.dart';
import '../../models/student_entry.dart';
import 'package:intl/intl.dart';
import '../../components/global/base_app_bar.dart';
import '../../components/global/app_drawer.dart';

class EntryRecord extends StatelessWidget {
  final List<StudentEntry> students;
  const EntryRecord(this.students, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEmpty = students.isEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Registros de Entrada")),
      drawer: AppDrawer(),
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
          isEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Nenhuma Saida ou Entrada',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (ctx, index) {
                      final tr = students[index];
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
                            tr.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            tr.type +
                                " " +
                                DateFormat('d MMM y').format(tr.date),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
