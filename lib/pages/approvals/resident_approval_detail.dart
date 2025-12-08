import 'package:flutter/material.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/utils/toast_helper.dart';

class ResidentApprovalDetailPage extends StatelessWidget {
  final Resident resident;

  const ResidentApprovalDetailPage({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan'),
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
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      resident.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF0891B2),
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    resident.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(resident.registrationStatus),
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    icon: Icons.badge_outlined,
                    label: 'NIK',
                    value: resident.nik,
                  ),
                  _buildDetailCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: resident.email ?? '-',
                  ),
                  _buildDetailCard(
                    icon: resident.gender == 'Laki-laki' ? Icons.male : Icons.female,
                    label: 'Jenis Kelamin',
                    value: resident.gender,
                  ),
                  _buildDetailCard(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    value: resident.address ?? '-',
                  ),
                  _buildDetailCard(
                    icon: Icons.info_outline,
                    label: 'Status',
                    value: resident.status,
                  ),
                  const SizedBox(height: 24),

                  // Photo Section
                  const Text(
                    'Foto Identitas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Foto tidak tersedia',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: resident.registrationStatus == RegistrationStatus.pending
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showApprovalDialog(context, false);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showApprovalDialog(context, true);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Terima'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildStatusChip(RegistrationStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case RegistrationStatus.accepted:
        bgColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
        label = 'Diterima';
        break;
      case RegistrationStatus.pending:
        bgColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
        label = 'Pending';
        break;
      case RegistrationStatus.inactive:
        bgColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
        label = 'Nonaktif';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
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

  void _showApprovalDialog(BuildContext context, bool isApprove) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isApprove ? Colors.green : Colors.red).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isApprove ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: isApprove ? Colors.green : Colors.red,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isApprove ? 'Terima Warga?' : 'Tolak Warga?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isApprove
                    ? 'Warga akan diterima dan dapat mengakses sistem'
                    : 'Warga akan ditolak dan tidak dapat mengakses sistem',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context, true);
                        ToastHelper.showSuccess(
                          context,
                          isApprove
                              ? '${resident.name} berhasil diterima'
                              : '${resident.name} berhasil ditolak',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApprove ? Colors.green : Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(isApprove ? 'Terima' : 'Tolak'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
