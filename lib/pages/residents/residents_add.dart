import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class ResidentsAddPage extends StatefulWidget {
  const ResidentsAddPage({super.key});

  @override
  State<ResidentsAddPage> createState() => _ResidentsAddPageState();
}

class _ResidentsAddPageState extends State<ResidentsAddPage> {
  // Controllers
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();

  // State
  String? _selectedKeluarga;
  DateTime? _selectedTanggalLahir;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolDarah;
  String? _selectedPeran;
  String? _selectedPendidikan;
  String? _selectedPekerjaan;
  String? _selectedStatus; // Status pernikahan?

  // Dummy Options (Ganti dengan data asli/dinamis nanti)
  final List<String> _keluargaOptions = [
    '-- Pilih Keluarga --',
    'Keluarga Mara Nunez',
    'Keluarga Tes',
    'Keluarga Farhan',
    'Keluarga Rendha',
    'Keluarga Anti Micin',
    'Keluarga Varizky',
    'Keluarga Ijat',
    'Keluarga Raudhil',
  ];
  final List<String> _jenisKelaminOptions = [
    '-- Pilih Jenis Kelamin --',
    'Laki-laki',
    'Perempuan',
  ];
  final List<String> _agamaOptions = [
    '-- Pilih Agama --',
    'Islam',
    'Kristen Protestan',
    'Kristen Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  final List<String> _golDarahOptions = [
    '-- Pilih Golongan Darah --',
    'A',
    'B',
    'AB',
    'O',
    'Tidak Tahu',
  ];
  final List<String> _peranOptions = [
    '-- Pilih Peran Keluarga --',
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Lainnya',
  ];
  final List<String> _pendidikanOptions = [
    '-- Pilih Pendidikan Terakhir --',
    'Tidak Sekolah',
    'SD',
    'SMP',
    'SMA/SMK',
    'Diploma',
    'S1',
    'S2',
    'S3',
  ];
  final List<String> _pekerjaanOptions = [
    '-- Pilih Jenis Pekerjaan --',
    'Belum/Tidak Bekerja',
    'Pelajar/Mahasiswa',
    'PNS',
    'TNI/POLRI',
    'Karyawan Swasta',
    'Wiraswasta',
    'Petani',
    'Nelayan',
    'Ibu Rumah Tangga',
    'Pensiunan',
    'Lainnya',
  ];
  final List<String> _statusOptions = [
    '-- Pilih Status --',
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati',
  ]; // Asumsi status pernikahan

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900), // Batas awal tahun lahir
      lastDate: DateTime.now(), // Batas akhir tahun lahir (hari ini)
    );
    if (picked != null && picked != _selectedTanggalLahir) {
      setState(() {
        _selectedTanggalLahir = picked;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _nikController.clear();
      _teleponController.clear();
      _tempatLahirController.clear();
      _selectedKeluarga = null;
      _selectedTanggalLahir = null;
      _selectedJenisKelamin = null;
      _selectedAgama = null;
      _selectedGolDarah = null;
      _selectedPeran = null;
      _selectedPendidikan = null;
      _selectedPekerjaan = null;
      _selectedStatus = null;
    });
  }

  Future<void> _submitForm() async {
    // Validasi form
    if (_namaController.text.isEmpty) {
      ToastHelper.showWarning(context, 'Nama wajib diisi');
      return;
    }

    if (_nikController.text.isEmpty) {
      ToastHelper.showWarning(context, 'NIK wajib diisi');
      return;
    }

    if (_nikController.text.length != 16) {
      ToastHelper.showWarning(context, 'NIK harus 16 digit');
      return;
    }

    if (_selectedJenisKelamin == null ||
        _selectedJenisKelamin == _jenisKelaminOptions[0]) {
      ToastHelper.showWarning(context, 'Jenis kelamin harus dipilih');
      return;
    }

    try {
      // Prepare data untuk API backend
      final data = {
        'nik': _nikController.text,
        'name': _namaController.text,
        'phone': _teleponController.text.isEmpty
            ? null
            : _teleponController.text,
        'birth_place': _tempatLahirController.text.isEmpty
            ? null
            : _tempatLahirController.text,
        'birth_date': _selectedTanggalLahir?.toIso8601String().split('T')[0],
        'gender': _selectedJenisKelamin == _jenisKelaminOptions[0]
            ? null
            : _selectedJenisKelamin,
        'religion': _selectedAgama == _agamaOptions[0] ? null : _selectedAgama,
        'blood_type': _selectedGolDarah == _golDarahOptions[0]
            ? null
            : _selectedGolDarah?.replaceAll('Tidak Tahu', '-'),
        'education': _selectedPendidikan == _pendidikanOptions[0]
            ? null
            : _selectedPendidikan,
        'occupation': _selectedPekerjaan == _pekerjaanOptions[0]
            ? null
            : _selectedPekerjaan,
        'status': 'aktif',
        'family_id': 1,
        'house_id': 1,
      };

      // Create resident via API
      await ResidentsService.createResident(data);

      // Show success toast
      if (mounted) {
        ToastHelper.showSuccess(context, 'Warga berhasil ditambahkan');
      }

      // Navigate back with result
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Show error toast
      if (mounted) {
        ToastHelper.showError(
          context,
          'Gagal menambahkan warga: ${e.toString()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    String formattedDate = _selectedTanggalLahir != null
        ? DateFormat('dd / MM / yyyy').format(_selectedTanggalLahir!)
        : '-- / -- / ----';

    return BaseLayout(
      title: 'Tambah Warga',
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
                      'Tambah Warga', // Judul Form
                      style: AppTheme.headingMedium.copyWith(
                        fontSize: isMobile ? 20 : 24,
                      ),
                    ),
                    SizedBox(height: isMobile ? 24 : 32),

                    // Dropdown Keluarga
                    _buildDropdownField(
                      label: 'Pilih Keluarga',
                      hint: '-- Pilih Keluarga --',
                      value: _selectedKeluarga,
                      items: _keluargaOptions,
                      onChanged: (v) => setState(() => _selectedKeluarga = v),
                    ),
                    const SizedBox(height: 24),

                    // Input Nama
                    _buildTextField(
                      label: 'Nama',
                      hint: 'Masukkan nama lengkap',
                      controller: _namaController,
                    ),
                    const SizedBox(height: 24),

                    // Input NIK
                    _buildTextField(
                      label: 'NIK',
                      hint: 'Masukkan NIK sesuai KTP',
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Input Nomor Telepon
                    _buildTextField(
                      label: 'Nomor Telepon',
                      hint: '08xxxxxxxxxx',
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 24),

                    // Input Tempat Lahir
                    _buildTextField(
                      label: 'Tempat Lahir',
                      hint: 'Masukkan tempat lahir',
                      controller: _tempatLahirController,
                    ),
                    const SizedBox(height: 24),

                    // Input Tanggal Lahir
                    _buildDateField(
                      label: 'Tanggal Lahir',
                      formattedDate: formattedDate,
                      onTapIcon: () => _selectDate(context),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Jenis Kelamin
                    _buildDropdownField(
                      label: 'Jenis Kelamin',
                      hint: '-- Pilih Jenis Kelamin --',
                      value: _selectedJenisKelamin,
                      items: _jenisKelaminOptions,
                      onChanged: (v) =>
                          setState(() => _selectedJenisKelamin = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Agama
                    _buildDropdownField(
                      label: 'Agama',
                      hint: '-- Pilih Agama --',
                      value: _selectedAgama,
                      items: _agamaOptions,
                      onChanged: (v) => setState(() => _selectedAgama = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Golongan Darah
                    _buildDropdownField(
                      label: 'Golongan Darah',
                      hint: '-- Pilih Golongan Darah --',
                      value: _selectedGolDarah,
                      items: _golDarahOptions,
                      onChanged: (v) => setState(() => _selectedGolDarah = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Peran Keluarga
                    _buildDropdownField(
                      label: 'Peran Keluarga',
                      hint: '-- Pilih Peran Keluarga --',
                      value: _selectedPeran,
                      items: _peranOptions,
                      onChanged: (v) => setState(() => _selectedPeran = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Pendidikan Terakhir
                    _buildDropdownField(
                      label: 'Pendidikan Terakhir',
                      hint: '-- Pilih Pendidikan Terakhir --',
                      value: _selectedPendidikan,
                      items: _pendidikanOptions,
                      onChanged: (v) => setState(() => _selectedPendidikan = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Pekerjaan
                    _buildDropdownField(
                      label: 'Pekerjaan',
                      hint: '-- Pilih Jenis Pekerjaan --',
                      value: _selectedPekerjaan,
                      items: _pekerjaanOptions,
                      onChanged: (v) => setState(() => _selectedPekerjaan = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Status
                    _buildDropdownField(
                      label: 'Status',
                      hint: '-- Pilih Status --',
                      value: _selectedStatus,
                      items: _statusOptions,
                      onChanged: (v) => setState(() => _selectedStatus = v),
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
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: AppTheme.textMedium),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
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

  // --- Helper Widgets (Bisa disalin dari file lain atau dibuat baru) ---

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            counterText: "", // Hide the default counter
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
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
                    color: formattedDate.startsWith('--')
                        ? Colors.grey[400]
                        : AppTheme.textDark,
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppTheme.textMedium,
                ),
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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          isExpanded: true,
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item == hint ? null : item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == hint ? Colors.grey[400] : AppTheme.textDark,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          menuMaxHeight: 200,
          icon: const Icon(Icons.arrow_drop_down, size: 24),
        ),
      ],
    );
  }
}
