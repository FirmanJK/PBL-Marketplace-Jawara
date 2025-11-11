import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class ActivitiesAddPage extends StatefulWidget {
  const ActivitiesAddPage({super.key});

  @override
  State<ActivitiesAddPage> createState() => _ActivitiesAddPageState();
}

class _ActivitiesAddPageState extends State<ActivitiesAddPage> {
  // Controllers for text fields
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _pjController = TextEditingController();
  final _deskripsiController = TextEditingController();

  // State for dropdown and date picker
  String? _selectedKategori;
  DateTime? _selectedDate;

  // Dummy list for category dropdown
  final List<String> _kategoriOptions = [
    'Komunitas & Sosial',
    'Kebersihan & Keamanan',
    'Keagamaan',
    'Pendidikan',
    'Kesehatan & Olahraga',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _pjController.dispose();
    _deskripsiController.dispose();
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
      _lokasiController.clear();
      _pjController.clear();
      _deskripsiController.clear();
      _selectedKategori = null;
      _selectedDate = null;
    });
  }

  void _submitForm() {
    // Implement submit logic here
    debugPrint('Nama: ${_namaController.text}');
    debugPrint('Kategori: $_selectedKategori');
    debugPrint('Tanggal: ${_selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Belum dipilih'}');
    debugPrint('Lokasi: ${_lokasiController.text}');
    debugPrint('PJ: ${_pjController.text}');
    debugPrint('Deskripsi: ${_deskripsiController.text}');
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate != null
        ? DateFormat('dd / MM / yyyy').format(_selectedDate!)
        : '-- / -- / ----';

    return BaseLayout(
      title: 'Tambah Kegiatan',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusXLarge, // Menggunakan dari tema
            boxShadow: AppTheme.shadowMedium, // Menggunakan dari tema
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat Kegiatan Baru',
                style: AppTheme.headingMedium, // Menggunakan dari tema
              ),
              const SizedBox(height: 32),

              // Nama Kegiatan
              _buildTextField(
                  label: 'Nama Kegiatan',
                  hint: 'Contoh: Musyawarah Warga',
                  controller: _namaController),
              const SizedBox(height: 24),

              // Kategori Kegiatan
              _buildDropdownField(
                  label: 'Kategori Kegiatan',
                  hint: '-- Pilih Kategori --',
                  value: _selectedKategori,
                  items: _kategoriOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                  }),
              const SizedBox(height: 24),

              // Tanggal
              _buildDateField(
                label: 'Tanggal',
                formattedDate: formattedDate,
                onTapIcon: () => _selectDate(context),
              ),
              const SizedBox(height: 24),

              // Lokasi
              _buildTextField(
                  label: 'Lokasi',
                  hint: 'Contoh: Balai RT 03',
                  controller: _lokasiController),
              const SizedBox(height: 24),

              // Penanggung Jawab
              _buildTextField(
                  label: 'Penanggung Jawab',
                  hint: 'Contoh: Pak RT atau Bu RW',
                  controller: _pjController),
              const SizedBox(height: 24),

              // Deskripsi
              _buildTextArea(
                  label: 'Deskripsi',
                  hint: 'Tuliskan detail event seperti agenda, keperluan, dll.',
                  controller: _deskripsiController),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                children: [
                  SizedBox(
                    width: 120, // Atur lebar tombol jika perlu
                    child: CustomButton(
                      text: 'Submit',
                      onPressed: _submitForm,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text('Reset',
                        style: TextStyle(color: AppTheme.textMedium)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
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

  // Helper widget untuk Text Field
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        // Gunakan CustomInputField jika stylingnya sesuai, atau TextField biasa
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            // Styling lainnya sesuaikan dengan CustomInputField atau desain
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ],
    );
  }

  // Helper widget untuk Dropdown
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
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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

  // Helper widget untuk Date Field
  Widget _buildDateField({
    required String label,
    required String formattedDate,
    required VoidCallback onTapIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
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
                    color: _selectedDate == null
                        ? Colors.grey[400]
                        : AppTheme.textDark),
              ),
              InkWell(
                onTap: onTapIcon,
                child: const Icon(Icons.calendar_month_outlined,
                    color: AppTheme.textMedium),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget untuk Text Area
  Widget _buildTextArea({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 5, // Atur jumlah baris
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ],
    );
  }
}
