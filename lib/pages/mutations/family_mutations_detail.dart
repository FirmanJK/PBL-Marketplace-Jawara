import 'package:flutter/material.dart';
import '../../models/mutations.dart';

class FamilyMutationsDetailPage extends StatelessWidget {
  final Mutation mutation;

  const FamilyMutationsDetailPage({super.key, required this.mutation});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Asumsi sidebar selalu ditampilkan di sebelah kiri (70.0 jika kecil, dll.)
    // Kita buat layout untuk konten utama di sebelah kanan sidebar
    const double sidebarWidth = 70.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Matikan default back button
        title: const Text(
          'Detail Mutasi Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          // KONTEN UTAMA
          Padding(
            padding: const EdgeInsets.only(
              left: sidebarWidth,
              right: 16.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(
                0xFFF4F7FC,
              ), // Warna background mirip container di list
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      width: 700, // Batasi lebar card untuk desktop-friendly
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tombol Kembali
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Judul Detail
                          const Text(
                            "Detail Mutasi Warga",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Data Detail
                          _buildDetailRow("Keluarga", mutation.keluarga),
                          _buildDetailRow("Jenis Mutasi", mutation.jenisMutasi),
                          _buildDetailRow("Tanggal Mutasi", mutation.tanggal),
                          _buildDetailRow("Alamat Lama", mutation.alamatLama),
                          _buildDetailRow("Alamat Baru", mutation.alamatBaru),
                          _buildDetailRow("Alasan Mutasi", mutation.alasan),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
