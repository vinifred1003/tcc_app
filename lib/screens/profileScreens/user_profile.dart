import 'package:flutter/material.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:tcc_app/screens/components/home/profile_display.dart';

class UserProfile extends StatelessWidget {
  final User user;
  const UserProfile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.09;

    final double horizontalPaddingText =
        MediaQuery.of(context).size.width * 0.1;
    final double verticalPaddingText =
        MediaQuery.of(context).size.height * 0.02;
    return SafeArea(
      child: Scaffold(
        appBar: BaseAppBar(screen_title: Text("Perfil")),
        drawer: AppDrawer(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: ProfileDisplay(
                    name: user.name, classOrInstitution: user.role.name),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPaddingText),
              child: SizedBox(
                width: 500,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPaddingText),
                  child: Text(
                    'Email: ${user.email}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPaddingText),
                  child: SizedBox(
                    width: 200,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingText),
                      child: Text(
                        'Senha: ${user.password}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPaddingText),
                  child: SizedBox(
                    width: 200,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingText),
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}
