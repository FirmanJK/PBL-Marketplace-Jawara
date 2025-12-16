import 'package:flutter/material.dart';

import 'package:jawara/models/resident.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:intl/intl.dart';

class ResidentsDetailPage extends StatefulWidget {
  final Resident resident;

  const ResidentsDetailPage({super.key, required this.resident});

  @override
  State<ResidentsDetailPage> createState() => _ResidentsDetailPageState();
}

class _ResidentsDetailPageState extends State<ResidentsDetailPage> {
  late Resident currentResident;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentResident = widget.resident;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('Detail Warga'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) async {
              if (value == 'edit') {
                final result = await Navigator.pushNamed(
                  context,
                  '/residents/edit',
                  arguments: currentResident,
                );
                if (result == true && mounted) {
                  _refreshResidentData();
                }
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
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card dengan Status dan Informasi Utama
            _buildHeaderCard(dateFormat),

            // Informasi Pribadi & Kontak
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompactInfoRow(
                    icon: Icons.badge,
                    label: 'NIK',
                    value: currentResident.nik,
                  ),
                  const SizedBox(height: 16),
                  _buildCompactInfoRow(
                    icon: currentResident.gender == 'Laki-laki'
                        ? Icons.male
                        : Icons.female,
                    label: 'Jenis Kelamin',
                    value: currentResident.gender,
                  ),
                  const SizedBox(height: 16),
                  if (currentResident.birthDate != null)
                    _buildCompactInfoRow(
                      icon: Icons.cake,
                      label: 'Tanggal Lahir',
                      value: dateFormat.format(currentResident.birthDate!),
                    ),
                  if (currentResident.birthDate != null)
                    const SizedBox(height: 16),
                  if (currentResident.birthPlace != null)
                    _buildCompactInfoRow(
                      icon: Icons.location_on,
                      label: 'Tempat Lahir',
                      value: currentResident.birthPlace!,
                    ),
                  if (currentResident.birthPlace != null)
                    const SizedBox(height: 16),
                  if (currentResident.religion != null)
                    _buildCompactInfoRow(
                      icon: Icons.temple_buddhist,
                      label: 'Agama',
                      value: currentResident.religion!,
                    ),
                  if (currentResident.religion != null)
                    const SizedBox(height: 16),
                  if (currentResident.bloodType != null)
                    _buildCompactInfoRow(
                      icon: Icons.bloodtype,
                      label: 'Golongan Darah',
                      value: currentResident.bloodType!,
                    ),
                  if (currentResident.bloodType != null)
                    const SizedBox(height: 16),
                  if (currentResident.education != null)
                    _buildCompactInfoRow(
                      icon: Icons.school,
                      label: 'Pendidikan',
                      value: currentResident.education!,
                    ),
                  if (currentResident.education != null)
                    const SizedBox(height: 16),
                  if (currentResident.occupation != null)
                    _buildCompactInfoRow(
                      icon: Icons.work,
                      label: 'Pekerjaan',
                      value: currentResident.occupation!,
                    ),
                  if (currentResident.occupation != null)
                    const SizedBox(height: 16),
                  if (currentResident.phone != null)
                    _buildCompactInfoRow(
                      icon: Icons.phone,
                      label: 'Telepon',
                      value: currentResident.phone!,
                    ),
                  if (currentResident.phone != null) const SizedBox(height: 16),
                  if (currentResident.email != null)
                    _buildCompactInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: currentResident.email!,
                    ),
                  if (currentResident.email != null) const SizedBox(height: 16),
                  if (currentResident.address != null)
                    _buildCompactInfoRow(
                      icon: Icons.home,
                      label: 'Alamat',
                      value: currentResident.address!,
                    ),
                ],
              ),
            ),

            // Status Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatusItem(
                      label: 'Status Warga',
                      value: currentResident.status.toUpperCase(),
                      color: currentResident.status == 'aktif'
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey.shade200),
                  Expanded(
                    child: _buildStatusItem(
                      label: 'Status Registrasi',
                      value: _getRegistrationStatusText(
                        currentResident.registrationStatus,
                      ),
                      color: _getRegistrationStatusColor(
                        currentResident.registrationStatus,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(DateFormat dateFormat) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0891B2).withOpacity(0.08),
            const Color(0xFF06B6D4).withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0891B2).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0891B2).withOpacity(0.25),
                width: 2,
              ),
            ),
            child: const Icon(Icons.person, size: 56, color: Color(0xFF0891B2)),
          ),
          const SizedBox(height: 20),

          // Nama Warga
          Text(
            currentResident.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0891B2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0891B2), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
                maxLines: null,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Color _getStatusBadgeColor(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.pending:
        return Colors.amber.withOpacity(0.1);
      case RegistrationStatus.accepted:
        return Colors.green.withOpacity(0.1);
      case RegistrationStatus.inactive:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getStatusBadgeTextColor(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.pending:
        return Colors.amber[700]!;
      case RegistrationStatus.accepted:
        return Colors.green[700]!;
      case RegistrationStatus.inactive:
        return Colors.grey[700]!;
    }
  }

  Color _getRegistrationStatusColor(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.pending:
        return Colors.amber;
      case RegistrationStatus.accepted:
        return Colors.green;
      case RegistrationStatus.inactive:
        return Colors.grey;
    }
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

  Future<void> _refreshResidentData() async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      final updatedResident = await ResidentsService.getResidentById(
        currentResident.id,
      );

      if (mounted) {
        setState(() {
          currentResident = updatedResident;
          _isLoading = false;
        });
        ToastHelper.showSuccess(context, 'Data berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastHelper.showError(context, 'Gagal refresh data: $e');
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Warning
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Hapus Warga',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Description
                const Text(
                  'Data akan dihapus secara permanen.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Resident Info Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.red[500],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentResident.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            color: Colors.red[500],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'NIK: ${currentResident.nik}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: Color(0xFF0891B2),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteResident(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteResident(BuildContext context) async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      await ResidentsService.deleteResident(currentResident.id);

      if (context.mounted) {
        ToastHelper.showSuccess(context, 'Warga berhasil dihapus');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        setState(() => _isLoading = false);
        ToastHelper.showError(context, 'Gagal menghapus warga: $e');
      }
    }
  }
}
