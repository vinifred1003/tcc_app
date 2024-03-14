import 'package:flutter/material.dart';
import '../models/student_entry.dart';
import 'package:intl/intl.dart';

class EntryRecord extends StatelessWidget {
  final List<StudentEntry> students;
  const EntryRecord(this.students, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return students.isEmpty
        ? Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Nenhuma Transação Cadastrada!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )
        : ListView.builder(
            itemCount: students.length,
            itemBuilder: (ctx, index) {
              final tr = students[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(child: Text('foto')),
                    ),
                  ),
                  title: Text(
                    tr.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(tr.date),
                  ),
                ),
              );
            },
          );
  }
}
