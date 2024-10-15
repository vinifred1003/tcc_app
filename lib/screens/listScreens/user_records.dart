import 'package:flutter/material.dart';
import 'package:tcc_app/models/user.dart';
import '../../models/user.dart';
import '../../components/global/base_app_bar.dart';
import '../../components/global/app_drawer.dart';

class UserRecord extends StatelessWidget {
  final List<User> users;
  const UserRecord(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEmpty = users.isEmpty;

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
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
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
                    itemCount: users.length,
                    itemBuilder: (ctx, index) {
                      final tr = users[index];
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
                            tr.username,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(tr.jobPosition),
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
