import 'dart:typed_data'; // For Uint8List

class Student {
  final int? id;
  final String name;
  final String registrationNumber;
  final DateTime birthDate;
  final List<String> guardians;
  final String? studentClass;
  final Uint8List? photo;
  final Uint8List qrCode;

  Student({
    this.id,
    required this.name,
    required this.registrationNumber,
    required this.birthDate,
    required this.guardians,
    this.studentClass,
    this.photo,
    required this.qrCode,
  });
}
