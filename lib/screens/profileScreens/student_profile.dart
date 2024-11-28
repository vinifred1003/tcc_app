import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/screens/components/home/profile_display.dart';
import '../components/global/app_drawer.dart';
import '../components/global/base_app_bar.dart';

class StudentProfile extends StatelessWidget {
  /*final Student student;*/
  StudentProfile(/*this.student,*/ {super.key});
  final matricula = "2022154865";
  final dataNascimento = "10/03/2018";
  final photo = File(
      "C:/Users/needd/OneDrive/Desktop/Programacao/TCC_APP/tcc_app/lib/data/images/boy.jpg");
  final guardians = ["Luciana", "Seu Zé", "Maria Teresa"];
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const BaseAppBar(screen_title: Text("Student")),
        drawer: AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: ProfileDisplay(
                    name: "Joãozinho", classOrInstitution: "Borboleta"),
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
                    'Matricula: ${matricula}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
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
                    'Data de Nascimento: ${dataNascimento}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPaddingText),
                child: Container(
                  decoration: BoxDecoration(),
                  width: 500,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPaddingText),
                    child: ListView.builder(
                        itemCount: guardians.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              onTap: () {},
                              textColor:
                                  Theme.of(context).colorScheme.secondary,
                              tileColor: Colors.white,
                              title: Text(
                                guardians[index],
                              ),
                            ),
                          );
                          
                        }),
                  ),
                ),
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
                    'Matricula: ${matricula}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
