import 'package:flutter/material.dart';
import 'package:tcc_app/screens/listScreens/student_list.dart';
import 'package:tcc_app/screens/listScreens/user_records.dart';
import '../../listScreens/entry_and_exit_list.dart';
import '../../../data/dummy_data.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  void _selectEntryRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EntryAndExitList(dummyStudentEntry);
      }),
    );
  }

  void _selectUserRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return UserRecords(dummyUser, null);
      }),
    );
  }

  void _selectStudentRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return StudentList();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Aplicativo Meprovi',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 40),
              ),
            ),
            ListTile(title: const Text('Home'), onTap: () {}),
            ListTile(
              title: Text('Educandos'),
              onTap: () => _selectStudentRecords(context),
            ),
            ListTile(
              title: const Text('Educadores'),
              onTap: () => _selectUserRecords(context),
            ),
            ListTile(
              title: const Text('Entradas e Saidas'),
              onTap: () => _selectEntryRecords(context),
            ),
            ListTile(
              title: const Text('Advertencias'),
              onTap: () {},
            ),
            // ListTile(
            //   title: const Text('QRCode'),
            //   onTap: () {},
            // ),
            ListTile(
              title: const Text('Sair'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
