import '../models/mutations.dart';

final List<Mutation> mutationList = [
  Mutation(
    id: 1,
    tanggal: '15 Oktober 2025',
    keluarga: 'Keluarga Ijat',
    jenisMutasi: 'Keluar Wilayah',
    alamatLama: 'Jalan Kenanga No. 45', 
    alamatBaru: '-',
    alasan: 'Karena mau keluar wilayah RT/RW dan pindah ke kota lain.',
  ),
  Mutation(
    id: 2,
    tanggal: '30 September 2025',
    keluarga: 'Keluarga Mara Nunez',
    jenisMutasi: 'Pindah Rumah',
    alamatLama: 'Jalan Anggrek No. 12',
    alamatBaru: 'Jalan Anggrek No. 3A (masih dalam wilayah)',
    alasan: 'Pindah ke rumah yang lebih besar, masih satu wilayah RT.',
  ),
  Mutation(
    id: 3,
    tanggal: '24 Oktober 2026',
    keluarga: 'Keluarga Ijat',
    jenisMutasi: 'Pindah Rumah',
    alamatLama: 'Jalan Melati No. 88',
    alamatBaru: 'Jalan Melati No. 19B (masih dalam wilayah)',
    alasan: 'Renovasi rumah, pindah sementara.',
  ),
];
