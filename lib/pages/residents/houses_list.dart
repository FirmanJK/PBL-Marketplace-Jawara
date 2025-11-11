import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Tidak perlu format khusus di sini
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart'; // Import CustomDataTable
import 'package:jawara/shared/theme.dart'; // Import tema

// Dummy data model
class HouseItem {
  final int no;
  final String alamat;
  final String status; // Ditempati, Tersedia

  HouseItem({required this.no, required this.alamat, required this.status});
}

class HousesListPage extends StatefulWidget {
  const HousesListPage({super.key});

  @override
  State<HousesListPage> createState() => _HousesListPageState();
}

class _HousesListPageState extends State<HousesListPage> {
  // Dummy data sesuai screenshot
  final List<HouseItem> _houses = [
    HouseItem(no: 1, alamat: 'aaaaa', status: 'Ditempati'),
    HouseItem(no: 2, alamat: 'jalan sehat', status: 'Ditempati'),
    HouseItem(no: 3, alamat: 'i', status: 'Ditempati'),
    HouseItem(no: 4, alamat: 'Tes', status: 'Ditempati'),
    HouseItem(no: 5, alamat: 'Jl. Merbabu', status: 'Tersedia'),
    HouseItem(no: 6, alamat: 'Malang', status: 'Ditempati'),
    HouseItem(no: 7, alamat: 'Griyashanta L203', status: 'Ditempati'),
    HouseItem(no: 8, alamat: 'wwrwr', status: 'Tersedia'),
    HouseItem(no: 9, alamat: 'Jl Baru bangun', status: 'Ditempati'),
    HouseItem(no: 10, alamat: 'fasde', status: 'Tersedia'),
    // Tambahkan data lain untuk halaman 2 dst.
    HouseItem(no: 11, alamat: 'Alamat 11', status: 'Ditempati'),
    HouseItem(no: 12, alamat: 'Alamat 12', status: 'Tersedia'),
    HouseItem(no: 13, alamat: 'Alamat 13', status: 'Ditempati'),
    HouseItem(no: 14, alamat: 'Alamat 14', status: 'Ditempati'),
    HouseItem(no: 15, alamat: 'Alamat 15', status: 'Tersedia'),
    HouseItem(no: 16, alamat: 'Alamat 16', status: 'Ditempati'),
    HouseItem(no: 17, alamat: 'Alamat 17', status: 'Ditempati'),
    HouseItem(no: 18, alamat: 'Alamat 18', status: 'Tersedia'),
    HouseItem(no: 19, alamat: 'Alamat 19', status: 'Ditempati'),
    HouseItem(no: 20, alamat: 'Alamat 20', status: 'Ditempati'),
  ];

  int _currentPage = 1;
  final int _rowsPerPage = 10; // Jumlah item per halaman

  // Helper widget untuk status chip
  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'ditempati':
        chipColor = Colors.blue.shade100; // Biru muda
        textColor = Colors.blue.shade800;
        break;
      case 'tersedia':
        chipColor = Colors.green.shade100; // Hijau muda
        textColor = Colors.green.shade800;
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
    // Define table headers
    final headers = ['NO', 'ALAMAT', 'STATUS', 'AKSI'];
    // Define sortable columns
    final sortable = ['ALAMAT', 'STATUS'];

    // Pagination Calculation
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage > _houses.length
        ? _houses.length
        : startIndex + _rowsPerPage;
    final paginatedHouses = _houses.sublist(startIndex, endIndex);
    final totalPages = (_houses.length / _rowsPerPage).ceil();

    final rows = paginatedHouses.map((house) {
      return <Widget>[
        Text(house.no.toString()),
        Text(house.alamat),
        _buildStatusChip(house.status), // Chip
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
          color: Colors.grey.shade600,
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Daftar Rumah', // AppBar title
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
                      // Tambahkan tombol lain jika perlu (misal: Tambah Rumah)
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
