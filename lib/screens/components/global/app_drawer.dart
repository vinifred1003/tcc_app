import 'package:flutter/material.dart';
import 'package:tcc_app/screens/home_screen.dart';
import 'package:tcc_app/screens/listScreens/student_list.dart';
import 'package:tcc_app/screens/listScreens/user_records.dart';
import 'package:tcc_app/screens/listScreens/warning_list.dart';
import '../../listScreens/entry_and_exit_list.dart';
import '../../../data/dummy_data.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _selectEntryRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EntryList(dummyStudentEntry, dummyExits);
      }),
    );
  }

  void _selectUserRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return UserRecords(dummyUser);
      }),
    );
  }

  void _selectStudentRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return const StudentList();
      }),
    );
  }
  void _selectWarningRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return WarningList(dummyWarnings);
      }),
    );
  }
  void _selectHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return HomeScreen(user: dummyUser[0]);
      }),
    );
  }

  void _selectLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // Replace with your login route name
      (Route<dynamic> route) => false, // This will remove all routes
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
            ListTile(
                title: const Text('Home'), onTap: () => _selectHome(context)),
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
              onTap: () => _selectWarningRecords(context),
            ),
            // ListTile(
            //   title: const Text('QRCode'),
            //   onTap: () {},
            // ),
            ListTile(
              title: const Text('Sair'),
              onTap: () => _selectLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
