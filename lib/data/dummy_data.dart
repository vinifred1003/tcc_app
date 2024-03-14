import '../models/user.dart';
import '../models/student_entry.dart';

const dummyUser = [
  User(
    id: 'u1',
    username: 'vini@gmail.com',
    password: '123456',
  )
];
final dummyStudentEntry = [
  StudentEntry(
    name: 'Vinicius',
    date: DateTime.now(),
  ),
  StudentEntry(
    name: 'joao',
    date: DateTime.now(),
  ),
  StudentEntry(
    name: 'maria',
    date: DateTime.now(),
  ),
];
