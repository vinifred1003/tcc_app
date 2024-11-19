import 'package:flutter/material.dart';
import '../../models/student_entry.dart';
import 'package:intl/intl.dart';
import '../../components/global/base_app_bar.dart';
import '../../components/global/app_drawer.dart';

class EntryRecord extends StatefulWidget {
  final List<StudentEntry> students;
  const EntryRecord(this.students, {Key? key}) : super(key: key);

  @override
  State<EntryRecord> createState() => _EntryRecordState();
}

class _EntryRecordState extends State<EntryRecord> {
  late List<StudentEntry> filteredStudents; // Filtered list of students
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStudents = widget.students; // Initialize filtered list with all students
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose(); // Clean up controller
    super.dispose();
  }

  void _filterStudents() {
    setState(() {
      filteredStudents = widget.students
          .where((student) => student.name
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
      appBar: const BaseAppBar(screen_title: Text("Registros de Entrada e Saídas")),
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
          isEmpty
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
                    itemCount: filteredStudents.length,
                    itemBuilder: (ctx, index) {
                      final tr = filteredStudents[index];
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
