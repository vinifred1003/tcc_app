import 'package:tcc_app/models/class.dart';
import 'package:tcc_app/models/employee.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/models/occupation.dart';
import 'package:tcc_app/models/student_entry.dart';
import 'package:tcc_app/models/student.dart';
import 'package:tcc_app/models/student_exit.dart';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user_role.dart';
import '../models/student_warning.dart';

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
      qrCode: 'qrRoberto',
      photo: '',
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
          type: GuardianType.FATHER,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Guardian(
          id: 2,
          name: 'Maria',
          cpf: '12345678901',
          phone: '123456789',
          email: 'maria@example.com',
          type: GuardianType.MOTHER,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
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
      registrationNumber: 'joao',
      birthDate: DateTime(2018, 03, 10),
      classId: 2,
      qrCode: 'qrJoao',
      photo: '',
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
          type: GuardianType.FATHER,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Guardian(
          id: 4,
          name: 'Joana',
          cpf: '12345678903',
          phone: '123456789',
          email: 'joana@example.com',
          type: GuardianType.MOTHER,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
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
      qrCode: '',
      photo: '',
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
          type: GuardianType.FATHER,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Guardian(
          id: 6,
          name: 'Dona Rosinha',
          cpf: '12345678905',
          phone: '123456789',
          email: 'donarosinha@example.com',
          type: GuardianType.GRANDMOTHER,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
      warnings: [],
      entries: [],
      exits: [],
    ),
  ),
];
final dummyUserRoles = [];
final dummyStudents = [
  Student(
    id: 1,
    name: 'Roberto Silva',
    registrationNumber: '651',
    birthDate: DateTime(2016, 05, 15),
    classId: 1,
    qrCode: '',
    photo: '',
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
        type: GuardianType.FATHER,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Guardian(
        id: 2,
        name: 'Maria',
        cpf: '12345678901',
        phone: '123456789',
        email: 'maria@example.com',
        type: GuardianType.MOTHER,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
    warnings: [],
    entries: [],
    exits: [],
  ),
  Student(
    id: 2,
    name: 'João Ribeiro',
    registrationNumber: 'Joao',
    birthDate: DateTime(2018, 03, 10),
    classId: 2,
    qrCode: '',
    photo: '',
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
        type: GuardianType.FATHER,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Guardian(
        id: 4,
        name: 'Joana',
        cpf: '12345678903',
        phone: '123456789',
        email: 'joana@example.com',
        type: GuardianType.MOTHER,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
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
    qrCode: '',
    photo: '',
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
        type: GuardianType.FATHER,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Guardian(
        id: 6,
        name: 'Dona Rosinha',
        cpf: '12345678905',
        phone: '123456789',
        email: 'donarosinha@example.com',
        type: GuardianType.MOTHER,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
    warnings: [],
    entries: [],
    exits: [],
  ),
];

final List<StudentWarning> dummyWarnings = [
  StudentWarning(
    id: 1,
    studentId: dummyStudents[0].id,
    issuedBy: dummyEmployee[0].id,
    issuedAt: DateTime.now().subtract(const Duration(days: 2)),
    reason: 'Uso inadequado de celular em sala de aula.',
    severity: 'MEDIUM',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    student: dummyStudents[0],
    issuedByEmployee: null,
  ),
  StudentWarning(
    id: 2,
    studentId: dummyStudents[1].id,
    issuedBy: dummyEmployee[1].id,
    issuedAt: DateTime.now().subtract(const Duration(days: 7)),
    reason: 'Falta injustificada.',
    severity: 'HIGH',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    updatedAt: DateTime.now().subtract(const Duration(days: 6)),
    student: dummyStudents[1],
    issuedByEmployee: null,
  ),
  StudentWarning(
    id: 3,
    studentId: dummyStudents[0].id,
    issuedBy: dummyEmployee[1].id,
    issuedAt: DateTime.now().subtract(const Duration(days: 15)),
    reason: 'Agressão verbal a colega.',
    severity: 'CRITICAL',
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now().subtract(const Duration(days: 14)),
    student: dummyStudents[0],
    issuedByEmployee: null,
  ),
];

final List<Employee> dummyEmployee = [
// Dados falsos para funcionários
  Employee(
    id: 1,
    name: 'Ana Santos',
    userId: dummyUser[0].id,
    admissionDate: DateTime.now().subtract(const Duration(days: 1500)),
    occupationId: 1,
    photo: [255, 216, 200], // Dados simulados de foto
    createdAt: DateTime.now().subtract(const Duration(days: 1500)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    user: dummyUser[0],
    warnings: [],
  ),
  Employee(
    id: 2,
    name: 'Marcos Silva',
    userId: dummyUser[1].id,
    admissionDate: DateTime.now().subtract(const Duration(days: 1200)),
    occupationId: 2,
    photo: [255, 100, 150], // Dados simulados de foto
    createdAt: DateTime.now().subtract(const Duration(days: 1200)),
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    user: dummyUser[1],
    warnings: [],
  )
];

final List<Occupation> dummyOccupations = [
  Occupation(
    id: 1,
    name: "Project Manager",
    createdAt: DateTime(2022, 5, 25),
    updatedAt: DateTime(2023, 7, 30),
    employees: null,
  )
];

final List<StudentExit> dummyExits = [
  StudentExit(
      id: 1,
      studentId: dummyStudents[1].id,
      student: dummyStudents[1],
      guardianId: 5,
      exitAt: DateTime.now(),
      createdAt: DateTime(2023, 12, 31),
      updatedAt: DateTime(2024, 1, 1),
      guardian: dummyStudents[1].guardians[1])
];
