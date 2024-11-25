import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import '../components/student_signup/qrcode_generator.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  String? qrData;
  late final qrCodeGenerator;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    qrCodeGenerator = QRCodeGenerator(qrDataStudent: qrData);
  }

  // late QrCode qrCode;

  // void initState() async {
  //   super.initState();
  //   qrCode = QrCode.fromData(
  //     data: qrData ?? '',
  //     errorCorrectLevel: QrErrorCorrectLevel.H,
  //   );
  //   final qrImage = QrImage(qrCode);
  //   final pngQrImage = await qrImage.toImageAsBytes(
  //     size: 600,
  //     decoration: const PrettyQrDecoration(),
  //   );
  //   PrettyQrView.data(
  //     data: qrData!,
  //   );
  // }

  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();
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
        _controller.text = DateFormat('dd/MM/y').format(_selectedDate);
      });
    });
  }
  String? validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'Campo obrigatório';
      }
      return null;
    }

final TextEditingController _guardiansController = TextEditingController();
  final List<String> _items = []; // The array to store user inputs

  void _addItem() {
    if (_guardiansController.text.isNotEmpty) {
      setState(() {
        _items.add(_guardiansController.text); // Add the input to the array
        _guardiansController.clear(); // Clear the input field
      });
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
                      onTap: () {},
                      child: const Opacity(
                        opacity: 0.85,
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image(
                            image: AssetImage('assets/images/foto_perfil.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                    validator:validateField,
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
                  child: const TextField(
                    // onSubmitted: (value) {
                    //   setState(() {
                    //     qrData = value;
                    //     qrCodeGenerator.generateQRCode();
                    //   });
                    // },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'N° Matricula',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: TextFormField(
                    validator:validateField,
                    controller: _controller,
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
                  child: TextFormField(
                    validator:validateField,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'Turma',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _guardiansController,
                    decoration: const InputDecoration(
                                labelText: 'Enter a value',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addItem,
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Exibir a lista de itens
                      ListView.builder(
                        shrinkWrap:
                            true, // Permite que a ListView ocupe apenas o espaço necessário
                        physics:
                            const NeverScrollableScrollPhysics(), // Desabilita o scroll
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_items[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _items.removeAt(
                                      index); // Remove o item da lista
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(
                  horizontal: horizontalButton, vertical: verticalPadding),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).textTheme.labelLarge?.color,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(50, 75),
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
    );
  }
}
