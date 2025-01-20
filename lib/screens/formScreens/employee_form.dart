import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user_role.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:intl/intl.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late DateTime _selectedDate;

  Occupation? _selectedOccupation;

  UserRole? _selectedRole;

  final _formKey = GlobalKey<FormState>();
  final List<String> rolesName = dummyOccupations
      .map((occupation) => occupation.name)
      .toList()
      .cast<String>();

  final TextEditingController _controllerDate = TextEditingController();
  // Validator function
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1924),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _controllerDate.text = DateFormat('dd/MM/y').format(_selectedDate);
      });
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      

      final newUser = User(
        id: dummyUser.length + 1,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        roleId: _selectedRole?.id ?? UserRolesEnum.employee,
        role: _selectedRole ?? dummyUserRoles[1],
      );

      final newEmployee = Employee(
          id: dummyEmployee.length + 1,
          name: _nameController.text,
          admissionDate: _selectedDate,
          occupationId: _selectedOccupation!.id,
          user: newUser,
          occupation: _selectedOccupation);
          

      final List twoClassList = [newUser, newEmployee];

      Navigator.of(context).pop(twoClassList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;
    final double horizontalButton = MediaQuery.of(context).size.width * 0.25;
    final double screenHeight = MediaQuery.of(context).size.height * 0.05;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: BaseAppBar(screen_title: Text("Novo Usuário")),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.only(top: screenHeight),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {},
                          child: const Opacity(
                            opacity: 0.85,
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Image(
                                image:
                                    AssetImage('assets/images/foto_perfil.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    validator: validateField,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'Nome Completo',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    validator: validateField,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: DropdownButtonFormField<Occupation>(
                    decoration: InputDecoration(
                      labelText: "Selecione o Cargo:",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: DropdownButtonFormField<UserRole>(
                    decoration: InputDecoration(
                      labelText: "Selecione o tipo de Usuário: ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _selectedRole,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: dummyUserRoles.map((UserRole option) {
                      return DropdownMenuItem<UserRole>(
                        value: option,
                        child: Text(option.name),
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    controller: _controllerDate,
                    validator: validateField,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        labelText: 'Data de Admissão: ',
                        suffixIcon: IconButton(
                            onPressed: _showDatePicker,
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 30,
                            ))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    validator: validateField,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'Senha',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalButton, vertical: verticalPadding),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        _submitForm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).textTheme.labelLarge?.color,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(50, 75),
                    ),
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
