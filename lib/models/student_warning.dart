import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/student.dart';

// enum StudentWarningSeverity {
//   LOW,
//   MEDIUM,
//   HIGH,
//   CRITICAL,
// }

class StudentWarning {
  int id;
  int studentId;
  int issuedBy;
  DateTime issuedAt;
  String reason;
  // StudentWarningSeverity severity;
  String severity;
  DateTime createdAt;
  DateTime updatedAt;
  Student student;
  Employee? issuedByEmployee;

  StudentWarning({
    required this.id,
    required this.studentId,
    required this.issuedBy,
    required this.issuedAt,
    required this.reason,
    required this.severity,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
    required this.issuedByEmployee,
  });

  factory StudentWarning.fromJson(Map<String, dynamic> json) {
    return StudentWarning(
      id: json['id'],
      studentId: json['studentId'],
      issuedBy: json['issuedBy'],
      issuedAt: DateTime.parse(json['issuedAt']),
      reason: json['reason'],
      // severity: StudentWarningSeverity.values.firstWhere(
      //     (e) => e.toString() == 'StudentWarningSeverity.' + json['severity']),
      severity: json['severity'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      student: Student.fromJson(json['student']),
      issuedByEmployee: Employee.fromJson(json['issuedByEmployee']),
    );
  }
}
