import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/services/house_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class ResidentsEditPage extends StatefulWidget {
  final Resident resident;

  const ResidentsEditPage({super.key, required this.resident});

  @override
  State<ResidentsEditPage> createState() => _ResidentsEditPageState();
}

class _ResidentsEditPageState extends State<ResidentsEditPage> {
  // Controllers
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _pendidikanController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  // House inputs
  final _houseNumberController = TextEditingController();
  final _houseAddressController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();

  // State
  int? _selectedHouseId;
  DateTime? _selectedTanggalLahir;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolDarah;
  String? _selectedStatus;

  // Static options
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
  final List<String> _statusOptions = ['aktif', 'pindah', 'meninggal'];

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.resident.name;
    _nikController.text = widget.resident.nik;
    _phoneController.text = widget.resident.phone ?? '';
    // Ensure gender has valid value to prevent dropdown issues
    _selectedGender = ['Laki-laki', 'Perempuan'].contains(widget.resident.gender) 
        ? widget.resident.gender 
        : 'Laki-laki';
    _selectedStatus = widget.resident.status;
    _loadHouseData();
  }

  Future<void> _loadHouseData() async {
    if (_selectedHouseId != null) {
      try {
        final houses = await HouseService.getHouses(skip: 0, limit: 500);
        dynamic selectedHouse;
        try {
          selectedHouse = houses.firstWhere((h) => h.id == _selectedHouseId);
        } catch (e) {
          selectedHouse = null;
        }
        if (selectedHouse != null && mounted) {
          setState(() {
            _houseNumberController.text = selectedHouse.houseNumber ?? '';
            _houseAddressController.text = selectedHouse.address ?? '';
            _rtController.text = selectedHouse.rt ?? '';
            _rwController.text = selectedHouse.rw ?? '';
          });
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Gagal load data rumah: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    _pendidikanController.dispose();
    _pekerjaanController.dispose();
    _houseNumberController.dispose();
    _houseAddressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
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

  Future<void> _openHousePicker() async {
    bool loading = false;
    List houses = [];

    Future<void> fetch() async {
      loading = true;
      setState(() {});
      try {
        houses = await HouseService.getHouses(skip: 0, limit: 500);
      } catch (e) {
        ToastHelper.showError(context, 'Gagal load rumah: $e');
      } finally {
        loading = false;
        if (mounted) setState(() {});
      }
    }

    await fetch();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Pilih Rumah'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (loading)
                      const Center(child: CircularProgressIndicator()),
                    if (!loading)
                      Flexible(
                        child: houses.isEmpty
                            ? const Text('Tidak ada rumah')
                            : ListView.builder(
                                itemCount: houses.length,
                                itemBuilder: (context, index) {
                                  final h = houses[index];
                                  final houseNum = h is Map
                                      ? h['house_number']
                                      : h.houseNumber;
                                  final address = h is Map
                                      ? h['address']
                                      : h.address;
                                  final hid = h is Map ? h['id'] as int? : h.id;

                                  return ListTile(
                                    title: Text('Rumah No $houseNum'),
                                    subtitle: Text(address ?? '-'),
                                    onTap: () {
                                      setState(() {
                                        _selectedHouseId = hid;
                                        _houseNumberController.text =
                                            houseNum ?? '';
                                        _houseAddressController.text =
                                            address ?? '';
                                        _rtController.text =
                                            (h is Map ? h['rt'] : h.rt) ?? '';
                                        _rwController.text =
                                            (h is Map ? h['rw'] : h.rw) ?? '';
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveChanges() {
    _submitUpdate();
  }

  Future<void> _submitUpdate() async {
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
        'status': _selectedStatus,
        if (_selectedHouseId != null) 'house_id': _selectedHouseId,
      };

      // If user provided house details (and didn't select existing), create a new house first
      try {
        final hasHouseData =
            _houseAddressController.text.isNotEmpty ||
            _houseNumberController.text.isNotEmpty ||
            _rtController.text.isNotEmpty ||
            _rwController.text.isNotEmpty;
        if (_selectedHouseId == null && hasHouseData) {
          final houseBody = {
            'house_number': _houseNumberController.text.isEmpty
                ? null
                : _houseNumberController.text,
            'address': _houseAddressController.text.isEmpty
                ? null
                : _houseAddressController.text,
            'rt': _rtController.text.isEmpty ? null : _rtController.text,
            'rw': _rwController.text.isEmpty ? null : _rwController.text,
          };
          final createdHouse = await HouseService.createHouse(houseBody);
          data['house_id'] = createdHouse.id;
          _selectedHouseId = createdHouse.id;
        }
      } catch (e) {
        if (mounted)
          ToastHelper.showWarning(context, 'Gagal membuat rumah: $e');
      }

      // Update resident via API
      await ResidentsService.updateResident(widget.resident.id, data);

      // If user selected an existing house, call assign endpoint
      if (_selectedHouseId != null) {
        try {
          await HouseService.assignHouse(_selectedHouseId!, widget.resident.id);
        } catch (e) {
          if (mounted)
            ToastHelper.showWarning(
              context,
              'Data diperbarui, namun gagal melakukan assign rumah: $e',
            );
        }
      }

      // Show success toast and return
      if (mounted) {
        ToastHelper.showSuccess(context, 'Data berhasil diperbarui');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(
          context,
          'Gagal memperbarui data: ${e.toString()}',
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

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Edit Warga',
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
            tooltip: 'Simpan',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                (isMobile ? 32.0 : 48.0) -
                kToolbarHeight,
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
                  'Edit Warga',
                  style: AppTheme.headingMedium.copyWith(
                    fontSize: isMobile ? 20 : 24,
                  ),
                ),
                SizedBox(height: isMobile ? 24 : 32),

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
                  onChanged: (v) => setState(() => _selectedJenisKelamin = v),
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
                const SizedBox(height: 24),

                // Dropdown Status
                _buildDropdownField(
                  label: 'Status',
                  hint: 'Pilih status',
                  value: _selectedStatus,
                  items: _statusOptions,
                  onChanged: (v) => setState(() => _selectedStatus = v),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Informasi Rumah',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nomor Rumah',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _houseNumberController,
                            decoration: InputDecoration(
                              hintText: 'Cth: A1, B2',
                              border: OutlineInputBorder(
                                borderRadius: AppTheme.borderRadiusLarge,
                                borderSide: const BorderSide(
                                  color: AppTheme.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppTheme.borderRadiusLarge,
                                borderSide: const BorderSide(
                                  color: AppTheme.border,
                                ),
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _openHousePicker,
                      icon: const Icon(Icons.home),
                      label: const Text('Pilih Rumah'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alamat Rumah',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _houseAddressController,
                      decoration: InputDecoration(
                        hintText: 'Jl. Contoh No.1',
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
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RT',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _rtController,
                            decoration: InputDecoration(
                              hintText: 'Contoh: 01',
                              border: OutlineInputBorder(
                                borderRadius: AppTheme.borderRadiusLarge,
                                borderSide: const BorderSide(
                                  color: AppTheme.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppTheme.borderRadiusLarge,
                                borderSide: const BorderSide(
                                  color: AppTheme.border,
                                ),
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RW',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _rwController,
                            decoration: InputDecoration(
                              hintText: 'Contoh: 02',
                              border: OutlineInputBorder(
                                borderRadius: AppTheme.borderRadiusLarge,
                                borderSide: const BorderSide(
                                  color: AppTheme.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppTheme.borderRadiusLarge,
                                borderSide: const BorderSide(
                                  color: AppTheme.border,
                                ),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Gender
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonFormField<String>(
                  key: const ValueKey('gender_dropdown'), // Add unique key
                  value: ['Laki-laki', 'Perempuan'].contains(_selectedGender) ? _selectedGender : 'Laki-laki',
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: Icon(Icons.wc),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['Laki-laki', 'Perempuan'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != _selectedGender) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih jenis kelamin';
                    }
                    return null;
                  },
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 16),

              // Birth Date
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _birthDate != null
                        ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                        : 'Pilih tanggal',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Address (read-only from house data)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

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
