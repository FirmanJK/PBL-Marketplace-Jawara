import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk InputFormatter
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class SpendingAddPage extends StatefulWidget {
  const SpendingAddPage({super.key});

  @override
  State<SpendingAddPage> createState() => _SpendingAddPageState();
}

class _SpendingAddPageState extends State<SpendingAddPage> {
  // Controllers
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();

  // State
  DateTime? _selectedDate;
  String? _selectedKategori;
  String _buktiFileName = 'Belum ada file dipilih'; // Placeholder

  // Options for dropdown
  final List<String> _kategoriOptions = [
    'Pemeliharaan Fasilitas',
    'Kegiatan Warga',
    'Operasional RT/RW',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  // Function to show date picker
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
      _namaController.clear();
      _nominalController.clear();
      _selectedDate = null;
      _selectedKategori = null;
      _buktiFileName = 'Belum ada file dipilih';
    });
  }

  void _submitForm() {
    // Implement submit logic here
    debugPrint('Nama: ${_namaController.text}');
    debugPrint('Tanggal: ${_selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Belum dipilih'}');
    debugPrint('Kategori: $_selectedKategori');
    debugPrint('Nominal: ${_nominalController.text}');
    debugPrint('Bukti: $_buktiFileName');
    // Nanti tambahkan logika simpan data dan upload file
  }

  // Placeholder function for picking files
  void _pickBukti() {
    // Implement file picking logic for images
    setState(() {
      _buktiFileName = 'bukti_pengeluaran.jpg'; // Dummy name
    });
    debugPrint('Memilih bukti...');
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate != null
        ? DateFormat('dd / MM / yyyy').format(_selectedDate!)
        : '-- / -- / ----';

    return BaseLayout(
      title: 'Tambah Pengeluaran',
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
                'Buat Pengeluaran Baru',
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Nama Pengeluaran
              _buildTextField(
                label: 'Nama Pengeluaran',
                hint: 'Masukkan nama pengeluaran',
                controller: _namaController,
              ),
              const SizedBox(height: 24),

              // Tanggal Pengeluaran
              _buildDateField(
                label: 'Tanggal Pengeluaran',
                formattedDate: formattedDate,
                onTapIcon: () => _selectDate(context),
              ),
              const SizedBox(height: 24),

              // Kategori Pengeluaran
              _buildDropdownField(
                label: 'Kategori Pengeluaran',
                hint: '-- Pilih Kategori --',
                value: _selectedKategori,
                items: _kategoriOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Nominal
              _buildTextField(
                label: 'Nominal',
                hint: 'Masukkan jumlah nominal',
                controller: _nominalController,
                keyboardType: TextInputType.number,
                // Optional: Tambahkan input formatter untuk angka/mata uang
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),

              // Bukti Pengeluaran
              _buildFileUploadSection(
                label: 'Bukti Pengeluaran',
                // Description from screenshot is implicit in button text
                // description: 'Maksimal 1 file (.png / .jpg), ukuran maksimal 5MB.',
                fileName: _buktiFileName,
                onTapUpload: _pickBukti,
                uploadButtonText: 'Upload bukti pengeluaran (.png/.jpg)',
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomButton(
                      text: 'Submit',
                      onPressed: _submitForm,
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

  // --- Helper Widgets (Bisa diletakkan di bawah atau di file terpisah) ---

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
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
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])), // Hint color lighter
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

   Widget _buildFileUploadSection({
    required String label,
    String? description, // Optional description
    required String fileName,
    required VoidCallback onTapUpload,
    required String uploadButtonText,
  }) {
    bool fileChosen = !fileName.startsWith('Belum');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        if (description != null)...[
            const SizedBox(height: 4),
            Text(description, style: AppTheme.bodySmall.copyWith(color: AppTheme.textLight)),
        ],
        const SizedBox(height: 12),
        InkWell( // Make the whole area clickable
          onTap: onTapUpload,
          child: Container(
            width: double.infinity, // Fill width
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), // More vertical padding
            decoration: BoxDecoration(
              color: Colors.grey[100], // Lighter background
              borderRadius: AppTheme.borderRadiusLarge,
              border: Border.all(color: AppTheme.border), // Dashed border might need custom painter or package
            ),
            child: Column( // Center content
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file_outlined, color: AppTheme.textMedium, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    uploadButtonText,
                    style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fileName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: fileChosen ? Colors.green.shade700 : AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }
}
