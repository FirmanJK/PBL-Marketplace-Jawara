import 'package:flutter/material.dart';
import 'package:jawara/models/house.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/pages/residents/residents_detail.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:jawara/pages/residents/houses_edit.dart';
import 'package:jawara/services/house_service.dart';

class HouseDetailPage extends StatelessWidget {
  final House house;

  const HouseDetailPage({super.key, required this.house});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Rumah'),
        content: Text(
          'Apakah Anda yakin ingin menghapus rumah di ${house.address ?? '-'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              // perform delete via API
              try {
                await HouseService.deleteHouse(house.id);
                if (!context.mounted) return;
                Navigator.pop(context); // close dialog
                Navigator.pop(context, true); // close detail and signal deletion
                ToastHelper.showSuccess(
                  context,
                  'Rumah di ${house.address ?? '-'} berhasil dihapus',
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context); // close dialog
                ToastHelper.showError(context, 'Gagal menghapus rumah: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ditempati':
        return Colors.blue;
      case 'tersedia':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Rumah'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HousesEditPage(house: house),
                  ),
                ).then((result) {
                  if (result == true) {
                    Navigator.pop(context, true); // signal parent to refresh
                  }
                });
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
                    child: const Icon(
                      Icons.home,
                      size: 60,
                      color: Color(0xFF0891B2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    house.address ?? '-',
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
                      color: _getStatusColor((house.residentCount > 0) ? 'ditempati' : 'tersedia').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (house.residentCount > 0) ? 'Ditempati' : 'Tersedia',
                      style: TextStyle(
                        color: _getStatusColor((house.residentCount > 0) ? 'ditempati' : 'tersedia'),
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
                    'Informasi Rumah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.location_on,
                    label: 'Alamat',
                    value: house.address ?? '-',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.pin_drop,
                    label: 'RT',
                    value: house.rt ?? '-',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.layers,
                    label: 'RW',
                    value: house.rw ?? '-',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.numbers,
                    label: 'Nomor Rumah',
                    value: (house.houseNumber ?? house.id.toString()),
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.info_outline,
                    label: 'Status',
                    value: (house.residentCount > 0) ? 'Ditempati' : 'Tersedia',
                    valueColor: _getStatusColor((house.residentCount > 0) ? 'ditempati' : 'tersedia'),
                  ),
                  const SizedBox(height: 18),

                  if (house.residents != null && house.residents!.isNotEmpty) ...[
                    const Text(
                      'Penghuni',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: house.residents!.map((resident) {
                          return ListTile(
                            title: Text(resident.name),
                            subtitle: Text(resident.nik),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResidentsDetailPage(resident: resident),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
    Color? valueColor,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF1F2937),
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
