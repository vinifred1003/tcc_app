import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tcc_app/models/attendance.dart';
import 'package:tcc_app/screens/login_screen.dart';

import '../models/user.dart';
import 'components/global/app_drawer.dart';
import 'components/global/base_app_bar.dart';
import 'components/home/center_buttons.dart';
import 'components/home/footer.dart';
import 'components/home/profile_display.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User u;

  String scanResult = "";

  @override
  void initState() {
    super.initState();
    u = widget.user;
  }

  void _selectLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return LoginScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery with constraints to make the layout more responsive
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate paddings as a percentage of screen size with minimum values
    final horizontalPadding = max(screenWidth * 0.1, 20.0);
    final verticalPadding = max(screenHeight * 0.1, 20.0);
    final topPaddingFooter = max(screenHeight * 0.05, 15.0);
    final bottomPaddingFooter = max(screenHeight * 0.02, 10.0);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const BaseAppBar(screen_title: Text("Home")),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: ProfileDisplay(
                      name: u.name,
                      classOrInstitution: 
                          u.employee?.occupation?.name ?? 'Não informado',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          child: CenterButtons(
                            selectedScanQRCode: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: topPaddingFooter,
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: bottomPaddingFooter,
                    ),
                    child: Footer(
                      selectedLoginScreen: () => _selectLoginScreen(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
