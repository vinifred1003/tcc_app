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
  String? qrCode;
  String? photo;
  DateTime createdAt;
  DateTime updatedAt;
  Class? studentClass;
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
    required this.createdAt,
    required this.updatedAt,
    required this.guardians,
    this.photo,
    this.qrCode,
    this.studentClass,
    this.warnings,
    this.entries,
    this.exits,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : DateTime.now(),
      classId: json['classId'] ?? 0,
      qrCode: json['qrCode'],
      photo: json['photo'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      studentClass: json['studentClass'] != null
          ? Class.fromJson(json['studentClass'])
          : null,
      guardians: json['guardians'] != null
          ? (json['guardians'] as List)
              .map((i) => Guardian.fromJson(i))
              .toList()
          : [],
      warnings: json['warnings'] != null
          ? (json['warnings'] as List)
              .map((i) => StudentWarning.fromJson(i))
              .toList()
          : [],
      entries: json['entries'] != null
          ? (json['entries'] as List)
              .map((i) => StudentEntry.fromJson(i))
              .toList()
          : [],
      exits: json['exits'] != null
          ? (json['exits'] as List).map((i) => StudentExit.fromJson(i)).toList()
          : [],
    );
  }
}
