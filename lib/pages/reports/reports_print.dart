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
    // Implement PDF generation and download logic here
    debugPrint('Start Date: ${_startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : 'N/A'}');
    debugPrint('End Date: ${_endDate != null ? DateFormat('dd/MM/yyyy').format(_endDate!) : 'N/A'}');
    debugPrint('Report Type: $_selectedReportType');
    // Panggil fungsi generate PDF
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusXLarge,
            boxShadow: AppTheme.shadowMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cetak Laporan Keuangan',
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Input Rentang Tanggal
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Tanggal Mulai',
                      formattedDate: formattedStartDate,
                      onTapIcon: () => _selectDate(context, true), // true for start date
                    ),
                  ),
                  const SizedBox(width: 24), // Spacing between date fields
                  Expanded(
                    child: _buildDateField(
                      label: 'Tanggal Akhir',
                      formattedDate: formattedEndDate,
                      onTapIcon: () => _selectDate(context, false), // false for end date
                    ),
                  ),
                ],
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
              Row(
                children: [
                  SizedBox(
                    // Lebarkan tombol Download sedikit
                    child: CustomButton(
                      text: 'Download PDF',
                      icon: Icons.download_rounded,
                      onPressed: _downloadPdf,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text('Reset', style: TextStyle(color: AppTheme.textMedium)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: formattedDate.startsWith('--') ? Colors.grey[400] : AppTheme.textDark,
                  ),
                ),
                // Icon kalender tetap ada, tapi InkWell di atas menangani tap
                const Icon(Icons.calendar_month_outlined, color: AppTheme.textMedium),
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
