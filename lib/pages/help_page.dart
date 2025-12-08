import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Bantuan',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Support Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0891B2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.support_agent,
                          color: Color(0xFF0891B2),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hubungi Kami',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Tim support siap membantu Anda',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildContactItem(
                    Icons.email,
                    'Email',
                    'support@jawara.com',
                    const Color(0xFF0891B2),
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    Icons.phone,
                    'Telepon',
                    '+62 812-3456-7890',
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    Icons.chat,
                    'WhatsApp',
                    '+62 812-3456-7890',
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    Icons.language,
                    'Website',
                    'www.jawara.com',
                    const Color(0xFF3B82F6),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Operating Hours
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Color(0xFFF59E0B),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Jam Operasional',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleItem('Senin - Jumat', '08.00 - 17.00 WIB'),
                  _buildScheduleItem('Sabtu', '08.00 - 12.00 WIB'),
                  _buildScheduleItem('Minggu & Libur', 'Tutup'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // FAQ Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Color(0xFF8B5CF6),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Pertanyaan Umum (FAQ)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildFAQItem(
                    'Bagaimana cara menambah warga baru?',
                    'Buka menu Data Warga > Tambah Warga, lalu isi formulir yang tersedia.',
                  ),
                  _buildFAQItem(
                    'Bagaimana cara mencatat pemasukan?',
                    'Buka menu Keuangan > Pemasukan > Tambah Pemasukan, lalu isi detail transaksi.',
                  ),
                  _buildFAQItem(
                    'Bagaimana cara membuat broadcast?',
                    'Buka menu Kegiatan > Broadcast > Tambah Broadcast, lalu tulis pesan yang ingin dikirim.',
                  ),
                  _buildFAQItem(
                    'Bagaimana cara melihat laporan keuangan?',
                    'Buka menu Laporan, pilih jenis laporan (Pemasukan/Pengeluaran), lalu pilih periode yang diinginkan.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
