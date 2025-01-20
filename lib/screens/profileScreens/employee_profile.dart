import 'package:flutter/material.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/screens/components/global/app_drawer.dart';
import 'package:tcc_app/screens/components/global/base_app_bar.dart';
import 'package:tcc_app/screens/components/home/profile_display.dart';
import 'package:intl/intl.dart';

class EmployeeProfile extends StatelessWidget {
  final Employee employee;
  const EmployeeProfile(this.employee, {super.key});

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
        appBar: const BaseAppBar(screen_title: Text("Funcionarios")),
        drawer: AppDrawer(),
        body: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (context, ScrollController) {
            return SingleChildScrollView(
              controller: ScrollController,
              child: Column(
                children: [
                  SizedBox(
                    width: 500,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: ProfileDisplay(
                        employee: employee,
                      ),
                    ),
                  ),
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15), // Bordas arredondadas
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Cor da sombra
                          spreadRadius: 2, // Distância de expansão da sombra
                          blurRadius: 8, // Nível de desfoque
                          offset: Offset(
                              4, 6), // Deslocamento horizontal e vertical
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: verticalPaddingText),
                          child: SizedBox(
                            width: 500,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Text(
                                'Nome: ${employee.name}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: verticalPaddingText),
                          child: SizedBox(
                            width: 500,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Text(
                                'Data de admissão: ' +
                                    DateFormat('d/MM/y')
                                        .format(employee.admissionDate),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: verticalPaddingText),
                          child: SizedBox(
                            width: 500,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Text(
                                'Nome: ${employee.name}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: verticalPaddingText),
                          child: SizedBox(
                            width: 500,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Text(
                                'Nome: ${employee.name}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: verticalPaddingText),
                          child: SizedBox(
                            width: 500,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Text(
                                'Nome: ${employee.name}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: verticalPaddingText),
                          child: SizedBox(
                            width: 500,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPaddingText),
                              child: Text(
                                'Nome: ${employee.name}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
