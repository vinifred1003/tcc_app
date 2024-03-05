import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Text("Bem vindo"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: const <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.question_mark),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 70,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Image(
                    image: AssetImage(
                      'assets/images/foto_perfil.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              child: Text("Vinicius Fedrigo Frederico"),
            ),
            SizedBox(
              width: 79,
              height: 20,
              child: Row(
                children: [
                  Text("Aluno"),
                  Text(" - "),
                  Text("IFPR"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 75),
              child: Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Chegada"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(100, 70),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Saída"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(100, 70),
                        ),
                      ),
                    )
                  ]),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Advertencia"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(100, 70),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Ficha"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(100, 70),
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
