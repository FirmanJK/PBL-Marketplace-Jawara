import '../models/channel.dart';

final List<Channel> channelList = [
  Channel(
    id: 1,
    nama: 'QRIS Resmi RT 08',
    tipe: 'QRIS',
    atasNama: 'RW 08 Karangploso',
    thumbnail: 'https://placehold.co/100x100/003366/FFFFFF?text=JP',
    nomorAkun: null,
  ),
  Channel(
    id: 2,
    nama: 'BCA',
    tipe: 'Bank',
    atasNama: 'jose',
    thumbnail: 'https://placehold.co/100x100/E91E63/FFFFFF?text=J',
    nomorAkun: '1234567890',
  ),
  Channel(
    id: 3,
    nama: 'GoPay',
    tipe: 'E-Wallet',
    atasNama: 'RT Jawara',
    thumbnail: null,
    nomorAkun: '082345678901',
  ),
  Channel(
    id: 4,
    nama: 'Transfer via BCA',
    tipe: 'Bank',
    atasNama: 'RT Jawara Karangploso',
    thumbnail: null,
    nomorAkun: '9876543210',
  ),
];
