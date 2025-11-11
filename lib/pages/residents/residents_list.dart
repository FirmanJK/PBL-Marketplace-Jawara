import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Tidak perlu format tanggal spesifik di sini
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart'; // Import CustomDataTable
import 'package:jawara/shared/theme.dart'; // Import tema

// Dummy data model untuk halaman ini
class ResidentListItem {
  final int no;
  final String nama;
  final String nik;
  final String keluarga;
  final String jenisKelamin;
  final String statusDomisili; // Aktif, Nonaktif
  final String statusHidup; // Hidup, Wafat

  ResidentListItem({
    required this.no,
    required this.nama,
    required this.nik,
    required this.keluarga,
    required this.jenisKelamin,
    required this.statusDomisili,
    required this.statusHidup,
  });
}

class ResidentsListPage extends StatefulWidget {
  const ResidentsListPage({super.key});

  @override
  State<ResidentsListPage> createState() => _ResidentsListPageState();
}

class _ResidentsListPageState extends State<ResidentsListPage> {
  // Dummy data sesuai screenshot
  final List<ResidentListItem> _residents = [
    ResidentListItem(
      no: 1,
      nama: 'yyyyy',
      nik: '1234567891234567',
      keluarga: 'Keluarga Mara Nunez',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 2,
      nama: 'Varizky Naldiba Rimra',
      nik: '1371111011030005',
      keluarga: 'Keluarga Varizky Naldiba Rimra',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 3,
      nama: 'Tes',
      nik: '2222222222222222',
      keluarga: 'Keluarga Tes',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Wafat',
    ),
    ResidentListItem(
      no: 4,
      nama: 'Farhan',
      nik: '456789086456456',
      keluarga: 'Keluarga Farhan',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 5,
      nama: 'Rendha Putra Rahmadya',
      nik: '3505111512040002',
      keluarga: 'Keluarga Rendha Putra Rahmadya',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 6,
      nama: 'Anti Micin',
      nik: '1234567890987654',
      keluarga: 'Keluarga Anti Micin',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 7,
      nama: 'varizky naldiba rimra',
      nik: '1234123412341234',
      keluarga: 'Keluarga varizky naldiba rimra',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 8,
      nama: 'lalalal',
      nik: '1234567890123456',
      keluarga: 'Keluarga Ijat',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Nonaktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 9,
      nama: 'Ijat',
      nik: '2025202520252025',
      keluarga: 'Keluarga Ijat',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Nonaktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 10,
      nama: 'Raudhil Firdaus Naufal',
      nik: '3201122501050002',
      keluarga: 'Keluarga Raudhil Firdaus Naufal',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    // Tambahkan data lain untuk halaman 2 dst.
    ResidentListItem(
      no: 11,
      nama: 'Warga 11',
      nik: '1111111111111111',
      keluarga: 'Keluarga 11',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 12,
      nama: 'Warga 12',
      nik: '1212121212121212',
      keluarga: 'Keluarga 12',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
  ];

  int _currentPage = 1;
  final int _rowsPerPage = 10; // Jumlah item per halaman

  // Helper widget untuk status chip
  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'aktif':
      case 'hidup':
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'nonaktif':
      case 'wafat':
        chipColor = Colors.grey.shade200; // Warna berbeda untuk nonaktif/wafat
        textColor = Colors.grey.shade700;
        break;
      default:
        chipColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }

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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    // Define table headers
    final headers = [
      'NO',
      'NAMA',
      'NIK',
      'KELUARGA',
      'JENIS KELAMIN',
      'STATUS DOMISILI',
      'STATUS HIDUP',
      'AKSI',
    ];
    // Define sortable columns
    final sortable = [
      'NAMA',
      'NIK',
      'KELUARGA',
      'STATUS DOMISILI',
      'STATUS HIDUP',
    ];

    // Pagination Calculation
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage > _residents.length
        ? _residents.length
        : startIndex + _rowsPerPage;
    final paginatedResidents = _residents.sublist(startIndex, endIndex);
    final totalPages = (_residents.length / _rowsPerPage).ceil();

    final rows = paginatedResidents.map((resident) {
      return <Widget>[
        Text(resident.no.toString()),
        Text(resident.nama),
        Text(resident.nik),
        Text(resident.keluarga),
        Text(resident.jenisKelamin),
        _buildStatusChip(resident.statusDomisili), // Chip
        _buildStatusChip(resident.statusHidup), // Chip
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
          color: Colors.grey.shade600,
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Daftar Warga', // AppBar title
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0), // Responsive padding
        child: Column(
          children: [
            // White container as the main Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
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
                      // Tambahkan tombol lain jika perlu (misal: Tambah Warga)
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
                      if (totalPages >= 2)
                        _buildPageNumber(2, _currentPage == 2),
                      // Ellipsis jika lebih dari 2 halaman
                      if (totalPages > 2)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('...'),
                        ),
                      // Jangan tampilkan nomor terakhir jika hanya ada 2 halaman
                      if (totalPages > 2)
                        _buildPageNumber(
                          totalPages,
                          _currentPage == totalPages,
                        ),

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

  // Helper widget untuk nomor halaman pagination (sama seperti di income_bills.dart)
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
