import 'package:flutter/material.dart';

class ProfileDisplay extends StatelessWidget {
  const ProfileDisplay({super.key});

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
        const SizedBox(
          height: 30,
          child: Text(
            "Vinicius Frederico",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 101,
          height: 20,
          child: Row(
            children: [
              Text(
                "Aluno",
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
                "IFPR",
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
