class Channel {
  final int id;
  final String nama;
  final String tipe;
  final String atasNama;
  final String? thumbnail;
  final String? nomorAkun;

  Channel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.atasNama,
    this.thumbnail,
    this.nomorAkun,
  });
}
