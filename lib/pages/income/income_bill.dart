import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class IncomeBillPage extends StatefulWidget {
  const IncomeBillPage({super.key});

  @override
  State<IncomeBillPage> createState() => _IncomeBillPageState();
}

class _IncomeBillPageState extends State<IncomeBillPage> {
  // State
  String? _selectedJenisIuran;
  DateTime? _selectedDate;

  // Dummy options for dropdown
  final List<String> _jenisIuranOptions = [
    'Iuran Bulanan',
    'Agustusan',
    'Bersih Desa',
    'Kerja Bakti',
    // Ambil dari data Kategori Iuran nanti
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _selectedJenisIuran = null;
      _selectedDate = null;
    });
  }

  void _submitBill() {
    // Implement bill generation logic here
    debugPrint('Jenis Iuran: $_selectedJenisIuran');
    debugPrint('Tanggal: ${_selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Belum dipilih'}');
    // Panggil fungsi untuk generate tagihan ke semua keluarga aktif
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate != null
        ? DateFormat('dd / MM / yyyy').format(_selectedDate!)
        : '-- / -- / ----';

    return BaseLayout(
      title: 'Tagih Iuran',
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
                'Tagih Iuran ke Semua Keluarga Aktif',
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Jenis Iuran Dropdown
              _buildDropdownField(
                label: 'Jenis Iuran',
                hint: '-- Pilih Jenis Iuran --',
                value: _selectedJenisIuran,
                items: _jenisIuranOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedJenisIuran = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Tanggal Penagihan
              _buildDateField(
                label: 'Tanggal',
                formattedDate: formattedDate,
                onTapIcon: () => _selectDate(context),
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                children: [
                  SizedBox(
                    width: 150, // Sesuaikan lebar jika perlu
                    child: CustomButton(
                      text: 'Tagih Iuran',
                      onPressed: _submitBill,
                      icon: Icons.send_rounded, // Contoh ikon
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

  // --- Helper Widgets ---

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
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
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
        InkWell(
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
                const Icon(Icons.calendar_month_outlined, color: AppTheme.textMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
