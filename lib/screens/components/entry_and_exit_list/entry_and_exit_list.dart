import 'package:flutter/material.dart';

class EntryAndExitList extends StatelessWidget {
  final List filteredStudents;
  const EntryAndExitList(this.filteredStudents, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isEmpty = filteredStudents.isEmpty;
    return Column(
      children: [
        isEmpty
            ? Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Nenhuma Saida ou Entrada',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (ctx, index) {
                    final tr = filteredStudents[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: FittedBox(child: Text('foto')),
                          ),
                        ),
                        title: Text(
                          tr.student.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                            "" // tr.type + " " + DateFormat('d MMM y').format(tr.en),
                            ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
