import 'package:flutter/material.dart';

class ProfileDisplay extends StatelessWidget {
  final String name;
  final String classOrInstitution;
  final String? jobPosition;
  const ProfileDisplay({super.key, required this.name, required this.classOrInstitution,  this.jobPosition});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 150, bottom: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const SizedBox(
              height: 150,
              width: 150,
              child: Opacity(
                opacity: 0.85,
                child: Image(
                  image: AssetImage('assets/images/foto_perfil.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
         SizedBox(
          height: 30,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
         SizedBox(
          width: 101,
          height: 20,
          child: Row(
            children: [
              Text(
                jobPosition ??"Educando",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                " - ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                classOrInstitution,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
