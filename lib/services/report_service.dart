import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:jawara/services/database_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ReportService {
  final DatabaseService _db = DatabaseService();

  // Generate financial report PDF
  Future<File> generateFinancialReport({
    required DateTime startDate,
    required DateTime endDate,
    String type = 'all', // 'income', 'spending', 'all'
  }) async {
    final pdf = pw.Document();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

    // Get transactions data
    final transactions = await _db.query(
      'transactions',
      where: 'payment_date >= ? AND payment_date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'payment_date DESC',
    );

    // Filter by type
    final filteredTransactions = transactions.where((t) {
      if (type == 'income') return t['type'] == 'income';
      if (type == 'spending') return t['type'] == 'spending';
      return true;
    }).toList();

    // Calculate totals
    double totalIncome = 0;
    double totalSpending = 0;
    for (var t in filteredTransactions) {
      if (t['type'] == 'income') {
        totalIncome += (t['amount'] as num).toDouble();
      } else {
        totalSpending += (t['amount'] as num).toDouble();
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LAPORAN KEUANGAN',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Periode: ${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Divider(),
              ],
            ),
          ),

          // Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('RINGKASAN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pemasukan:'),
                    pw.Text(
                      currencyFormat.format(totalIncome),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pengeluaran:'),
                    pw.Text(
                      currencyFormat.format(totalSpending),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red),
                    ),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Saldo:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      currencyFormat.format(totalIncome - totalSpending),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: (totalIncome - totalSpending) >= 0 ? PdfColors.green : PdfColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Transaction table
          pw.Text('DETAIL TRANSAKSI', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['Tanggal', 'Deskripsi', 'Kategori', 'Tipe', 'Nominal'],
            data: filteredTransactions.map((t) {
              return [
                DateFormat('dd/MM/yyyy').format(DateTime.parse(t['payment_date'])),
                t['description'] ?? '-',
                t['category'] ?? '-',
                t['type'] == 'income' ? 'Pemasukan' : 'Pengeluaran',
                currencyFormat.format(t['amount']),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(5),
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ),
    );

    // Save to file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/laporan_keuangan_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // Generate resident report PDF
  Future<File> generateResidentReport() async {
    final pdf = pw.Document();
    
    final residents = await _db.query('residents', orderBy: 'name ASC');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LAPORAN DATA WARGA',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Tanggal: ${DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Divider(),
              ],
            ),
          ),

          pw.Text('Total Warga: ${residents.length}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: ['No', 'Nama', 'NIK', 'Jenis Kelamin', 'Status'],
            data: residents.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final r = entry.value;
              return [
                index.toString(),
                r['name'] ?? '-',
                r['nik'] ?? '-',
                r['gender'] ?? '-',
                r['status'] ?? '-',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(5),
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/laporan_warga_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // Print PDF
  Future<void> printPdf(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }

  // Share PDF
  Future<void> sharePdf(File pdfFile) async {
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: pdfFile.path.split('/').last,
    );
  }
}
