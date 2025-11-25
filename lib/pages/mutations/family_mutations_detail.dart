import 'package:flutter/material.dart';
import '../../models/mutations.dart';
import '../../shared/theme.dart';

class FamilyMutationsDetailPage extends StatelessWidget {
  final Mutation mutation;

  const FamilyMutationsDetailPage({super.key, required this.mutation});

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
