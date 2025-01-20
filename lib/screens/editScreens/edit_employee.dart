import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/user.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/user_role.dart';

class EditEmployee extends StatefulWidget {
  final Employee employee;
  const EditEmployee(this.employee, {super.key});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final _formKey = GlobalKey<FormState>();
  // Controllers for input fields
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _roleController = TextEditingController();

  late DateTime _selectedDate; 

  late Occupation? _selectedOccupation;

  void initState() {
    super.initState();
    final e = widget.employee;

    _nameController = TextEditingController(text: e.name);
    _emailController =
        TextEditingController(text: e.user?.email ?? "Não informado");
    _passwordController =
        TextEditingController(text: e.user?.password ?? "Não informado");
    _roleController =
        TextEditingController(text: e.user?.role.name ?? "Não informado");

    _selectedDate = e.admissionDate;

    _selectedOccupation = e.occupation;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final u = widget.employee.user;

      

      final userEdited = User(
        id: widget.employee.user?.id ?? 1,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        roleId: u?.roleId ?? UserRolesEnum.employee,
        updatedAt: DateTime.now(),
        role: u?.role ?? dummyUserRoles[1],
      );
      final employeeEdited = Employee(
          id: widget.employee.id,
          name: _nameController.text,
          admissionDate: _selectedDate,
          occupationId: _selectedOccupation!.id,
          user: userEdited,
          occupation: _selectedOccupation);
      final List twoClassList = [userEdited, employeeEdited];

      Navigator.of(context).pop(twoClassList);
    }
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor preencha o campo do Nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor preencha o campo do Email';
                    } 
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor preencha o campo da Senha';
                    } else if (value.length < 6) {
                      return 'Senha deve ter pelo menos 6 caracteres';
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
                          'Data de admissão: ${DateFormat('dd/MM/y').format(_selectedDate)}',
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
                DropdownButtonFormField<Occupation>(
                  value: _selectedOccupation,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: dummyOccupations.map((Occupation option) {
                    return DropdownMenuItem<Occupation>(
                      value: option,
                      child: Text(option.name),
                    );
                  }).toList(),
                  onChanged: (Occupation? newValue) {
                    setState(() {
                      _selectedOccupation = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione uma opção';
                    }
                    return null;
                  },
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }
}
