class Occupation {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  // List<Employee>? employees;

  Occupation({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    // required this.employees,
  });

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      // employees:
      //     (json['employees'] as List).map((i) => Employee.fromJson(i)).toList(),
    );
  }
}
