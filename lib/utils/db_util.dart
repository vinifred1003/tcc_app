// import 'package:sqflite/sqflite.dart' as sql;
// import 'dart:html';
// import 'package:path/path.dart' as path;

// class DbUtil {
//   static Future<sql.Database> database() async {
//     final dbPath = await sql.getDatabasesPath();
//     return sql.openDatabase(
//       path.join(dbPath, 'students.db'),
//       onCreate: (db, version) {
//         return db.execute('CREATE TABLE students('
//             'id_student INT  NOT NULL AUTO_INCREMENT PRIMARY KEY ,'
//             'name VARCHAR(50) NOT NULL,'
//             'RA VARCHAR(12) NOT NULL,'
//             'Birh_date DATE NOT NULL,'
//             'student_class VARCHAR(20),'
//             'photo TEXT,'
//             'qrCode TEXT NOT NULL)');
//       },
//       version: 1,
//     );
//   }

//   static Future<void> insert(String table, Map<String, Object> data) async {
//     final db = await DbUtil.database();
//     await db.insert(
//       table,
//       data,
//       conflictAlgorithm: sql.ConflictAlgorithm.replace,
//     );
//   }
