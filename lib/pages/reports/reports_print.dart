import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class ReportsPrintPage extends StatefulWidget {
  const ReportsPrintPage({super.key});

  @override
  State<ReportsPrintPage> createState() => _ReportsPrintPageState();
}

class _ReportsPrintPageState extends State<ReportsPrintPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedReportType;

  final List<String> _reportTypeOptions = [
    'Semua',
    'Pemasukan',
    'Pengeluaran',
    // Tambahkan jenis laporan lain jika ada
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initial = (isStartDate ? _startDate : _endDate) ?? DateTime.now();
    final DateTime first = DateTime(2000);
    final DateTime last = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _resetForm() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedReportType = null;
    });
  }

  void _downloadPdf() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih rentang tanggal terlebih dahulu')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate PDF generation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan PDF berhasil diunduh'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _printReport() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih rentang tanggal terlebih dahulu')),
      );
      return;
    }

    // Show print dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cetak Laporan'),
        content: const Text('Fitur cetak akan membuka dialog cetak perangkat Anda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka dialog cetak...')),
              );
              // TODO: Implement actual print functionality
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Cetak'),
          ),
        ],
      ),
    );
  }

  void _shareReport() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih rentang tanggal terlebih dahulu')),
      );
      return;
    }

    // Show share options
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Bagikan Laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF0891B2)),
                title: const Text('Email'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka aplikasi email...')),
                  );
                  // TODO: Implement email sharing
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Color(0xFF0891B2)),
                title: const Text('Pesan'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka aplikasi pesan...')),
                  );
                  // TODO: Implement message sharing
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFF0891B2)),
                title: const Text('Lainnya'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka opsi berbagi...')),
                  );
                  // TODO: Implement general sharing
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = _startDate != null
        ? DateFormat('dd / MM / yyyy').format(_startDate!)
        : '-- / -- / ----';
    String formattedEndDate = _endDate != null
        ? DateFormat('dd / MM / yyyy').format(_endDate!)
        : '-- / -- / ----';

    return BaseLayout(
      title: 'Cetak Laporan',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.borderRadiusXLarge,
                  boxShadow: AppTheme.shadowMedium,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Text(
                'Cetak Laporan Keuangan',
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Input Rentang Tanggal
              LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: _buildDateField(
                          label: 'Tanggal Mulai',
                          formattedDate: formattedStartDate,
                          onTapIcon: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: _buildDateField(
                          label: 'Tanggal Akhir',
                          formattedDate: formattedEndDate,
                          onTapIcon: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Input Jenis Laporan
              _buildDropdownField(
                label: 'Jenis Laporan',
                hint: 'Semua', // Default/Hint
                value: _selectedReportType,
                items: _reportTypeOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedReportType = value;
                  });
                },
              ),
                    const SizedBox(height: 32),

                    // Tombol Aksi
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        CustomButton(
                          text: 'Download PDF',
                          icon: Icons.download_rounded,
                          onPressed: _downloadPdf,
                        ),
                        OutlinedButton.icon(
                          onPressed: _printReport,
                          icon: const Icon(Icons.print),
                          label: const Text('Cetak'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0891B2),
                            side: const BorderSide(color: Color(0xFF0891B2)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _shareReport,
                          icon: const Icon(Icons.share),
                          label: const Text('Bagikan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0891B2),
                            side: const BorderSide(color: Color(0xFF0891B2)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: _resetForm,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: const Text('Reset', style: TextStyle(color: AppTheme.textMedium)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper widget untuk Date Field (bisa diambil/dimodifikasi dari ActivitiesAddPage)
  Widget _buildDateField({
    required String label,
    required String formattedDate,
    required VoidCallback onTapIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        InkWell( // Bungkus dengan InkWell agar area teks juga bisa diklik
          onTap: onTapIcon,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: AppTheme.borderRadiusLarge,
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: formattedDate.startsWith('--') ? Colors.grey[400] : AppTheme.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month_outlined, color: AppTheme.textMedium, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

   // Helper widget untuk Dropdown (bisa diambil/dimodifikasi dari ActivitiesAddPage)
   Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppTheme.textDark)), // Hint color
          decoration: InputDecoration(
             border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
             enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
             focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
             filled: true,
            fillColor: Colors.grey[50],
             contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
