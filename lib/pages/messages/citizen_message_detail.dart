import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/message.dart';

class CitizenMessageDetailPage extends StatelessWidget {
  final CitizenMessage message;
  final bool isSidebarExpanded;

  const CitizenMessageDetailPage({
    super.key,
    required this.message,
    this.isSidebarExpanded = false,
  });

  // Widget pembantu untuk baris detail
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Asumsi sidebar tetap (70.0) saat di halaman detail
    const double sidebarWidth = 70.0;

    // Format tanggal
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan default back button
        title: const Text(
          'Detail Informasi / Aspirasi Warga',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
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
              color: const Color(0xFFF4F7FC),
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
                      width: 700,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tombol Kembali sesuai gambar
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

                          const Text(
                            "Detail Informasi / Aspirasi Warga",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Data Detail
                          _buildDetailRow("Judul", message.title),
                          _buildDetailRow("Deskripsi", message.description),
                          _buildDetailRow("Status", message.statusInIndonesian),
                          _buildDetailRow("Dibuat oleh", message.creatorName),
                          _buildDetailRow(
                            "Tanggal Dibuat",
                            dateFormatter.format(message.createdAt),
                          ),
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
