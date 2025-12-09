import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../models/mutations.dart';
import '../../shared/theme.dart';
=======
import 'package:jawara/models/mutations.dart';
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a

class FamilyMutationsDetailPage extends StatelessWidget {
  final Mutation mutation;

  const FamilyMutationsDetailPage({super.key, required this.mutation});

<<<<<<< HEAD
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
=======
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
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
  }

  Color _getMutationTypeColor(String jenisMutasi) {
    if (jenisMutasi.toLowerCase().contains('pindah')) {
      return Colors.orange;
    } else if (jenisMutasi.toLowerCase().contains('datang')) {
      return Colors.green;
    } else if (jenisMutasi.toLowerCase().contains('meninggal')) {
      return Colors.red;
    }
    return AppTheme.primary;
  }

  IconData _getMutationTypeIcon(String jenisMutasi) {
    if (jenisMutasi.toLowerCase().contains('pindah')) {
      return Icons.moving;
    } else if (jenisMutasi.toLowerCase().contains('datang')) {
      return Icons.home_filled;
    } else if (jenisMutasi.toLowerCase().contains('meninggal')) {
      return Icons.person_off;
    }
    return Icons.swap_horiz;
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    const double sidebarWidth = 70.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          Padding(
            padding: EdgeInsets.only(
              left: isMobile ? 0 : sidebarWidth,
              right: isMobile ? 0 : 16.0,
              top: 0,
              bottom: 0,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF4F7FC),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
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
                                size: 20,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Kembali',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Header Card dengan Gradient
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primary,
                                AppTheme.primary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getMutationTypeIcon(mutation.jenisMutasi),
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Detail Mutasi Warga',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          mutation.keluarga,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Info Cards
                        _buildInfoCard(
                          icon: _getMutationTypeIcon(mutation.jenisMutasi),
                          label: 'Jenis Mutasi',
                          value: mutation.jenisMutasi,
                          iconColor: _getMutationTypeColor(mutation.jenisMutasi),
                        ),
                        _buildInfoCard(
                          icon: Icons.calendar_today,
                          label: 'Tanggal Mutasi',
                          value: mutation.tanggal,
                          iconColor: Colors.blue,
                        ),
                        _buildInfoCard(
                          icon: Icons.location_on,
                          label: 'Alamat Lama',
                          value: mutation.alamatLama,
                          iconColor: Colors.red.shade400,
                        ),
                        _buildInfoCard(
                          icon: Icons.home,
                          label: 'Alamat Baru',
                          value: mutation.alamatBaru,
                          iconColor: Colors.green,
                        ),
                        
                        // Alasan Card (lebih besar)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.description,
                                      color: Colors.purple,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Alasan Mutasi',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(left: 56),
                                child: Text(
                                  mutation.alasan,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
=======
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
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
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
