import 'package:jawara/models/message.dart';

final List<CitizenMessage> dummyCitizenMessages = [
  CitizenMessage(
    id: 1,
    senderName: 'Varizky Naldiba Rimra',
    title: 'titoottit', 
    description: 'mobile igmana bang',
    status: Status.accepted,
    createdAt: DateTime(2025, 10, 16),
    creatorName: 'varizky naldiba rimra',
  ),
  CitizenMessage(
    id: 2,
    senderName: 'Habibie Ed Dien',
    title: 'tes',
    description: 'Cek ombak perizinan event 17an',
    status: Status.pending,
    createdAt: DateTime(2025, 9, 28),
    creatorName: 'Habibie Ed Dien',
  ),
  CitizenMessage(
    id: 3,
    senderName: 'Rendha Putra Rahmadya',
    title: 'Usulan Kegiatan 17 Agustus',
    description: 'Mohon dipertimbangkan usulan lomba anak-anak',
    status: Status.accepted,
    createdAt: DateTime(2025, 9, 25),
    creatorName: 'Rendha Putra Rahmadya',
  ),
  CitizenMessage(
    id: 4,
    senderName: 'Safiro Alfarisi Haraya',
    title: 'Izin Penggunaan Fasilitas Umum',
    description: 'Saya ingin mengajukan izin penggunaan balai RW untuk acara keluarga.',
    status: Status.pending,
    createdAt: DateTime(2025, 9, 22),
    creatorName: 'Safiro Alfarisi Haraya',
  ),
  CitizenMessage(
    id: 5,
    senderName: 'Citra Lestari',
    title: 'Keluhan Saluran Air Mampet',
    description: 'Saluran air di depan rumah saya mampet setelah hujan deras.',
    status: Status.pending,
    createdAt: DateTime(2025, 9, 20),
    creatorName: 'Citra Lestari',
  ),
];