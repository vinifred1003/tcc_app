import 'package:flutter/material.dart';
import '../../models/student_entry.dart';
import '../../models/student_exit.dart';
import 'package:intl/intl.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import '../components/entry_and_exit_list/entry_and_exit_list.dart';

class EntryList extends StatefulWidget {
  final List<StudentEntry> entrys;
  final List<StudentExit> exits;

  const EntryList(this.entrys, this.exits, {Key? key}) : super(key: key);

  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  late List<StudentEntry> filteredStudentsEntrys; // Filtered list of students
  late List<StudentExit> filteredStudentsExit; // Filtered list of students
  final TextEditingController _searchControllerEntrys = TextEditingController();
  final TextEditingController _searchControllerExits = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStudentsEntrys =
        widget.entrys; // Initialize filtered list with all students
    _searchControllerEntrys.addListener(_filterStudentsEntrys);
    filteredStudentsExit =
        widget.exits; // Initialize filtered list with all students
    _searchControllerExits.addListener(_filterStudentsExits);
  }

  @override
  void dispose() {
    _searchControllerEntrys.dispose(); // Clean up controller
    _searchControllerExits.dispose(); // Clean up controller
    super.dispose();
  }

  void _filterStudentsEntrys() {
    setState(() {
      filteredStudentsEntrys = widget.entrys
          .where((attendance) => attendance.student.name
              .toLowerCase()
              .contains(_searchControllerEntrys.text.toLowerCase()))
          .toList();
    });
  }

  void _filterStudentsExits() {
    setState(() {
      filteredStudentsExit = widget.exits
          .where((attendance) => attendance.student.name
              .toLowerCase()
              .contains(_searchControllerExits.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool entryIsEmpty = filteredStudentsEntrys.isEmpty;
    bool exitIsEmpty = filteredStudentsExit.isEmpty;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          title: const Text("Registro de Entradas e Saidas"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.door_front_door_outlined,
                    color: Theme.of(context).colorScheme.inversePrimary),
                child: Text(
                  "Entrada",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              Tab(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                child: Text(
                  "Saida",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchControllerEntrys,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Buscar...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                entryIsEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Nenhuma Saida ou Entrada',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredStudentsEntrys.length,
                          itemBuilder: (ctx, index) {
                            final tr = filteredStudentsEntrys[index];
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
                                  tr.student.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Text(
                                  "Entrada " +
                                      DateFormat('d MMM y')
                                          .format(tr.createdAt),
                                ),
                              ),
                            );
                          },
                        ),
                      )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchControllerExits,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Buscar...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                exitIsEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Nenhuma Saida ou Entrada',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredStudentsExit.length,
                          itemBuilder: (ctx, index) {
                            final tr = filteredStudentsExit[index];
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
                                  tr.student.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Text(
                                  "Saída " +
                                      DateFormat('d MMM y')
                                          .format(tr.createdAt),
                                ),
                              ),
                            );
                          },
                        ),
                      )
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: () {},
          child: Icon(color: Theme.of(context).colorScheme.primary, Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
