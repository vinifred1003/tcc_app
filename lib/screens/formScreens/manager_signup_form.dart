import 'package:flutter/material.dart';

class ManagerSignupForm extends StatefulWidget {
  const ManagerSignupForm({super.key});

  @override
  State<ManagerSignupForm> createState() => _ManagerSignupFormState();
}

class _ManagerSignupFormState extends State<ManagerSignupForm> {

  final _formKey = GlobalKey<FormState>();

    // Validator function
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
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
        appBar: AppBar(
          title: const Text("Novo Registro"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
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
