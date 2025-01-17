import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/student.dart';

import 'package:tcc_app/models/student_warning.dart';

class EditWarning extends StatefulWidget {
  final void Function(StudentWarning) onSubmit;
  final StudentWarning studentWarnig;
  const EditWarning(this.onSubmit, this.studentWarnig, {Key? key})
      : super(key: key);

  @override
  State<EditWarning> createState() => _EditWarningState();
}

class _EditWarningState extends State<EditWarning> {
  late TextEditingController _issuedByController;
  late TextEditingController _rNController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com o valor recebido
    _issuedByController = TextEditingController(
        text: widget.studentWarnig.issuedByEmployee?.name ?? '');
    _rNController = TextEditingController(
        text: widget.studentWarnig.student.registrationNumber);
    _descriptionController =
        TextEditingController(text: widget.studentWarnig.reason);

    _selectedDate = DateTime(
      widget.studentWarnig.issuedAt.year,
      widget.studentWarnig.issuedAt.month,
      widget.studentWarnig.issuedAt.day,
    );
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  _submitForm() {
    final registrationNumber = _rNController.text;
    final name = _issuedByController.text;
    final description = _descriptionController.text;
    Student? student;
    Employee? employee;
    if (registrationNumber.isEmpty || name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma informação pode ficar vazia.')),
      );
      return;
    }
    try {
      employee = dummyEmployee.firstWhere(
        (employee) => employee.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      employee = null;
    }
    if (employee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome do emissor está errado.')),
      );
      return;
    }

    try {
      student = dummyStudents.firstWhere(
        (student) => student.registrationNumber == registrationNumber,
      );
    } catch (e) {
      student = null;
    }
    if (student == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A matricula do educando está errada.')),
      );
      return;
    }

    final StudentWarning newStudentWarning = StudentWarning(
        id: widget.studentWarnig.id,
        studentId: student.id,
        issuedBy: employee.id,
        issuedAt: _selectedDate,
        reason: description,
        severity: "Grave",
        createdAt: widget.studentWarnig.createdAt,
        updatedAt: DateTime.now(),
        student: student,
        issuedByEmployee: employee);

    widget.onSubmit(newStudentWarning);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          // Add bottom padding when keyboard appears
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _issuedByController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelText: 'Nome Completo de quem Registrou',
                ),
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
              TextField(
                controller: _rNController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelText: 'N° Matricula',
                ),
              ),
              TextField(
                controller: _descriptionController,
                onSubmitted: (_) => _submitForm(),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
    );
  }
}
