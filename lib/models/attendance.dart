import 'package:tcc_app/models/student.dart';

abstract class Attendance {
  int id;
  int studentId;
  Student? student;

  Attendance({
    required this.id,
    required this.studentId,
    this.student,
  });
}
