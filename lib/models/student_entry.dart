import 'package:tcc_app/models/attendance.dart';
import 'package:tcc_app/models/student.dart';

class StudentEntry extends Attendance {
  DateTime entryAt;
  DateTime createdAt;
  DateTime updatedAt;

  StudentEntry({
    required super.id,
    required super.studentId,
    required super.student,
    required this.entryAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentEntry.fromJson(Map<String, dynamic> json) {
    return StudentEntry(
      id: json['id'],
      studentId: json['student_id'],
      entryAt: DateTime.parse(json['entry_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      student: Student.fromJson(json['student']),
    );
  }
}
