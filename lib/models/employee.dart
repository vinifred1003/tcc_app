import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/student_warning.dart';
import 'package:tcc_app/models/user.dart';

class Employee {
  int id;
  String name;
  int? userId;
  DateTime admissionDate;
  int occupationId;
  String? photo;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Occupation? occupation;
  List<StudentWarning>? warnings;

  Employee({
    required this.id,
    required this.name,
    this.userId,
    required this.admissionDate,
    required this.occupationId,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.occupation,
    this.warnings,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      admissionDate: DateTime.parse(json['admissionDate']),
      occupationId: json['occupationId'],
      photo: json['photo'] != null ? json['photo'] as String : '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      occupation: json['occupation'] != null
          ? Occupation.fromJson(json['occupation'])
          : null,
      warnings: json['warnings'] != null
          ? (json['warnings'] as List)
              .map((i) => StudentWarning.fromJson(i))
              .toList()
          : null,
    );
  }
}
