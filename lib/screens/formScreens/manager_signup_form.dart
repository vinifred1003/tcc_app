import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:intl/intl.dart';

class ManagerSignupForm extends StatefulWidget {
  const ManagerSignupForm({super.key});

  @override
  State<ManagerSignupForm> createState() => _ManagerSignupFormState();
}

class _ManagerSignupFormState extends State<ManagerSignupForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> rolesName = dummyOccupations
      .map((occupation) => occupation.name)
      .toList()
      .cast<String>();
  String? _selectedOption;    
final TextEditingController _controllerDate = TextEditingController();
  DateTime _selectedDate = DateTime.now();
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

    // void _submitForm() {
    //   if (_formKey.currentState!.validate()) {
    //     final u = widget.employee.user;

    //     final employeeEdited = Employee(
    //         id: widget.employee.id,
    //         name: _nameController.text,
    //         admissionDate: _selectedDate,
    //         occupationId: _selectedOccupation!.id);

    //     final userEdited = User(
    //       id: widget.employee.user!.id,
    //       name: _nameController.text,
    //       email: _emailController.text,
    //       password: _passwordController.text,
    //       roleId: u!.roleId,
    //       createdAt: u.createdAt,
    //       updatedAt: DateTime.now(),
    //       role: u.role,
    //     );
    //     final List twoClassList = [userEdited, employeeEdited];

    //     Navigator.of(context).pop(twoClassList);
    //   }
    // }
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
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Selecione o Cargo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _selectedOption,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: rolesName.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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
                        labelText: 'Data do Ocorrido',
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
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    validator: validateField,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'Confirmar senha',
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
