import 'dart:html';
import 'dart:typed_data'; // For Uint8List

class Student {
  final int? id;
  final String name;
  final String registrationNumber;
  final DateTime birthDate;
  final String? studentClass;
  final Blob? photo;
  final Uint8List qrCode;

  Student({
    this.id,
    required this.name,
    required this.registrationNumber,
    required this.birthDate,
    this.studentClass,
    this.photo,
    required this.qrCode,
  });
}
