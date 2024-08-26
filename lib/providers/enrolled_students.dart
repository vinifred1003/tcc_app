// import 'dart:html';

// import 'package:tcc_app/models/student.dart';
// import 'package:flutter/foundation.dart';
// import 'package:tcc_app/utils/db_util.dart';

// class EnrolledStudents extends ChangeNotifier {
//   List<Student> _items = [];

//   List<Student> get items {
//     return [..._items];
//   }

//   int get itemsCount {
//     return _items.length;
//   }

//   Student itemByIndex(int index) {
//     return _items[index];
//   }

//   void addStudents(String name, String registration_number, DateTime birth_date,
//       String student_class, Blob photo, Blob qrcode) {
//     final newStudent = Student(
//         name: name,
//         registration_number: registration_number,
//         birth_date: birth_date,
//         student_class: student_class,
//         photo: photo,
//         qrCode: qrcode);
//     _items.add(newStudent);
//     DbUtil.insert("students", {});
//     notifyListeners();
//   }
// }
