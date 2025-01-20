import 'package:flutter/material.dart';
import 'package:tcc_app/data/dummy_data.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/screens/editScreens/edit_employee.dart';

class ProfileDisplay extends StatefulWidget {
  final Employee employee;

  const ProfileDisplay({super.key, required this.employee, required});

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  void _selectEditEmployeeForm(BuildContext context, e) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditEmployee(e);
      },
    ).then((result) {
      if (result[1] != null && result[0] != null) {
        int indexUser = dummyUser.indexWhere((user) => user.id == result[0].id);
        int indexEmployee =
            dummyEmployee.indexWhere((employee) => employee.id == result[1].id);
        setState(() {
          dummyUser[indexUser] = result[0];
          dummyEmployee[indexEmployee] = result[1];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.employee;
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
              e.name,
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
                    e.occupation!.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    " Desde: ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    DateFormat('d/MM/y').format(e.admissionDate),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      onPressed: () => _selectEditEmployeeForm(context, e),
                      icon: Icon(Icons.edit)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
