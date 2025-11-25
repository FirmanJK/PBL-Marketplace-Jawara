import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';
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
      return Scaffold(
        appBar: StandardAppBar(title: 'Tagihan'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('d MMM yyyy', 'id_ID');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Tagihan',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {},
            tooltip: 'Cetak PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari keluarga, kode tagihan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // List View
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _bills.length,
                itemBuilder: (context, index) {
                  final bill = _bills[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: bill.statusPembayaran == 'Belum Dibayar'
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        child: Icon(
                          Icons.receipt_long,
                          color: bill.statusPembayaran == 'Belum Dibayar'
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      title: Text(
                        bill.namaKeluarga,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${bill.iuran} • ${bill.kodeTagihan}'),
                          const SizedBox(height: 4),
                          Text(
                            '${currencyFormatter.format(bill.nominal)} • ${dateFormatter.format(bill.periode)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildPaymentStatusChip(bill.statusPembayaran),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
