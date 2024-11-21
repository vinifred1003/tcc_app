import 'package:tcc_app/models/attendance.dart';

class StudentExit extends Attendance {
  final String guardians;

  const StudentExit({
    required super.name,
    required super.date,
    required super.type,
    required this.guardians,
  });
}
