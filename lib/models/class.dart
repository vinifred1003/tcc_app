import 'package:tcc_app/models/student.dart';

class Class {
  int id;
  String name;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Student>? students;

  Class({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.students,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      name: json['name'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
      // students:
      //     (json['students'] as List).map((i) => Student.fromJson(i)).toList(),
    );
  }
}
