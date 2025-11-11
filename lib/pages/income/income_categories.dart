import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format angka
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart'; // Import CustomDataTable
import 'package:jawara/shared/theme.dart'; // Import tema

// Dummy data model
class DuesCategory {
  final int no;
  final String nama;
  final String jenis;
  final double nominal;

  DuesCategory({
    required this.no,
    required this.nama,
    required this.jenis,
    required this.nominal,
  });
}

class IncomeCategoriesPage extends StatefulWidget {
  const IncomeCategoriesPage({super.key});

  @override
  State<IncomeCategoriesPage> createState() => _IncomeCategoriesPageState();
}

class _IncomeCategoriesPageState extends State<IncomeCategoriesPage> {
  // Dummy data
  final List<DuesCategory> _categories = [
    DuesCategory(no: 1, nama: 'aaad', jenis: 'Iuran Khusus', nominal: 3000),
    DuesCategory(no: 2, nama: 'yyy', jenis: 'Iuran Bulanan', nominal: 5000),
    DuesCategory(no: 3, nama: 'Harian', jenis: 'Iuran Khusus', nominal: 2),
    DuesCategory(no: 4, nama: 'Kerja Bakti', jenis: 'Iuran Khusus', nominal: 5),
    DuesCategory(
      no: 5,
      nama: 'Bersih Desa',
      jenis: 'Iuran Khusus',
      nominal: 200000,
    ),
    DuesCategory(no: 6, nama: 'Mingguan', jenis: 'Iuran Khusus', nominal: 12),
    DuesCategory(no: 7, nama: 'Agustusan', jenis: 'Iuran Khusus', nominal: 15),
  ];

  @override
  Widget build(BuildContext context) {
    // Define table headers
    final headers = ['NO', 'NAMA IURAN', 'JENIS IURAN', 'NOMINAL', 'AKSI'];
    // Define sortable columns
    final sortable = ['NAMA IURAN', 'JENIS IURAN', 'NOMINAL'];

    // Prepare table rows with formatting
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    final rows = _categories.map((category) {
      return <Widget>[
        Text(category.no.toString()),
        Text(category.nama),
        Text(category.jenis),
        Text(currencyFormatter.format(category.nominal)), // Format nominal
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Kategori Iuran', // AppBar title
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
                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withOpacity(
                        0.1,
                      ), // Warna biru muda
                      borderRadius: AppTheme.borderRadiusMedium,
                      border: Border.all(
                        color: AppTheme.primaryLight.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Info: Iuran Bulanan: Dibayar setiap bulan sekali secara rutin. '
                      'Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu, misalnya iuran untuk acara khusus, renovasi, atau kegiatan lain yang tidak rutin.',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),

                  // Header row with Action buttons
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Tombol di kedua sisi
                    children: [
                      // Tombol kiri (Tambah/Refresh?) - Ganti ikon sesuai kebutuhan
                      ElevatedButton(
                        onPressed: () {
                          // Aksi tombol kiri (misal: Tambah Kategori)
                          Navigator.pushNamed(
                            context,
                            '/income/categories/add',
                          ); // Contoh navigasi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.accentPurple, // Warna berbeda
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadiusSmall,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      // Tombol Filter kanan
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        ), // Tambahkan teks jika perlu
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
                  // Tidak ada pagination di screenshot ini
                  // const SizedBox(height: 16),
                  // Row( ... pagination controls ... ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
