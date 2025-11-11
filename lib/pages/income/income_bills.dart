import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart';
import 'package:jawara/shared/theme.dart';

class BillItem {
  final int no;
  final String namaKeluarga;
  final String statusKeluarga;
  final String iuran;
  final String kodeTagihan;
  final double nominal;
  final DateTime periode;
  final String statusPembayaran;

  BillItem({
    required this.no,
    required this.namaKeluarga,
    required this.statusKeluarga,
    required this.iuran,
    required this.kodeTagihan,
    required this.nominal,
    required this.periode,
    required this.statusPembayaran,
  });
}

class IncomeBillsPage extends StatefulWidget {
  const IncomeBillsPage({super.key});

  @override
  State<IncomeBillsPage> createState() => _IncomeBillsPageState();
}

class _IncomeBillsPageState extends State<IncomeBillsPage> {
  bool _isLocaleInitialized = false;

  final List<BillItem> _bills = [
    BillItem(
      no: 1,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      statusKeluarga: 'Aktif',
      iuran: 'Mingguan',
      kodeTagihan: 'IR175458AS01',
      nominal: 10000,
      periode: DateTime(2025, 10, 8),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 2,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      statusKeluarga: 'Aktif',
      iuran: 'Mingguan',
      kodeTagihan: 'IR185702KX01',
      nominal: 10000,
      periode: DateTime(2025, 10, 15),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 3,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      statusKeluarga: 'Aktif',
      iuran: 'Mingguan',
      kodeTagihan: 'IR223936NM01',
      nominal: 10000,
      periode: DateTime(2025, 9, 30),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 4,
      namaKeluarga: 'Keluarga Mara Nunez',
      statusKeluarga: 'Aktif',
      iuran: 'Mingguan',
      kodeTagihan: 'IR223936ZJ02',
      nominal: 10000,
      periode: DateTime(2025, 9, 30),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 5,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      statusKeluarga: 'Aktif',
      iuran: 'Agustusan',
      kodeTagihan: 'IR2244089O01',
      nominal: 15000,
      periode: DateTime(2025, 10, 10),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 6,
      namaKeluarga: 'Keluarga Mara Nunez',
      statusKeluarga: 'Aktif',
      iuran: 'Agustusan',
      kodeTagihan: 'IR2244068C02',
      nominal: 15000,
      periode: DateTime(2025, 10, 10),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 7,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      statusKeluarga: 'Aktif',
      iuran: 'Agustusan',
      kodeTagihan: 'IR224432PP01',
      nominal: 15000,
      periode: DateTime(2025, 9, 30),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 8,
      namaKeluarga: 'Keluarga Mara Nunez',
      statusKeluarga: 'Aktif',
      iuran: 'Agustusan',
      kodeTagihan: 'IR224432KE02',
      nominal: 15000,
      periode: DateTime(2025, 9, 30),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 9,
      namaKeluarga: 'Keluarga Habibie Ed Dien',
      statusKeluarga: 'Aktif',
      iuran: 'Mingguan',
      kodeTagihan: 'IR121530BS01',
      nominal: 10000,
      periode: DateTime(2025, 10, 9),
      statusPembayaran: 'Belum Dibayar',
    ),
    BillItem(
      no: 10,
      namaKeluarga: 'Keluarga Mara Nunez',
      statusKeluarga: 'Aktif',
      iuran: 'Mingguan',
      kodeTagihan: 'IR121530VV02',
      nominal: 10000,
      periode: DateTime(2025, 10, 9),
      statusPembayaran: 'Belum Dibayar',
    ),
  ];

  int _currentPage = 1;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    setState(() {
      _isLocaleInitialized = true;
    });
  }

  Widget _buildFamilyStatusChip(String status) {
    Color chipColor = status.toLowerCase() == 'aktif'
        ? Colors.green.shade100
        : Colors.grey.shade100;
    Color textColor = status.toLowerCase() == 'aktif'
        ? Colors.green.shade800
        : Colors.grey.shade800;
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

  Widget _buildPaymentStatusChip(String status) {
    Color chipColor;
    Color textColor;
    if (status.toLowerCase() == 'belum dibayar') {
      chipColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else if (status.toLowerCase() == 'lunas') {
      chipColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else {
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
    if (!_isLocaleInitialized) {
      return const BaseLayout(
        title: 'Daftar Tagihan',
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final headers = [
      'NO',
      'NAMA KELUARGA',
      'STATUS KELUARGA',
      'IURAN',
      'KODE TAGIHAN',
      'NOMINAL',
      'PERIODE',
      'STATUS', // Baru
      'AKSI', // Baru
    ];
    // Define sortable columns - Ditambah STATUS
    final sortable = [
      'NAMA KELUARGA',
      'STATUS KELUARGA',
      'IURAN',
      'NOMINAL',
      'PERIODE',
      'STATUS',
    ];

    // Formatting
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    // Pagination Calculation
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage > _bills.length
        ? _bills.length
        : startIndex + _rowsPerPage;
    final paginatedBills = _bills.sublist(startIndex, endIndex);
    final totalPages = (_bills.length / _rowsPerPage).ceil();

    final rows = paginatedBills.map((bill) {
      return <Widget>[
        Text(bill.no.toString()),
        Text(bill.namaKeluarga),
        _buildFamilyStatusChip(bill.statusKeluarga), // Chip status keluarga
        Text(bill.iuran),
        Text(bill.kodeTagihan),
        Text(currencyFormatter.format(bill.nominal)), // Format nominal
        Text(dateFormatter.format(bill.periode)), // Format tanggal
        _buildPaymentStatusChip(
          bill.statusPembayaran,
        ), // Chip status pembayaran
        IconButton(
          // Aksi ditambahkan kembali
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
          color: Colors.grey.shade600,
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Tagihan', // AppBar title
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
                  // Header row with Filter and Cetak PDF buttons
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
                      const SizedBox(width: 12), // Spasi antar tombol
                      ElevatedButton.icon(
                        // Cetak PDF Button
                        onPressed: () {
                          /* Logic Cetak PDF */
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Cetak PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.primaryLight, // Warna berbeda
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
                  const SizedBox(height: 16),

                  // Pagination Controls - Diperbarui
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
                      // Halaman 1
                      _buildPageNumber(1, _currentPage == 1),
                      // Halaman 2
                      if (totalPages >= 2)
                        _buildPageNumber(2, _currentPage == 2),

                      // Ellipsis dan Halaman Terakhir
                      if (totalPages > 2) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('...'),
                        ),
                        _buildPageNumber(
                          totalPages,
                          _currentPage == totalPages,
                        ),
                      ],

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

  // Helper widget BARU untuk nomor halaman pagination
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
