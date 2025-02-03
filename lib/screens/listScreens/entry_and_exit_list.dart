import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/models/student_entry.dart';
import 'package:tcc_app/models/student_exit.dart';
import '../components/global/app_drawer.dart';
import 'package:tcc_app/screens/editScreens/edit_entry.dart';
import 'package:tcc_app/screens/editScreens/edit_exit.dart';
import 'package:tcc_app/screens/formScreens/entry_and_exit_form.dart';

class EntryList extends StatefulWidget {
  const EntryList({Key? key}) : super(key: key);

  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  late List<StudentEntry> filteredStudentsEntrys = [];
  late List<StudentExit> filteredStudentsExit = [];
  final TextEditingController _searchControllerEntrys = TextEditingController();
  final TextEditingController _searchControllerExits = TextEditingController();
  final Map<String, Uint8List> _studentPhotosCache = {};
  List<dynamic> classes = [];
  String? selectedClass;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClasses();
    _searchControllerEntrys.addListener(_filterStudentsEntrys);
    _searchControllerExits.addListener(_filterStudentsExits);
  }

  Future<void> fetchClasses() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/class'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        classes = data;
        if (classes.isNotEmpty) {
          selectedClass = classes[0]['id'].toString();
          _fetchData();
        }
      });
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    final entryResponse = await http.get(Uri.parse(
        '${AppConfig.baseUrl}/students-attendance/entry?classId=$selectedClass'));
    final exitResponse = await http.get(Uri.parse(
        '${AppConfig.baseUrl}/students-attendance/exit?classId=$selectedClass'));

    if (entryResponse.statusCode == 200 && exitResponse.statusCode == 200) {
      final List<dynamic> entryJson = json.decode(entryResponse.body);
      final List<dynamic> exitJson = json.decode(exitResponse.body);

      setState(() {
        filteredStudentsEntrys =
            entryJson.map((json) => StudentEntry.fromJson(json)).toList();
        filteredStudentsExit =
            exitJson.map((json) => StudentExit.fromJson(json)).toList();
        isLoading = false;
      });

      await _fetchStudentPhotos();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados.')),
      );
    }
  }

  Future<void> _fetchStudentPhotos() async {
    final Set<String> studentIds = {};

    for (var entry in filteredStudentsEntrys) {
      if (entry.student?.photo != null && entry.student!.photo!.isNotEmpty) {
        studentIds.add(entry.student!.photo!);
      }
    }

    for (var exit in filteredStudentsExit) {
      if (exit.student?.photo != null && exit.student!.photo!.isNotEmpty) {
        studentIds.add(exit.student!.photo!);
      }
    }

    for (var photoId in studentIds) {
      if (!_studentPhotosCache.containsKey(photoId)) {
        final photoResponse =
            await http.get(Uri.parse('${AppConfig.baseUrl}/upload/$photoId'));
        if (photoResponse.statusCode == 200) {
          _studentPhotosCache[photoId] = photoResponse.bodyBytes;
        }
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    _searchControllerEntrys.dispose();
    _searchControllerExits.dispose();
    super.dispose();
  }

  void _filterStudentsEntrys() {
    setState(() {
      filteredStudentsEntrys = filteredStudentsEntrys
          .where((attendance) => attendance.student!.name
              .toLowerCase()
              .contains(_searchControllerEntrys.text.toLowerCase()))
          .toList();
    });
  }

  void _filterStudentsExits() {
    setState(() {
      filteredStudentsExit = filteredStudentsExit
          .where((attendance) => attendance.student!.name
              .toLowerCase()
              .contains(_searchControllerExits.text.toLowerCase()))
          .toList();
    });
  }

  void _selectEntryAndExitForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EntryAndExitForm();
      }),
    ).then((result) {
      _fetchData();
    });
  }

  Future<void> _deleteEntryOrExit(int id, bool isEntry) async {
    final url = isEntry
        ? '${AppConfig.baseUrl}/students-attendance/entry/$id'
        : '${AppConfig.baseUrl}/students-attendance/exit/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        if (isEntry) {
          filteredStudentsEntrys.removeWhere((entry) => entry.id == id);
        } else {
          filteredStudentsExit.removeWhere((exit) => exit.id == id);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro deletado com sucesso.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar registro.')),
      );
    }
  }

  void _confirmDelete(int id, bool isEntry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Deleção'),
        content: Text('Você tem certeza que deseja deletar este registro?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteEntryOrExit(id, isEntry);
            },
            child: Text('Deletar'),
          ),
        ],
      ),
    );
  }

  _editStudentEntry(StudentEntry entryChanged) {
    int index = filteredStudentsEntrys
        .indexWhere((entry) => entry.id == entryChanged.id);
    setState(() {
      filteredStudentsEntrys[index] = entryChanged;
    });
  }

  _openEditEntryForm(BuildContext context, studentEntrySelected) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditEntry(_editStudentEntry, studentEntrySelected);
      },
    );
  }

  _editStudentExit(StudentExit exitChanged) {
    int index =
        filteredStudentsExit.indexWhere((exit) => exit.id == exitChanged.id);
    setState(() {
      filteredStudentsExit[index] = exitChanged;
    });
  }

  _openEditExitForm(BuildContext context, studentExitSelected) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditExit(_editStudentExit, studentExitSelected);
      },
    );
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
          title: const Text("Registro de Entradas e Saídas"),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200, // Define the width of the dropdown
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButton<String>(
                  hint: const Text(
                    "Selecione a turma",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  value: selectedClass,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedClass = newValue;
                      _fetchData();
                    });
                  },
                  isExpanded: true,
                  underline: Container(),
                  items: classes
                      .map<DropdownMenuItem<String>>((dynamic classItem) {
                    return DropdownMenuItem<String>(
                      value: classItem['id'].toString(),
                      child: Text(
                        classItem['name'],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
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
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : entryIsEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Nenhuma Entrada',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
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
                                          leading: FutureBuilder<Widget>(
                                            future:
                                                fetchImage(tr.student?.photo),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return snapshot.data ??
                                                    const Icon(Icons.person);
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                          title: Text(
                                            tr.student?.name ?? 'Não informado',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          subtitle: Text(
                                            "Entrada: " +
                                                DateFormat('d MMM y HH:mm')
                                                    .format(tr.entryAt!),
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _openEditEntryForm(context, tr);
                                              } else if (value == 'delete') {
                                                _confirmDelete(tr.id, true);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Editar'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Deletar'),
                                              ),
                                            ],
                                            icon: const Icon(Icons.menu),
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
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : exitIsEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Nenhuma Saída',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
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
                                          leading: FutureBuilder<Widget>(
                                            future:
                                                fetchImage(tr.student?.photo),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return snapshot.data ??
                                                    const Icon(Icons.person);
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                          title: Text(
                                            tr.student?.name ?? 'Não informado',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          subtitle: Text(
                                            "Saída: " +
                                                DateFormat('d MMM y HH:mm')
                                                    .format(tr.exitAt!),
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _openEditExitForm(context, tr);
                                              } else if (value == 'delete') {
                                                _confirmDelete(tr.id, false);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Editar'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Deletar'),
                                              ),
                                            ],
                                            icon: const Icon(Icons.menu),
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: () => _selectEntryAndExitForm(context),
          child: Icon(color: Theme.of(context).colorScheme.primary, Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<Widget> fetchImage(String? photoFilename) async {
    if (photoFilename == null) {
      return const Icon(Icons.person);
    }

    if (_studentPhotosCache.containsKey(photoFilename)) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(_studentPhotosCache[photoFilename]!),
      );
    } else {
      return const Icon(Icons.person);
    }
  }
}
