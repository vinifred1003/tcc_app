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
import 'package:tcc_app/models/user_role.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  UserRolesEnum roleId;
  DateTime createdAt;
  DateTime updatedAt;
  UserRole role;
  Employee employee;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.employee,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      roleId:
          UserRolesEnum.values.firstWhere((e) => e.index == json['role_id']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      role: UserRole.fromJson(json['role']),
      employee: Employee.fromJson(json['employee']),
    );
  }
}
