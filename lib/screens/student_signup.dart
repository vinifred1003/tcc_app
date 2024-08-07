import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/student_signup/qrcode_generator.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  String? qrData;
  late final qrCodeGenerator;

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
        _controller.text = '${DateFormat('dd/MM/y').format(_selectedDate)}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Text("Dados do Educando"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        qrData = value;
                        qrCodeGenerator.generateQRCode();
                      });
                    },
                    decoration: const InputDecoration(
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: '',
                      labelText: 'Função',
                    ),
                  ),
                ),
                QRCodeGenerator(qrDataStudent: qrData),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: ElevatedButton(
                onPressed: () {},
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
