import 'package:flutter/material.dart';

import 'package:jawara/models/resident.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:intl/intl.dart';

class ResidentsDetailPage extends StatelessWidget {
  final Resident resident;

  const ResidentsDetailPage({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Warga'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushNamed(
                  context,
                  '/residents/edit',
                  arguments: resident,
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0891B2).withOpacity(0.1),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0891B2).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: const Color(0xFF0891B2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    resident.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: resident.status == 'aktif'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      resident.status.toUpperCase(),
                      style: TextStyle(
                        color: resident.status == 'aktif'
                            ? Colors.green
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
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
                    'Informasi Pribadi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.badge,
                    label: 'NIK',
                    value: resident.nik,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.phone,
                    label: 'Telepon',
                    value: resident.phone ?? '-',
                  ),
                  const SizedBox(height: 12),

                  if (resident.email != null)
                    _buildInfoCard(
                      icon: Icons.email,
                      label: 'Email',
                      value: resident.email!,
                    ),
                  if (resident.email != null) const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: resident.gender == 'Laki-laki'
                        ? Icons.male
                        : Icons.female,
                    label: 'Jenis Kelamin',
                    value: resident.gender,
                  ),
                  const SizedBox(height: 12),

                  if (resident.birthPlace != null)
                    _buildInfoCard(
                      icon: Icons.location_on,
                      label: 'Tempat Lahir',
                      value: resident.birthPlace!,
                    ),
                  if (resident.birthPlace != null) const SizedBox(height: 12),

                  if (resident.address != null)
                    _buildInfoCard(
                      icon: Icons.home,
                      label: 'Alamat',
                      value: resident.address!,
                    ),
                  if (resident.address != null) const SizedBox(height: 12),

                  if (resident.birthDate != null)
                    _buildInfoCard(
                      icon: Icons.cake,
                      label: 'Tanggal Lahir',
                      value: dateFormat.format(resident.birthDate!),
                    ),
                  if (resident.birthDate != null) const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.app_registration,
                    label: 'Status Registrasi',
                    value: _getRegistrationStatusText(
                      resident.registrationStatus,
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0891B2), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRegistrationStatusText(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.pending:
        return 'Menunggu Persetujuan';
      case RegistrationStatus.accepted:
        return 'Diterima';
      case RegistrationStatus.inactive:
        return 'Tidak Aktif';
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    _deleteResident(context);
  }

  Future<void> _deleteResident(BuildContext context) async {
    try {
      // Delete via API
      await ResidentsService.deleteResident(resident.id);

      // Show success toast
      if (context.mounted) {
        ToastHelper.showSuccess(context, 'Warga berhasil dihapus');
      }

      // Pop back to list page (refresh will happen automatically)
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Show error toast
      if (context.mounted) {
        ToastHelper.showError(context, 'Gagal menghapus warga: $e');
      }
    }
  }
}
