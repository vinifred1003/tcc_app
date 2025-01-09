import 'package:flutter/material.dart';
import 'package:tcc_app/models/student_warning.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import 'package:intl/intl.dart';
class WarningList extends StatelessWidget {
  final List<StudentWarning>? warnings;
  const WarningList(this.warnings, {Key? key}) : super(key: key);

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
              itemCount: warnings?.length,
              itemBuilder: (ctx, index) {
                final warning = warnings?[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    
                    title: Text(
                      warning != null
                          ? DateFormat('dd/MM/yyyy HH:mm')
                              .format(warning.createdAt!)
                          : 'Data indisponível',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(warning?.reason ?? "Fail"),
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
