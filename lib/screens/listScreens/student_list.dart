import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:tcc_app/screens/formScreens/student_signup.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  String? selectedClass;
  List<Student> students = [];
  List<Student> filteredStudents = [];
  List<dynamic> classes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    final response =
        await http.get(Uri.parse('http://172.31.38.224:3070/class'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        classes = data;
        if (classes.isNotEmpty) {
          selectedClass = classes[0]['id'].toString();
          fetchStudents(selectedClass);
        }
      });
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<void> fetchStudents(String? classId) async {
    final response = await http
        .get(Uri.parse('http://172.31.38.224:3070/student?classId=$classId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        students = data.map((json) => Student.fromJson(json)).toList();
        filteredStudents = students;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load students');
    }
  }

  void _filterStudentsByClass(String? classId) {
    setState(() {
      selectedClass = classId;
      isLoading = true;
    });
    fetchStudents(classId);
  }

  Future<Widget> fetchImage(String? photoFilename) async {
    if (photoFilename == null) {
      return const Icon(Icons.person);
    }

    final response = await http
        .get(Uri.parse('http://172.31.38.224:3070/upload/$photoFilename'));
    if (response.statusCode == 200) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(response.bodyBytes),
      );
    } else {
      return const Icon(Icons.person);
    }
  }

  Future<void> _deleteStudent(Student student) async {
    final response = await http.delete(
      Uri.parse('http://172.31.38.224:3070/student/${student.id}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        students.remove(student);
        filteredStudents.remove(student);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Estudante ${student.name} deletado com sucesso.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro ao deletar estudante: ${response.reasonPhrase}')),
      );
    }
  }

  void _showDeleteConfirmationDialog(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content:
            Text('Você realmente deseja excluir o estudante ${student.name}?'),
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
              _deleteStudent(student);
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Lista de Estudantes")),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                      hint: const Text("Selecione a turma",
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      value: selectedClass,
                      onChanged: (String? newValue) {
                        _filterStudentsByClass(newValue);
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
                  child: filteredStudents.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 50.0),
                            child: Text(
                              "Nenhum estudante cadastrado para a empresa em questão",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (ctx, index) {
                            final student = filteredStudents[index];
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 5,
                              ),
                              child: ListTile(
                                leading: FutureBuilder<Widget>(
                                  future: fetchImage(student.photo),
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
                                  student.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Text(student.registrationNumber),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudentSignup(
                                              studentId: student.id,
                                            ),
                                          ),
                                        ).then((_) {
                                          fetchStudents(selectedClass);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(student);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentSignup()),
          ).then((_) {
            fetchStudents(selectedClass);
          });
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
