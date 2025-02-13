import 'package:flutter/material.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/screens/formScreens/employee_form.dart';
import 'components/global/base_app_bar.dart';
import 'components/login/inputs.dart';
import 'components/login/center_buttons.dart';
import 'home_screen.dart';
import '../models/user.dart';
import '../data/dummy_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool isChecked = false;

final Employee e0 = dummyEmployee[0];
void _selectHome(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return HomeScreen(employee: e0);
    }),
  );
}

void rememberLoginAndPassword(bool? value) {
  // setState(() {
  //   isChecked = value ?? false;
  // });
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;

  void rememberLoginAndPassword(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const BaseAppBar(screen_title: Text("Bem vindo")),
        body: SizedBox(
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 200,
                  width: 350,
                  child: Image(
                    image: AssetImage(
                      'assets/images/convivencia.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Inputs(
                  checkboxFunction: rememberLoginAndPassword,
                  isChecked: isChecked,
                ),
                CenterButtons(
                  selectedHome: () => _selectHome(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
