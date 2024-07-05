import 'package:flutter/material.dart';
import 'package:tcc_app/components/login/footer_buttons.dart';
import 'package:tcc_app/screens/manager_signup.dart';
import '../components/global/base_app_bar.dart';
import '../components/login/inputs.dart';
import '../components/login/center_buttons.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

void _selectHome(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return HomeScreen();
    }),
  );
}

void _selectRegister(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return ManagerSignup();
    }),
  );
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const BaseAppBar(screen_title: Text("Bem vindo")),
      body: SizedBox(
        height: 1000,
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
            Inputs(),
            CenterButtons(
              selectedHome: () => _selectHome(context),
            ),
            FooterButtons(
              selectedRegister: () => _selectRegister(context),
            ),
          ],
        ),
      ),
    );
  }
}
