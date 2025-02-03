import 'package:flutter/material.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/user.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/user_role.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  late TextEditingController _cpfController = TextEditingController();

  late DateTime _selectedDate;
  late Occupation? _selectedOccupation;
  late UserRole? _selectedRole;
  List<Occupation> occupations = [];
  bool _isLoading = true;

  List<UserRole> userRoles = [
    UserRole(id: UserRolesEnum.admin, name: 'Administrador'),
    UserRole(id: UserRolesEnum.employee, name: 'Funcionário'),
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.employee;

    _nameController = TextEditingController(text: e.name);
    _emailController = TextEditingController(text: e.user?.email ?? "");
    _passwordController = TextEditingController(text: e.user?.password ?? "");
    _cpfController = TextEditingController(text: e.cpf ?? "");

    _selectedDate = e.admissionDate;
    _selectedOccupation = e.occupation;
    _selectedRole = e.user?.role ?? userRoles[1];

    _fetchOccupations();
  }

  Future<void> _fetchOccupations() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/employee/occupation'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        occupations = data.map((json) => Occupation.fromJson(json)).toList();
        _isLoading = false;

        // Ensure _selectedOccupation is in the list of occupations
        if (!occupations
            .any((occupation) => occupation.id == _selectedOccupation?.id)) {
          _selectedOccupation = null;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar cargos.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final u = widget.employee.user;

      final employeeEdited = Employee(
          id: widget.employee.id,
          name: _nameController.text,
          admissionDate: _selectedDate,
          occupationId: _selectedOccupation!.id,
          cpf: _cpfController.text);


      final userEdited = User(
        id: widget.employee.user?.id ?? 1,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,

        roleId: _selectedRole!.id,
        updatedAt: DateTime.now(),
        role: _selectedRole!,
      );

      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/employee/${widget.employee.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': employeeEdited.name,
          'occupationId': employeeEdited.occupationId,
          'admissionDate': employeeEdited.admissionDate.toIso8601String(),
          'cpf': employeeEdited.cpf,
          'userId': userEdited.id,
          'user': {
            'id': userEdited.id,
            'name': userEdited.name,
            'email': userEdited.email,
            'roleId': userEdited.roleId.id,
          },
        }),
      );



      if (response.statusCode == 200) {
        Navigator.of(context).pop([userEdited, employeeEdited]);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcinário atualizado com sucesso.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar funcionário.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor preencha o campo do CPF';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<UserRole>(
                        value: userRoles
                                .any((role) => role.id == _selectedRole?.id)
                            ? userRoles.firstWhere(
                                (role) => role.id == _selectedRole?.id)
                            : null,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: userRoles.map((UserRole role) {
                          return DropdownMenuItem<UserRole>(
                            value: role,
                            child: Text(role.name),
                          );
                        }).toList(),
                        onChanged: (UserRole? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma opção';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Role'),
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
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<Occupation>(
                        value: occupations.any((occupation) =>
                                occupation.id == _selectedOccupation?.id)
                            ? occupations.firstWhere((occupation) =>
                                occupation.id == _selectedOccupation?.id)
                            : null,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: occupations.map((Occupation option) {
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
                    child: const Text('Enviar'),
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
    // _roleController.dispose();
    _cpfController.dispose();
    super.dispose();
  }
}
