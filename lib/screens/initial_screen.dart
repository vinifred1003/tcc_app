import 'package:flutter/material.dart';
import './entry_record.dart';
import '../data/dummy_data.dart';
import 'package:camera/camera.dart';
import './camera_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  CameraDescription? firstCamera;

  void _selectEntryRecords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return EntryRecord(dummyStudentEntry);
      }),
    );
  }

  void _InitCamera(BuildContext context) {
    if (firstCamera != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) {
          return CameraScreen(camera: firstCamera!);
        }),
      );
    } else {
      // Tratar o caso em que firstCamera é null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Text(" Aplicativo Meprovi"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Colors.white, // Defina a cor desejada para o botão do Drawer
        ),
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
      drawer: Container(
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Aplicativo Meprovi',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              ListTile(title: const Text('Home'), onTap: () {}),
              ListTile(
                title: Text('Educandos'),
                onTap: () => _selectEntryRecords(context),
              ),
              ListTile(
                title: const Text('Educadores'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Entradas e Saidas'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Advertencias'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Sair'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
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
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 55),
              child: Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () => _InitCamera(context),
                        child: Text(
                          "Chegada",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(130, 70),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Saída",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(130, 70),
                        ),
                      ),
                    )
                  ]),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Advertência",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(130, 70),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Ficha",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).textTheme.labelLarge?.color,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(130, 70),
                        ),
                      ),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, right: 40),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Logar em outra conta",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Sair",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
