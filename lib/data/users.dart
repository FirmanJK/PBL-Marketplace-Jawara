import '../models/user.dart';
import '../models/user_role.dart';

final List<User> userList = [
  User(
    id: 1,
    name: 'Ahmad Fauzi',
    email: 'ahmad.fauzi@rt08.com',
    role: UserRole.adminSistem,
    phone: '081234567890',
    createdAt: DateTime(2024, 1, 15),
  ),
  User(
    id: 2,
    name: 'Siti Nurhaliza',
    email: 'siti.nurhaliza@rt08.com',
    role: UserRole.bendahara,
    phone: '081234567891',
    createdAt: DateTime(2024, 2, 10),
  ),
  User(
    id: 3,
    name: 'Budi Santoso',
    email: 'budi.santoso@rt08.com',
    role: UserRole.sekretaris,
    phone: '081234567892',
    createdAt: DateTime(2024, 3, 5),
  ),
  User(
    id: 4,
    name: 'Dewi Lestari',
    email: 'dewi.lestari@rt08.com',
    role: UserRole.ketuaRT,
    phone: '081234567893',
    createdAt: DateTime(2024, 4, 20),
  ),
  User(
    id: 5,
    name: 'Eko Prasetyo',
    email: 'eko.prasetyo@rt08.com',
    role: UserRole.warga,
    phone: '081234567894',
    createdAt: DateTime(2024, 5, 12),
  ),
  User(
    id: 6,
    name: 'Fitri Handayani',
    email: 'fitri.handayani@rt08.com',
    role: UserRole.warga,
    phone: '081234567895',
    createdAt: DateTime(2024, 6, 8),
  ),
  User(
    id: 7,
    name: 'Gunawan Wijaya',
    email: 'gunawan.wijaya@rt08.com',
    role: UserRole.warga,
    phone: '081234567896',
    createdAt: DateTime(2024, 7, 3),
  ),
  User(
    id: 8,
    name: 'Hani Rahmawati',
    email: 'hani.rahmawati@rt08.com',
    role: UserRole.warga,
    createdAt: DateTime(2024, 8, 18),
  ),
];
