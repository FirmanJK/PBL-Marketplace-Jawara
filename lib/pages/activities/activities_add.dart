import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/database_service.dart';

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

  Future<void> _submitForm() async {
    // Validasi
    if (_namaController.text.isEmpty) {
      _showError('Nama kegiatan wajib diisi');
      return;
    }
    
    if (_selectedDate == null) {
      _showError('Tanggal kegiatan wajib dipilih');
      return;
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Simpan ke database (untuk sementara gunakan transactions table)
      final dbService = DatabaseService();
      await dbService.insert('transactions', {
        'type': 'activity',
        'category': _selectedKategori ?? 'Lainnya',
        'amount': 0,
        'description': '${_namaController.text}\nLokasi: ${_lokasiController.text}\nPJ: ${_pjController.text}\n${_deskripsiController.text}',
        'payment_date': _selectedDate!.toIso8601String(),
        'status': 'completed',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'synced': 0,
      });

      // Close loading
      if (mounted) Navigator.pop(context);

      // Show success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kegiatan berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Reset form
      _resetForm();

      // Navigate back
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError('Gagal menambahkan kegiatan: ${e.toString()}');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    String formattedDate = _selectedDate != null
        ? DateFormat('dd / MM / yyyy').format(_selectedDate!)
        : '-- / -- / ----';

    return BaseLayout(
      title: 'Tambah Kegiatan',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - (isMobile ? 32.0 : 48.0),
              ),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.borderRadiusXLarge,
                  boxShadow: AppTheme.shadowMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    width: 120,
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
        },
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
