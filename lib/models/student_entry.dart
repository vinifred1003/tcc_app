import 'package:tcc_app/models/student.dart';

class StudentEntry {
  int id;
  int studentId;
  DateTime entryAt;
  DateTime createdAt;
  DateTime updatedAt;
  Student student;

  StudentEntry({
    required this.id,
    required this.studentId,
    required this.entryAt,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
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
