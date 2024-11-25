import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/student_warning.dart';
import 'package:tcc_app/models/user.dart';

class Employee {
  int id;
  String name;
  int? userId;
  DateTime admissionDate;
  int occupationId;
  List<int>? photo;
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
      admissionDate: DateTime.parse(json['admission_date']),
      occupationId: json['occupation_id'],
      photo: List<int>.from(json['photo']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      occupation: Occupation.fromJson(json['occupation']),
      warnings: (json['warnings'] as List)
          .map((i) => StudentWarning.fromJson(i))
          .toList(),
    );
  }
}
