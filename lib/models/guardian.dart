// enum GuardianType {
//   FATHER,
//   MOTHER,
//   STEPFATHER,
//   STEPMOTHER,
//   GRANDFATHER,
//   GRANDMOTHER,
//   UNCLE,
//   AUNT,
//   GUARDIAN,
//   OTHER,
// }

import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/user.dart';

class Guardian {
  int id;
  String name;
  String cpf;
  int? userId;
  String phone;
  String email;
  String type;
  List<int> photo;
  DateTime createdAt;
  DateTime updatedAt;
  List<Student>? students;
  List<Guardian>? exits;
  User? user;

  Guardian({
    required this.id,
    required this.name,
    required this.cpf,
    this.userId,
    required this.phone,
    required this.email,
    required this.type,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    this.students,
    this.exits,
    this.user,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      userId: json['user_id'],
      phone: json['phone'],
      email: json['email'],
      type: json['type'],
      // type: GuardianType.values
      //     .firstWhere((e) => e.toString() == 'GuardianType.' + json['type']),
      photo: List<int>.from(json['photo']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      students:
          (json['students'] as List).map((i) => Student.fromJson(i)).toList(),
      exits: (json['exits'] as List).map((i) => Guardian.fromJson(i)).toList(),
    );
  }
}
