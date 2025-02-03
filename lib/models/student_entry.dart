import 'package:tcc_app/models/attendance.dart';
import 'package:tcc_app/models/student.dart';

class StudentEntry extends Attendance {
  DateTime entryAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  StudentEntry({
    required super.id,
    required super.studentId,
    super.student,
    required this.entryAt,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentEntry.fromJson(Map<String, dynamic> json) {
    return StudentEntry(
      id: json['id'],
      studentId: json['studentId'],
      entryAt: DateTime.parse(json['entryAt']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
    );
  }
}
