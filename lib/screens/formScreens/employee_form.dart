import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/config.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user_role.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:tcc_app/utils/validations.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  late DateTime _selectedDate;
  Occupation? _selectedOccupation;
  UserRole? _selectedRole;
  List<Occupation> occupations = [];
  List<UserRole> userRoles = [
    UserRole(id: UserRolesEnum.admin, name: 'Administrador'),
    UserRole(id: UserRolesEnum.employee, name: 'Funcionário'),
  ];

  final _formKey = GlobalKey<FormState>();
  String? _photoFilename;
  Uint8List? _imageData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOccupations();
  }

  Future<void> _fetchOccupations() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/employee/occupation'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        occupations = data.map((json) => Occupation.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar cargos.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}/upload/image'),
      );
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
        contentType: MediaType(
          'image',
          'jpeg',
        ),
      ));
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        setState(() {
          _photoFilename = data['filename'];
          _imageData = bytes;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao fazer upload da foto.')),
        );
      }
    }
  }

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });

      final newEmployee = Employee(
        id: 0,
        name: _nameController.text,
        admissionDate: _selectedDate,
        occupationId: _selectedOccupation!.id,
        cpf: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      final newUser = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        roleId: _selectedRole?.id ?? UserRolesEnum.employee,
        role: _selectedRole ?? userRoles[1],
      );

      final url = Uri.parse('${AppConfig.baseUrl}/employee');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': newEmployee.name,
          'admissionDate': newEmployee.admissionDate.toIso8601String(),
          'occupationId': newEmployee.occupationId,
          'photo': _photoFilename,
          'cpf': newEmployee.cpf,
          'user': {
            'name': newUser.name,
            'email': newUser.email,
            'password': newUser.password,
            'roleId': newUser.roleId.id,
          },
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcionário cadastrado com sucesso.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar funcionário.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) => Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Tirar foto'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Adicionar foto'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey[300],
                            ),
                            child: _imageData == null
                                ? const Icon(Icons.camera_alt,
                                    size: 50, color: Colors.grey)
                                : Image.memory(_imageData!, fit: BoxFit.cover),
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
                    controller: _nameController,
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
                    controller: _emailController,
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
                  child: TextFormField(
                    controller: _cpfController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (!isValidCPF(value)) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text;
                        if (text.length > 11) return oldValue;
                        String newText = '';
                        for (int i = 0; i < text.length; i++) {
                          if (i == 3 || i == 6) newText += '.';
                          if (i == 9) newText += '-';
                          newText += text[i];
                        }
                        return newValue.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }),
                    ],
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'CPF',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: DropdownButtonFormField<Occupation>(
                    decoration: InputDecoration(
                      labelText: "Cargo:",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _selectedOccupation,
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: DropdownButtonFormField<UserRole>(
                    decoration: InputDecoration(
                      labelText: "Tipo de Usuário: ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _selectedRole,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: userRoles.map((UserRole option) {
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
                    controller: _passwordController,
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
                        setState(() {
                          _isLoading = true;
                        });

                        _submitForm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).textTheme.labelLarge?.color,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(50, 75),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary),
                          )
                        : const Text(
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
