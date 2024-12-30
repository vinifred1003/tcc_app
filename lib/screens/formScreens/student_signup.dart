import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:tcc_app/screens/formScreens/guardian_form.dart';
import '../components/student_signup/qrcode_generator.dart';
import 'package:http_parser/http_parser.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  String? qrData;
  late final qrCodeGenerator;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _classIdController = TextEditingController();
  String? _photoFilename;
  Uint8List? _imageData;
  DateTime _selectedDate = DateTime.now();
  final List<Map<String, dynamic>> _guardians = [];
  List<int> _classIds = [];
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    qrCodeGenerator = QRCodeGenerator(qrDataStudent: qrData);
    _fetchClassIds();
    if (_photoFilename != null) {
      _fetchImage();
    }
  }

  Future<void> _fetchClassIds() async {
    final response =
        await http.get(Uri.parse('http://172.31.38.224:3070/class'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _classIds = data.map((item) => item['id'] as int).toList();
      });
    } else {
      throw Exception('Failed to load class IDs');
    }
  }

  Future<void> _fetchImage() async {
    if (_photoFilename == null) return;

    final response = await http
        .get(Uri.parse('http://172.31.38.224:3070/upload/$_photoFilename'));
    if (response.statusCode == 200) {
      setState(() {
        _imageData = response.bodyBytes;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao carregar a imagem.')),
      );
    }
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
        _birthDateController.text =
            DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.31.38.224:3070/upload/image'),
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
          _fetchImage();
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

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      if (date.isAfter(DateTime.now())) {
        return 'Data não pode ser no futuro';
      }
    } catch (e) {
      return 'Data inválida';
    }
    return null;
  }

  void _addGuardian(Map<String, dynamic> guardian) {
    setState(() {
      _guardians.add(guardian);
    });
  }

  void _editGuardian(int index, Map<String, dynamic> guardian) {
    setState(() {
      _guardians[index] = guardian;
    });
  }

  void _removeGuardian(int index) {
    setState(() {
      _guardians.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    final DateTime birthDate =
        DateFormat('dd/MM/yyyy').parseStrict(_birthDateController.text);
    final String birthDateIso = DateFormat('yyyy-MM-dd').format(birthDate);

    final Map<String, dynamic> studentData = {
      'name': _nameController.text,
      'registrationNumber': _registrationNumberController.text,
      'birthDate': birthDateIso,
      'classId': int.parse(_classIdController.text),
      'photo': _photoFilename,
      'guardians': _guardians,
    };

    final response = await http.post(
      Uri.parse('http://172.31.38.224:3070/student'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(studentData),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudante cadastrado com sucesso!')),
      );
      Navigator.pop(context); // Return to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao cadastrar estudante.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;
    final double horizontalButton = MediaQuery.of(context).size.width * 0.25;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Registrar Estudante")),
      drawer: AppDrawer(),
      body: Form(
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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    controller: _nameController,
                    validator: validateField,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'Nome Completo',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    controller: _registrationNumberController,
                    validator: validateField,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'N° Matricula',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    controller: _birthDateController,
                    validator: validateDate,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text;
                        if (text.length > 10) return oldValue;
                        String newText = '';
                        for (int i = 0; i < text.length; i++) {
                          if (i == 2 || i == 4) newText += '/';
                          newText += text[i];
                        }
                        return newValue.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        labelText: 'Data de Nascimento',
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
                  child: DropdownButtonFormField<int>(
                    value: null,
                    onChanged: (int? newValue) {
                      setState(() {
                        _classIdController.text = newValue.toString();
                      });
                    },
                    items: _classIds.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('Classe $value'),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'Turma',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          expansionTileTheme: const ExpansionTileThemeData(
                            backgroundColor: Colors.white,
                            collapsedBackgroundColor: Colors.white,
                          ),
                        ),
                        child: ExpansionTile(
                          title: const Text('Responsáveis'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: GuardianForm(
                                          onSave: (guardian) {
                                            _addGuardian(guardian);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                            ],
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() => _isExpanded = expanded);
                          },
                          children: _guardians.map((guardian) {
                            int index = _guardians.indexOf(guardian);
                            return ListTile(
                              title: Text(guardian['name']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: GuardianForm(
                                              initialData: guardian,
                                              onSave: (editedGuardian) {
                                                _editGuardian(
                                                    index, editedGuardian);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _removeGuardian(index);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalButton, vertical: verticalPadding),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_photoFilename == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adicione uma foto.')),
                      );
                      return;
                    }
                    if (_classIdController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecione uma turma.')),
                      );
                      return;
                    }
                    if (_guardians.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Adicione ao menos um responsável.')),
                      );
                      return;
                    }
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
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Cadastrar",
                        style: TextStyle(fontSize: 25),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
