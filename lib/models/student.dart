import 'dart:html';

class Student {
  final int id;
  final String name;
  final String registration_number;
  final DateTime age;
  final String student_class;
  final Blob photo;
  final Blob qrCode;

  Student({
    required this.id,
    required this.name,
    required this.registration_number,
    required this.age,
    required this.student_class,
    required this.photo,
    required this.qrCode,
  });
}
