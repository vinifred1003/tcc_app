import 'package:flutter/material.dart';
import '../../models/student_entry.dart';
import '../../models/student_exit.dart';
import 'package:intl/intl.dart';
import '../components/global/base_app_bar.dart';
import '../components/global/app_drawer.dart';
import '../components/entry_and_exit_list/entry_and_exit_list.dart';

class EntryList extends StatefulWidget {
  final List<StudentEntry> entrys;

  const EntryList(this.entrys, {Key? key}) : super(key: key);

  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  late List<StudentEntry> filteredStudents; // Filtered list of students
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStudents =
        widget.entrys; // Initialize filtered list with all students
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose(); // Clean up controller
    super.dispose();
  }

  void _filterStudents() {
    setState(() {
      filteredStudents = widget.entrys
          .where((attendance) => attendance.student.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = filteredStudents.isEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar:
          const BaseAppBar(screen_title: Text("Registros de Entrada e Saídas")),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
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
          EntryAndExitListComponent(filteredStudents)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () {},
        child: Icon(color: Theme.of(context).colorScheme.primary, Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
