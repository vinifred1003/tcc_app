import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/screens/editScreens/edit_entry.dart';
import 'package:tcc_app/screens/editScreens/edit_employee.dart';

class ProfileDisplay extends StatefulWidget {
  final String name;
  final String classOrInstitution;
  final String? jobPosition;

  const ProfileDisplay(
      {super.key,
      required this.name,
      required this.classOrInstitution,
      this.jobPosition});

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.8, // Limit width to 80% of screen width
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 150,
              height: 150,
              color: Colors.white10, // Added background to ensure visibility
              child: const Opacity(
                opacity: 0.85,
                child: Image(
                  image: AssetImage('assets/images/foto_perfil.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Added spacing
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8), // Added spacing
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.jobPosition ?? "Educando",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    " - ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.classOrInstitution,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
