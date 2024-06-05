import 'dart:html';
import 'package:flutter/foundation.dart';

class Student {
  final int id;
  final String name;
  final String matricula;
  final DateTime age;
  final String student_class;
  final Blob photo;
  final Blob qrCode;

  Student({
    required this.id,
    required this.name,
    required this.matricula,
    required this.age,
    required this.student_class,
    required this.photo,
    required this.qrCode,
  });
}
