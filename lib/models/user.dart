import 'dart:ui';

class User {
  final String id;
  final String email;
  final String username;
  final String password;
  final String jobPosition;
  final Image? photo;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.jobPosition,
    this.photo
  });
}
