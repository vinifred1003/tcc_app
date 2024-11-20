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
final User u0 = User(id:dummyUser[0].id,username:dummyUser[0].username,password: dummyUser[0].password,email:dummyUser[0].email ,jobPosition: dummyUser[0].jobPosition );
void _selectHome(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return HomeScreen(user: u0);
    }),
  );
}

void _selectRegister(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) {
      return ManagerSignupForm();
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
