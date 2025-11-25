import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/models/resident.dart';
import 'package:intl/intl.dart';

class ResidentsDetailPage extends StatelessWidget {
  final Resident resident;

  const ResidentsDetailPage({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Detail Warga',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/residents/edit',
                arguments: resident,
              );
            },
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with photo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0891B2),
                    const Color(0xFF0891B2).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: resident.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              resident.photoUrl!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text(
                            resident.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 48,
                              color: Color(0xFF0891B2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    resident.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      resident.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailCard(
                    'Informasi Pribadi',
                    [
                      _buildDetailRow(Icons.badge, 'NIK', resident.nik),
                      _buildDetailRow(Icons.email, 'Email', resident.email),
                      _buildDetailRow(Icons.phone, 'Telepon', resident.phone ?? '-'),
                      _buildDetailRow(
                        resident.gender == 'Laki-laki' ? Icons.male : Icons.female,
                        'Jenis Kelamin',
                        resident.gender,
                      ),
                      if (resident.birthDate != null)
                        _buildDetailRow(
                          Icons.cake,
                          'Tanggal Lahir',
                          dateFormat.format(resident.birthDate!),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    'Alamat',
                    [
                      _buildDetailRow(Icons.home, 'Alamat', resident.address ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    'Status',
                    [
                      _buildDetailRow(
                        Icons.person,
                        'Status Domisili',
                        resident.status,
                      ),
                      _buildDetailRow(
                        Icons.app_registration,
                        'Status Registrasi',
                        _getRegistrationStatusText(resident.registrationStatus),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0891B2)),
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Warga'),
        content: Text('Apakah Anda yakin ingin menghapus ${resident.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
