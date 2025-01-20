import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/user.dart';

class GuardianType {
  final String key;
  final String displayName;

  const GuardianType._(this.key, this.displayName);

  static const FATHER = GuardianType._('FATHER', 'Pai');
  static const MOTHER = GuardianType._('MOTHER', 'Mãe');
  static const STEPFATHER = GuardianType._('STEPFATHER', 'Padrasto');
  static const STEPMOTHER = GuardianType._('STEPMOTHER', 'Madrasta');
  static const GRANDFATHER = GuardianType._('GRANDFATHER', 'Avô');
  static const GRANDMOTHER = GuardianType._('GRANDMOTHER', 'Avó');
  static const UNCLE = GuardianType._('UNCLE', 'Tio');
  static const AUNT = GuardianType._('AUNT', 'Tia');
  static const GUARDIAN = GuardianType._('GUARDIAN', 'Guardião');
  static const OTHER = GuardianType._('OTHER', 'Outro');

  static const List<GuardianType> values = [
    FATHER,
    MOTHER,
    STEPFATHER,
    STEPMOTHER,
    GRANDFATHER,
    GRANDMOTHER,
    UNCLE,
    AUNT,
    GUARDIAN,
    OTHER,
  ];
}

class Guardian {
  int id;
  String name;
  String cpf;
  int? userId;
  String phone;
  String email;
  GuardianType type;
  // List<int> photo;
  DateTime? createdAt;
  DateTime? updatedAt;
  // List<Student>? students;
  // List<Guardian>? exits;
  // User? user;

  Guardian({
    required this.id,
    required this.name,
    required this.cpf,
    this.userId,
    required this.phone,
    required this.email,
    required this.type,
    // required this.photo,
    this.createdAt,
    this.updatedAt,
    // this.students,
    // this.exits,
    // this.user,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      userId: json['user_id'],
      phone: json['phone'],
      email: json['email'],
      type:
          GuardianType.values.firstWhere((e) => e.displayName == json['type']),
      // photo: List<int>.from(json['photo']),
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
      //   students:
      //       (json['students'] as List).map((i) => Student.fromJson(i)).toList(),
      //   exits: (json['exits'] as List).map((i) => Guardian.fromJson(i)).toList(),
    );
  }
}
