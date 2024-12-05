import 'package:flutter/material.dart';
import 'package:tcc_app/screens/components/login/footer_buttons.dart';
import 'package:tcc_app/screens/formScreens/manager_signup_form.dart';
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

final User u0 = dummyUser[0];
void _selectHome(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return HomeScreen(user: u0);
    }),
  );
}

void rememberLoginAndPassword(bool? value) {
  setState(() {
    isChecked = value ?? false;
  });
}

void _selectRegister(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return ManagerSignupForm();
    }),
  );
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}
