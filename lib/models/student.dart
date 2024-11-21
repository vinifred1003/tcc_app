import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student_entry.dart';
import 'package:tcc_app/models/student_exit.dart';
import 'package:tcc_app/models/student_warning.dart';

class Student {
  int id;
  String name;
  String registrationNumber;
  DateTime birthDate;
  int classId;
  List<int> qrCode;
  List<int> photo;
  DateTime createdAt;
  DateTime updatedAt;
  Class studentClass;
  List<Guardian> guardians;
  List<StudentWarning>? warnings;
  List<StudentEntry>? entries;
  List<StudentExit>? exits;

  Student({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.birthDate,
    required this.classId,
    required this.qrCode,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.studentClass,
    required this.guardians,
    required this.warnings,
    required this.entries,
    required this.exits,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registration_number'],
      birthDate: DateTime.parse(json['birth_date']),
      classId: json['class_id'],
      qrCode: List<int>.from(json['qr_code']),
      photo: List<int>.from(json['photo']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      studentClass: Class.fromJson(json['class']),
      guardians:
          (json['guardians'] as List).map((i) => Guardian.fromJson(i)).toList(),
      warnings: (json['warnings'] as List)
          .map((i) => StudentWarning.fromJson(i))
          .toList(),
      entries: (json['entries'] as List)
          .map((i) => StudentEntry.fromJson(i))
          .toList(),
      exits:
          (json['exits'] as List).map((i) => StudentExit.fromJson(i)).toList(),
    );
  }
}
