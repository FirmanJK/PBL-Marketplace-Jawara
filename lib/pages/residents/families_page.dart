import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/residents/family_detail.dart';
import 'package:jawara/utils/toast_helper.dart';

class FamilyItem {
  final int no;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan;
  final String status;

  FamilyItem({
    required this.no,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikan,
    required this.status,
  });
}

class FamiliesPage extends StatefulWidget {
  const FamiliesPage({super.key});

  @override
  State<FamiliesPage> createState() => _FamiliesPageState();
}

class _FamiliesPageState extends State<FamiliesPage> {
  final List<FamilyItem> _families = [
    FamilyItem(
      no: 1,
      namaKeluarga: 'Keluarga Varizky Naldiba Rimra',
      kepalaKeluarga: 'Varizky Naldiba Rimra',
      alamatRumah: 'i',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 2,
      namaKeluarga: 'Keluarga Tes',
      kepalaKeluarga: 'Tes',
      alamatRumah: 'tes',
      statusKepemilikan: 'Penyewa',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 3,
      namaKeluarga: 'Keluarga Farhan',
      kepalaKeluarga: 'Farhan',
      alamatRumah: 'Griyashanta L203',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 4,
      namaKeluarga: 'Keluarga Rendha Putra Rahmadya',
      kepalaKeluarga: 'Rendha Putra Rahmadya',
      alamatRumah: 'Malang',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 5,
      namaKeluarga: 'Keluarga Anti Micin',
      kepalaKeluarga: 'Anti Micin',
      alamatRumah: 'malang',
      statusKepemilikan: 'Penyewa',
      status: 'Aktif',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Data Keluarga'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari keluarga...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _families.length,
              itemBuilder: (context, index) {
                final family = _families[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FamilyDetailPage(family: family),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(
                              0xFF0891B2,
                            ).withOpacity(0.1),
                            child: const Icon(
                              Icons.family_restroom,
                              color: Color(0xFF0891B2),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  family.namaKeluarga,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  family.kepalaKeluarga,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        family.alamatRumah,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: family.status == 'Aktif'
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        family.status,
                                        style: TextStyle(
                                          color: family.status == 'Aktif'
                                              ? Colors.green
                                              : Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        family.statusKepemilikan,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFamilyForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Keluarga'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  void _showAddFamilyForm(BuildContext context) {
    final namaKeluargaController = TextEditingController();
    final kepalaKeluargaController = TextEditingController();
    final alamatController = TextEditingController();
    String? selectedStatus = 'Pemilik';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0891B2),
                      const Color(0xFF0891B2).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.family_restroom,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tambah Keluarga',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: namaKeluargaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Keluarga',
                          hintText: 'Masukkan nama keluarga',
                          prefixIcon: const Icon(
                            Icons.people,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: kepalaKeluargaController,
                        decoration: InputDecoration(
                          labelText: 'Kepala Keluarga',
                          hintText: 'Masukkan nama kepala keluarga',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat Rumah',
                          hintText: 'Masukkan alamat lengkap',
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status Kepemilikan',
                          prefixIcon: const Icon(
                            Icons.home,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: ['Pemilik', 'Penyewa'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          selectedStatus = newValue;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (namaKeluargaController.text.isNotEmpty &&
                            kepalaKeluargaController.text.isNotEmpty) {
                          Navigator.pop(context);
                          ToastHelper.showSuccess(
                            context,
                            'Keluarga berhasil ditambahkan',
                          );
                        } else {
                          ToastHelper.showWarning(
                            context,
                            'Mohon lengkapi data keluarga',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  void _showFamilyDetail(BuildContext context, FamilyItem family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(family.namaKeluarga),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kepala Keluarga', family.kepalaKeluarga),
            const SizedBox(height: 8),
            _buildDetailRow('Alamat', family.alamatRumah),
            const SizedBox(height: 8),
            _buildDetailRow('Status Kepemilikan', family.statusKepemilikan),
            const SizedBox(height: 8),
            _buildDetailRow('Status', family.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Text(': '),
        Expanded(child: Text(value)),
      ],
    );
  }

  // ignore: unused_element
  void _showEditFamilyForm(BuildContext context, FamilyItem family) {
    final namaKeluargaController = TextEditingController(
      text: family.namaKeluarga,
    );
    final kepalaKeluargaController = TextEditingController(
      text: family.kepalaKeluarga,
    );
    final alamatController = TextEditingController(text: family.alamatRumah);
    String? selectedStatus = family.statusKepemilikan;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Keluarga'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaKeluargaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Keluarga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: kepalaKeluargaController,
                decoration: const InputDecoration(
                  labelText: 'Kepala Keluarga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Rumah',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Kepemilikan',
                  border: OutlineInputBorder(),
                ),
                items: ['Pemilik', 'Penyewa'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedStatus = newValue;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update database
              Navigator.pop(context);
              ToastHelper.showSuccess(context, 'Keluarga berhasil diperbarui');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0891B2),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showDeleteConfirmation(BuildContext context, FamilyItem family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Keluarga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${family.namaKeluarga}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete from database
              Navigator.pop(context);
              ToastHelper.showSuccess(
                context,
                '${family.namaKeluarga} berhasil dihapus',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
