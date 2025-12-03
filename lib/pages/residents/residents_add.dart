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
  final _pendidikanController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  // State
  int? _selectedFamilyId;
  DateTime? _selectedTanggalLahir;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolDarah;

  // Data dari backend
  List<Map<String, dynamic>> _families = [];
  bool _isLoadingFamilies = false;

  // Static options (sesuai backend schema validasi)
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Khonghucu',
    'Lainnya',
  ];
  final List<String> _golDarahOptions = ['A', 'B', 'AB', 'O', '-'];

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    _pendidikanController.dispose();
    _pekerjaanController.dispose();
    super.dispose();
  }

  Future<void> _loadFamilies() async {
    setState(() => _isLoadingFamilies = true);
    try {
      final families = await ResidentsService.getFamilies();
      setState(() {
        _families = families
            .map(
              (f) => {
                'id': f['id'],
                'name': f['family_number'] ?? 'Keluarga ${f['id']}',
              },
            )
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal load keluarga: $e');
      }
    } finally {
      setState(() => _isLoadingFamilies = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
      _pendidikanController.clear();
      _pekerjaanController.clear();
      _selectedFamilyId = null;
      _selectedTanggalLahir = null;
      _selectedJenisKelamin = null;
      _selectedAgama = null;
      _selectedGolDarah = null;
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

    if (_selectedJenisKelamin == null) {
      ToastHelper.showWarning(context, 'Jenis kelamin harus dipilih');
      return;
    }

    if (_selectedFamilyId == null) {
      ToastHelper.showWarning(context, 'Keluarga harus dipilih');
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
        'gender': _selectedJenisKelamin,
        'religion': _selectedAgama,
        'blood_type': _selectedGolDarah,
        'education': _pendidikanController.text.isEmpty
            ? null
            : _pendidikanController.text,
        'occupation': _pekerjaanController.text.isEmpty
            ? null
            : _pekerjaanController.text,
        'status': 'aktif',
        'family_id': _selectedFamilyId,
        'house_id': 1, // TODO: Load dari backend
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
                      'Tambah Warga',
                      style: AppTheme.headingMedium.copyWith(
                        fontSize: isMobile ? 20 : 24,
                      ),
                    ),
                    SizedBox(height: isMobile ? 24 : 32),

                    // Dropdown Keluarga (Dinamis dari backend)
                    _buildFamilyDropdown(),
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
                      hint: 'Pilih jenis kelamin',
                      value: _selectedJenisKelamin,
                      items: _jenisKelaminOptions,
                      onChanged: (v) =>
                          setState(() => _selectedJenisKelamin = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Agama
                    _buildDropdownField(
                      label: 'Agama',
                      hint: 'Pilih agama',
                      value: _selectedAgama,
                      items: _agamaOptions,
                      onChanged: (v) => setState(() => _selectedAgama = v),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Golongan Darah
                    _buildDropdownField(
                      label: 'Golongan Darah',
                      hint: 'Pilih golongan darah',
                      value: _selectedGolDarah,
                      items: _golDarahOptions,
                      onChanged: (v) => setState(() => _selectedGolDarah = v),
                    ),
                    const SizedBox(height: 24),

                    // Input Pendidikan Terakhir
                    _buildTextField(
                      label: 'Pendidikan Terakhir',
                      hint: 'Contoh: SMA, S1, Diploma',
                      controller: _pendidikanController,
                    ),
                    const SizedBox(height: 24),

                    // Input Pekerjaan
                    _buildTextField(
                      label: 'Pekerjaan',
                      hint: 'Contoh: Karyawan Swasta, Petani',
                      controller: _pekerjaanController,
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

  // --- Helper Widgets ---

  Widget _buildFamilyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Keluarga',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _isLoadingFamilies
            ? Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: AppTheme.borderRadiusLarge,
                  border: Border.all(color: AppTheme.border),
                ),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : DropdownButtonFormField<int>(
                value: _selectedFamilyId,
                hint: const Text('Pilih keluarga'),
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
                    borderSide: const BorderSide(
                      color: AppTheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                items: _families.map((family) {
                  return DropdownMenuItem<int>(
                    value: family['id'] as int,
                    child: Text(
                      family['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedFamilyId = val),
              ),
      ],
    );
  }

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
            counterText: "",
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
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
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
