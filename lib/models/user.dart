// import 'dart:ui';

// class User {
//   final String id;
//   final String email;
//   final String username;
//   final String password;
//   final String jobPosition;
//   final Image? photo;

//   const User({
//     required this.id,
//     required this.email,
//     required this.username,
//     required this.password,
//     required this.jobPosition,
//     this.photo
//   });
// }

import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/user_role.dart';

class User {
  int? id;
  String name;
  String email;
  String? password;
  UserRolesEnum roleId;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserRole? role;
  Employee? employee;
  Guardian? guardian;

  User({
    this.id,
    required this.name,
    required this.email,
    this.password,
    required this.roleId,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.employee,
    this.guardian,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      roleId: UserRolesEnum.values.firstWhere((e) => e.id == json['roleId']),
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
      role: UserRole.fromJson(json['role']),
      // employee: Employee.fromJson(json['employee']),
      // guardian: Guardian.fromJson(json['guardian']),
    );
  }
}
