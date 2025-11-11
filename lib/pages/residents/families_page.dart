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

    return BaseLayout(
      title: 'Data Keluarga', // AppBar title
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Main content padding
        child: Column(
          children: [
            // White container as the main Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadiusXLarge, // From theme
                boxShadow: AppTheme.shadowMedium, // From theme
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header row with Filter button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        // Filter Button
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, // From theme
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                AppTheme.borderRadiusSmall, // From theme
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      // Tambahkan tombol lain jika perlu (misal: Tambah Keluarga)
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Table
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ), // Min width
                          child: CustomDataTable(
                            headers: headers,
                            rows: rows,
                            sortable: sortable,
                          ),
                        ),
                      );
                    },
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

  // Helper widget untuk nomor halaman pagination (sama seperti sebelumnya)
  Widget _buildPageNumber(int page, bool isActive) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          setState(() {
            _currentPage = page;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: AppTheme.borderRadiusSmall,
          border: isActive ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.textMedium,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
