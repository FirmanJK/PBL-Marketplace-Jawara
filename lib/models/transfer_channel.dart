class TransferChannel {
  final int no;
  final String nama;
  final String tipe;
  final String atasNama;
  final String? thumbnailUrl;

  TransferChannel({
    required this.no,
    required this.nama,
    required this.tipe,
    required this.atasNama,
    this.thumbnailUrl,
  });
}