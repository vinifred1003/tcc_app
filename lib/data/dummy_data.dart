import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/student_entry.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user_role.dart';

import 'dart:typed_data'; // For Uint8List
import 'dart:io';
import 'package:path_provider/path_provider.dart';

late Uint8List qrJoao;
late Uint8List qrMaria;
late Uint8List qrRoberto;

Future<Uint8List> imageToBlob(String imageName) async {
  // Get the directory where the images are stored
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String imagePath = '${appDocDir.path}/dummyQrCode/$imageName';

  // Read the image file as bytes
  File imageFile = File(imagePath);
  Uint8List imageBytes = await imageFile.readAsBytes();

  return imageBytes; // This is the blob
}

Future<void> convertImagesToBlobs() async {
  // Convert each image to a blob
  qrJoao = await imageToBlob('joao.jpg');
  qrMaria = await imageToBlob('maria.jpg');
  qrRoberto = await imageToBlob('Roberto.jpg');
}

final dummyUser = [
  User(
    id: 1,
    name: 'Vinícius Fedrigo Frederico',
    email: 'viniciusfrederico1003@gmail.com',
    password: '123456',
    roleId: UserRolesEnum.admin,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    role: UserRole(id: UserRolesEnum.admin, name: 'Professor', isAdmin: true),
    employee: Employee(
        id: 1,
        name: 'Vinícius Fedrigo Frederico',
        admissionDate: DateTime.now(),
        occupationId: 1),
  ),
  User(
      id: 2,
      name: 'Julia Ribeiro Paiva',
      email: 'juliaRibPaiva@gmail.com',
      password: '123456',
      roleId: UserRolesEnum.admin,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: UserRole(id: UserRolesEnum.admin, name: 'Professor', isAdmin: true),
      employee: Employee(
          id: 2,
          name: 'Julia Ribeiro Paiva',
          admissionDate: DateTime.now(),
          occupationId: 1)),
  User(
      id: 3,
      name: 'Jhony Allan Paes',
      email: 'jhonyAllan@hotmail.com',
      password: '123456',
      roleId: UserRolesEnum.admin,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: UserRole(id: UserRolesEnum.admin, name: 'Professor', isAdmin: true),
      employee: Employee(
          id: 3,
          name: 'Jhony Allan Paes',
          admissionDate: DateTime.now(),
          occupationId: 1)),
];

final dummyStudentEntry = [
  StudentEntry(
    id: 1,
    studentId: 1,
    entryAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    student: Student(
      id: 1,
      name: 'Roberto Silva',
      registrationNumber: '651',
      birthDate: DateTime(2016, 05, 15),
      classId: 1,
      qrCode: qrRoberto,
      photo: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      studentClass: Class(id: 1, name: 'Class 1'),
      guardians: [
        Guardian(
            id: 1,
            name: 'Valdecir',
            cpf: '12345678900',
            phone: '123456789',
            email: 'valdecir@example.com',
            type: 'Father',
            photo: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            students: [],
            exits: []),
        Guardian(
            id: 2,
            name: 'Maria',
            cpf: '12345678901',
            phone: '123456789',
            email: 'maria@example.com',
            type: 'Mother',
            photo: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            students: [],
            exits: []),
      ],
      warnings: [],
      entries: [],
      exits: [],
    ),
  ),
  StudentEntry(
    id: 2,
    studentId: 2,
    entryAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    student: Student(
      id: 2,
      name: 'João Ribeiro',
      registrationNumber: '812',
      birthDate: DateTime(2018, 03, 10),
      classId: 2,
      qrCode: qrJoao,
      photo: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      studentClass: Class(id: 2, name: 'Class 2'),
      guardians: [
        Guardian(
            id: 3,
            name: 'Joslei',
            cpf: '12345678902',
            phone: '123456789',
            email: 'joslei@example.com',
            type: 'Father',
            photo: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            students: [],
            exits: []),
        Guardian(
            id: 4,
            name: 'Joana',
            cpf: '12345678903',
            phone: '123456789',
            email: 'joana@example.com',
            type: 'Mother',
            photo: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            students: [],
            exits: []),
      ],
      warnings: [],
      entries: [],
      exits: [],
    ),
  ),
  StudentEntry(
    id: 3,
    studentId: 3,
    entryAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    student: Student(
      id: 3,
      name: 'Maria Joaquina dos Santos',
      registrationNumber: '512',
      birthDate: DateTime(2018, 08, 20),
      classId: 3,
      qrCode: qrMaria,
      photo: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      studentClass: Class(id: 3, name: 'Class 3'),
      guardians: [
        Guardian(
            id: 5,
            name: 'Seu João',
            cpf: '12345678904',
            phone: '123456789',
            email: 'seujoao@example.com',
            type: 'Father',
            photo: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            students: [],
            exits: []),
        Guardian(
            id: 6,
            name: 'Dona Rosinha',
            cpf: '12345678905',
            phone: '123456789',
            email: 'donarosinha@example.com',
            type: 'Mother',
            photo: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            students: [],
            exits: []),
      ],
      warnings: [],
      entries: [],
      exits: [],
    ),
  ),
];

final dummyStudents = [
  Student(
    id: 1,
    name: 'Roberto Silva',
    registrationNumber: '651',
    birthDate: DateTime(2016, 05, 15),
    classId: 1,
    qrCode: qrRoberto,
    photo: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    studentClass: Class(id: 1, name: 'Class 1'),
    guardians: [
      Guardian(
          id: 1,
          name: 'Valdecir',
          cpf: '12345678900',
          phone: '123456789',
          email: 'valdecir@example.com',
          type: 'Father',
          photo: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          students: [],
          exits: []),
      Guardian(
          id: 2,
          name: 'Maria',
          cpf: '12345678901',
          phone: '123456789',
          email: 'maria@example.com',
          type: 'Mother',
          photo: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          students: [],
          exits: []),
    ],
    warnings: [],
    entries: [],
    exits: [],
  ),
  Student(
    id: 2,
    name: 'João Ribeiro',
    registrationNumber: '812',
    birthDate: DateTime(2018, 03, 10),
    classId: 2,
    qrCode: qrJoao,
    photo: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    studentClass: Class(id: 2, name: 'Class 2'),
    guardians: [
      Guardian(
          id: 3,
          name: 'Joslei',
          cpf: '12345678902',
          phone: '123456789',
          email: 'joslei@example.com',
          type: 'Father',
          photo: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          students: [],
          exits: []),
      Guardian(
          id: 4,
          name: 'Joana',
          cpf: '12345678903',
          phone: '123456789',
          email: 'joana@example.com',
          type: 'Mother',
          photo: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          students: [],
          exits: []),
    ],
    warnings: [],
    entries: [],
    exits: [],
  ),
  Student(
    id: 3,
    name: 'Maria Joaquina dos Santos',
    registrationNumber: '512',
    birthDate: DateTime(2018, 08, 20),
    classId: 3,
    qrCode: qrMaria,
    photo: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    studentClass: Class(id: 3, name: 'Class 3'),
    guardians: [
      Guardian(
          id: 5,
          name: 'Seu João',
          cpf: '12345678904',
          phone: '123456789',
          email: 'seujoao@example.com',
          type: 'Father',
          photo: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          students: [],
          exits: []),
      Guardian(
          id: 6,
          name: 'Dona Rosinha',
          cpf: '12345678905',
          phone: '123456789',
          email: 'donarosinha@example.com',
          type: 'Mother',
          photo: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          students: [],
          exits: []),
    ],
    warnings: [],
    entries: [],
    exits: [],
  ),
];
