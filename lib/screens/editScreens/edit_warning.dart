import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_warning.dart';

class EditWarning extends StatefulWidget {
  final void Function(StudentWarning) onSubmit;
  final StudentWarning studentWarning;
  const EditWarning(this.onSubmit, this.studentWarning, {Key? key})
      : super(key: key);

  @override
  State<EditWarning> createState() => _EditWarningState();
}

class _EditWarningState extends State<EditWarning> {
  final _formKey = GlobalKey<FormState>();
  List<Student> students = [];
  List<Employee> employees = [];
  Employee? _selectedEmployee;
  Student? _selectedStudent;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.studentWarning.reason);
    _selectedDate = widget.studentWarning.issuedAt;
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchStudents(), _fetchEmployees()]);
    setState(() {
      _selectedEmployee = employees.firstWhere(
          (employee) => employee.id == widget.studentWarning.issuedBy);
      _selectedStudent = students.firstWhere(
          (student) => student.id == widget.studentWarning.studentId);
    });
  }

  Future<void> _fetchStudents() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/student'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        students = data.map((json) => Student.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar estudantes.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchEmployees() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/employee'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        employees = data.map((json) => Employee.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar funcionários.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final StudentWarning newStudentWarning = StudentWarning(
        id: widget.studentWarning.id,
        studentId: _selectedStudent!.id,
        issuedBy: _selectedEmployee!.id,
        issuedAt: _selectedDate,
        reason: _descriptionController.text,
        severity: "Grave",
        createdAt: widget.studentWarning.createdAt,
        updatedAt: DateTime.now(),
        student: _selectedStudent!,
        issuedByEmployee: _selectedEmployee!,
      );

      final url = Uri.parse(
          '${AppConfig.baseUrl}/students-warning/${widget.studentWarning.id}');
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'issuedBy': _selectedEmployee!.id,
          'issuedAt': _selectedDate.toIso8601String(),
          'reason': _descriptionController.text,
          'studentId': _selectedStudent!.id,
        }),
      );

      if (response.statusCode == 200) {
        widget.onSubmit(newStudentWarning);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Advertência atualizada com sucesso.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData.containsKey('message')
            ? responseData['message']
            : 'Erro ao atualizar advertência.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Advertência'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _selectedEmployee == null || _selectedStudent == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField<Employee>(
                        decoration: const InputDecoration(
                          labelText: 'Emissor da Ocorrência',
                        ),
                        value: _selectedEmployee,
                        items: employees.map((Employee employee) {
                          return DropdownMenuItem<Employee>(
                            value: employee,
                            child: Text(employee.name),
                          );
                        }).toList(),
                        onChanged: (Employee? newValue) {
                          setState(() {
                            _selectedEmployee = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um emissor';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}',
                              ),
                            ),
                            TextButton(
                              onPressed: _showDatePicker,
                              child: Text(
                                'Selecionar Data',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      DropdownButtonFormField<Student>(
                        decoration: const InputDecoration(
                          labelText: 'Nome do Estudante',
                        ),
                        value: _selectedStudent,
                        items: students.map((Student student) {
                          return DropdownMenuItem<Student>(
                            value: student,
                            child: Text(student.name),
                          );
                        }).toList(),
                        onChanged: (Student? newValue) {
                          setState(() {
                            _selectedStudent = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um estudante';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).textTheme.labelLarge?.color,
                            ),
                            child: const Text('Enviar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
