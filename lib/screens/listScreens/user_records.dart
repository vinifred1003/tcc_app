import 'package:flutter/material.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/user.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';

class UserRecords extends StatelessWidget {
  final List<User>? users;
  final List<Student>? students;
  const UserRecords(this.users, this.students, {Key? key}) : super(key: key);

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
              itemCount: users?.length ?? students?.length,
              itemBuilder: (ctx, index) {
                final user = users?[index];
                final student = students?[index];
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
                      user?.name ?? student?.name ?? "Fail",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(user?.employee?.occupation?.name ??
                        student?.studentClass?.name ??
                        "Fail"),
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
