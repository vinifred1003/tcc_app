import 'package:tcc_app/models/employee.dart';

class Occupation {
  int id;
  String name;

  Occupation({
    required this.id,
    required this.name,
  });

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      id: json['id'],
      name: json['name'],
    );
  }
}
