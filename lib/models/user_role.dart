import 'package:tcc_app/models/user.dart';

enum UserRolesEnum {
  admin(1),
  employee(2);

  final int id;
  const UserRolesEnum(this.id);
}

class UserRole {
  UserRolesEnum id;
  String name;
  List<User>? users;

  UserRole({
    required this.id,
    required this.name,
    this.users,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: UserRolesEnum.values.firstWhere((e) => e.index == json['id']),
      name: json['name'],
      users: (json['users'] as List).map((i) => User.fromJson(i)).toList(),
    );
  }
}
