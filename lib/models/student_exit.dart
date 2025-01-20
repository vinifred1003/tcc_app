import 'package:tcc_app/models/attendance.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student.dart';

class StudentExit extends Attendance {
  int guardianId;
  DateTime exitAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Guardian? guardian;

  StudentExit({
    required super.id,
    required super.studentId,
    super.student,
    required this.guardianId,
    required this.exitAt,
    this.createdAt,
    this.updatedAt,
    this.guardian,
  });

  factory StudentExit.fromJson(Map<String, dynamic> json) {
    return StudentExit(
      id: json['id'],
      studentId: json['studentId'],
      guardianId: json['guardianId'],
      exitAt: DateTime.parse(json['exitAt']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      guardian:
          json['guardian'] != null ? Guardian.fromJson(json['guardian']) : null,
    );
  }
}
