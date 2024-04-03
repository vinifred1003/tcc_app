import 'package:flutter/material.dart';
import '../../screens/entry_record.dart';
import '../../data/dummy_data.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  void _selectEntryRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EntryRecord(dummyStudentEntry);
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
                color: Colors.blue,
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
              onTap: () => _selectEntryRecords(context),
            ),
            ListTile(
              title: const Text('Educadores'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Entradas e Saidas'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Advertencias'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('QRCode'),
              onTap: () {},
            ),
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
