import 'package:tcc_app/models/student.dart';

import '../models/user.dart';
import '../models/student_entry.dart';

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

const dummyUser = [
  User(
      id: 'u1',
      email: 'viniciusfrederico1003@gmail.com',
      username: 'vinicius Fedrigo Frederico',
      password: '123456',
      jobPosition: 'Professor')
];
final dummyStudentEntry = [
  StudentEntry(
    name: 'Roberto Silva',
    date: DateTime.now(),
  ),
  StudentEntry(
    name: 'João Ribeiro',
    date: DateTime.now(),
  ),
  StudentEntry(
    name: 'Maria Joaquina dos Santos',
    date: DateTime.now(),
  ),
];

final dummyStudents = [
  Student(
      name: "Roberto Silva",
      registrationNumber: "651",
      birthDate: DateTime(2016, 05, 15),
      qrCode: qrRoberto),
  Student(
      name: "João Ribeiro",
      registrationNumber: "812",
      birthDate: DateTime(2018, 03, 10),
      qrCode: qrJoao),
  Student(
      name: 'Maria Joaquina dos Santos',
      registrationNumber: "512",
      birthDate: DateTime(2018, 08, 20),
      qrCode: qrMaria),
];
