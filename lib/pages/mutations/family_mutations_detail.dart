import 'package:flutter/material.dart';
import 'package:jawara/models/mutations.dart';

class FamilyMutationsDetailPage extends StatelessWidget {
  final Mutation mutation;

  const FamilyMutationsDetailPage({super.key, required this.mutation});

  Color _getMutationTypeColor(String jenisMutasi) {
    if (jenisMutasi.toLowerCase().contains('keluar')) {
      return Colors.red;
    } else if (jenisMutasi.toLowerCase().contains('pindah')) {
      return Colors.green;
    }
    return const Color(0xFF0891B2);
  }

  IconData _getMutationTypeIcon(String jenisMutasi) {
    if (jenisMutasi.toLowerCase().contains('keluar')) {
      return Icons.exit_to_app;
    } else if (jenisMutasi.toLowerCase().contains('pindah')) {
      return Icons.swap_horiz;
    }
    return Icons.change_circle;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getMutationTypeColor(mutation.jenisMutasi);
    final icon = _getMutationTypeIcon(mutation.jenisMutasi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mutasi'),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    mutation.keluarga,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      mutation.jenisMutasi,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Detail Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Mutasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    icon: Icons.family_restroom,
                    label: 'Nama Keluarga',
                    value: mutation.keluarga,
                  ),
                  _buildDetailCard(
                    icon: Icons.category_outlined,
                    label: 'Jenis Mutasi',
                    value: mutation.jenisMutasi,
                  ),
                  _buildDetailCard(
                    icon: Icons.calendar_today,
                    label: 'Tanggal',
                    value: mutation.tanggal,
                  ),
                  _buildDetailCard(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat Asal',
                    value: mutation.alamatLama,
                  ),
                  _buildDetailCard(
                    icon: Icons.location_city_outlined,
                    label: 'Alamat Tujuan',
                    value: mutation.alamatBaru,
                  ),
                  _buildDetailCard(
                    icon: Icons.description_outlined,
                    label: 'Alasan',
                    value: mutation.alasan,
                  ),
                  const SizedBox(height: 24),

                  // Status Section
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: color,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Mutasi',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Diproses',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0891B2), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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
}
