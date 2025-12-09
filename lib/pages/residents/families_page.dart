import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Tidak perlu format khusus di sini
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart'; // Import CustomDataTable
import 'package:jawara/shared/theme.dart'; // Import tema

// Dummy data model
class FamilyItem {
  final int no;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan; // Pemilik, Penyewa
  final String status; // Aktif, Nonaktif

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
  // Dummy data sesuai screenshot
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
    FamilyItem(
      no: 6,
      namaKeluarga: 'Keluarga varizky naldiba rimra',
      kepalaKeluarga: 'varizky naldiba rimra',
      alamatRumah: 'i',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 7,
      namaKeluarga: 'Keluarga Ijat',
      kepalaKeluarga: 'Ijat',
      alamatRumah: 'Keluar Wilayah',
      statusKepemilikan: 'Penyewa',
      status: 'Nonaktif',
    ),
    FamilyItem(
      no: 8,
      namaKeluarga: 'Keluarga Raudhil Firdaus Naufal',
      kepalaKeluarga: 'Raudhil Firdaus Naufal',
      alamatRumah: 'Bogor Raya Permai FJ 2 no 11',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 9,
      namaKeluarga: 'Keluarga Mara Nunez',
      kepalaKeluarga: 'Mara Nunez',
      alamatRumah: 'malang',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    FamilyItem(
      no: 10,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      kepalaKeluarga: 'Habibie Ed Dien',
      alamatRumah: 'Blok A49',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    // Tambahkan data lain jika perlu
  ];

  int _currentPage = 1;
  final int _rowsPerPage = 10; // Sesuaikan jika perlu

  // Helper widget untuk status chip
  Widget _buildStatusChip(String status) {
    bool isActive = status.toLowerCase() == 'aktif';
    Color chipColor = isActive
        ? Colors.green.shade100
        : Colors.red.shade100; // Merah untuk Nonaktif
    Color textColor = isActive ? Colors.green.shade800 : Colors.red.shade800;

    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define table headers
    final headers = [
      'NO',
      'NAMA KELUARGA',
      'KEPALA KELUARGA',
      'ALAMAT RUMAH',
      'STATUS KEPEMILIKAN',
      'STATUS',
      'AKSI',
    ];
    // Define sortable columns
    final sortable = [
      'NAMA KELUARGA',
      'KEPALA KELUARGA',
      'ALAMAT RUMAH',
      'STATUS KEPEMILIKAN',
      'STATUS',
    ];

    // Pagination Calculation
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage > _families.length
        ? _families.length
        : startIndex + _rowsPerPage;
    final paginatedFamilies = _families.sublist(startIndex, endIndex);
    final totalPages = (_families.length / _rowsPerPage).ceil();

    final rows = paginatedFamilies.map((family) {
      return <Widget>[
        Text(family.no.toString()),
        Text(family.namaKeluarga),
        Text(family.kepalaKeluarga),
        Text(family.alamatRumah),
        Text(family.statusKepemilikan),
        _buildStatusChip(family.status), // Chip
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
          color: Colors.grey.shade600,
        ),
      ];
    }).toList();
  }

  void _showAddFamilyForm(BuildContext context) {
    final parentContext = context;
    final namaKeluargaController = TextEditingController();
    final kepalaKeluargaController = TextEditingController();
    final alamatController = TextEditingController();
    String? selectedStatus = 'Pemilik';

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SizedBox(
          width: MediaQuery.of(parentContext).size.width - 40,
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
                          Color.fromRGBO(8, 145, 178, 0.8),
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
                        color: Color.fromRGBO(255, 255, 255, 0.2),
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
                        initialValue: selectedStatus,
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
                  const SizedBox(height: 16),

                  // Pagination Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPage > 1
                            ? () => setState(() => _currentPage--)
                            : null,
                        tooltip: 'Halaman Sebelumnya',
                        color: _currentPage > 1
                            ? AppTheme.primary
                            : Colors.grey[300], // Warna disable
                      ),
                      // Tampilkan nomor halaman
                      _buildPageNumber(1, _currentPage == 1),
                      // Ellipsis jika lebih dari 1 halaman (sesuaikan logic jika perlu halaman 2, dst.)
                      if (totalPages > 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('...'), // Placeholder
                        ),
                      if (totalPages > 1)
                        _buildPageNumber(
                          totalPages,
                          _currentPage == totalPages,
                        ), // Halaman terakhir

                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPage < totalPages
                            ? () => setState(() => _currentPage++)
                            : null,
                        tooltip: 'Halaman Berikutnya',
                        color: _currentPage < totalPages
                            ? AppTheme.primary
                            : Colors.grey[300], // Warna disable
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

  // ignore: unused_element
  void _showFamilyDetail(BuildContext context, Family family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(family.namaKeluarga),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kepala Keluarga', family.headResidentId != null ? '#${family.headResidentId}' : '-'),
            const SizedBox(height: 8),
            _buildDetailRow('Jumlah Anggota', '${family.residentCount}'),
            const SizedBox(height: 8),
            _buildDetailRow('Dibuat', family.createdAt != null ? family.createdAt!.toLocal().toString().split(' ').first : '-'),
            const SizedBox(height: 8),
            _buildDetailRow('Terakhir diperbarui', family.updatedAt != null ? family.updatedAt!.toLocal().toString().split(' ').first : '-'),
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
  void _showEditFamilyForm(BuildContext context, Family family) {
    final parentContext = context;
    final namaKeluargaController = TextEditingController(
      text: family.namaKeluarga,
    );
    final kepalaKeluargaController = TextEditingController(
      text: family.headResidentId != null ? '${family.headResidentId}' : '',
    );
    final alamatController = TextEditingController(text: '');
    String? selectedStatus = 'Pemilik';

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
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
                initialValue: selectedStatus,
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
                        onPressed: () => Navigator.of(parentContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newNumber = namaKeluargaController.text.trim();
              if (newNumber.isEmpty) {
                ToastHelper.showWarning(parentContext, 'Nomor keluarga tidak boleh kosong');
                return;
              }

                          try {
                            await FamiliesService.updateFamily(family.id, {'family_number': newNumber});
                            if (!mounted) return;
                            Navigator.of(parentContext).pop();
                            ToastHelper.showSuccess(parentContext, 'Keluarga berhasil diperbarui');
                            if (!mounted) return;
                            await _loadFamilies();
                          } catch (e) {
                            if (!mounted) return;
                            ToastHelper.showError(parentContext, 'Gagal memperbarui keluarga: $e');
                          }
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
  void _showDeleteConfirmation(BuildContext context, Family family) {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Keluarga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${family.namaKeluarga}?',
        ),
        actions: [
          TextButton(
                        onPressed: () => Navigator.of(parentContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
                            try {
                              await FamiliesService.deleteFamily(family.id);
                              if (!mounted) return;
                              Navigator.of(parentContext).pop();
                              ToastHelper.showSuccess(
                                parentContext,
                                '${family.namaKeluarga} berhasil dihapus',
                              );
                              if (!mounted) return;
                              await _loadFamilies();
                            } catch (e) {
                              if (!mounted) return;
                              Navigator.of(parentContext).pop();
                              ToastHelper.showError(parentContext, 'Gagal menghapus keluarga: $e');
                            }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}