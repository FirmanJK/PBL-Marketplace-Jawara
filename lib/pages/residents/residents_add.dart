import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/services/families_service.dart';
import 'package:jawara/services/house_service.dart';
import 'dart:async';
import 'package:jawara/utils/toast_helper.dart';

class ResidentsAddPage extends StatefulWidget {
  final int? initialFamilyId;

  const ResidentsAddPage({super.key, this.initialFamilyId});

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
  int? _selectedHouseId;
  DateTime? _selectedTanggalLahir;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolDarah;

  // House inputs
  final _houseNumberController = TextEditingController();
  final _houseAddressController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();

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
    // Preselect family if provided by caller (e.g., from FamilyDetail)
    if (widget.initialFamilyId != null) {
      _selectedFamilyId = widget.initialFamilyId;
    }
  }

  // Server-side resident picker with debounce + simple pagination
  Future<void> _openExistingResidentPicker() async {
    if (_selectedFamilyId == null) {
      ToastHelper.showWarning(context, 'Pilih keluarga terlebih dahulu');
      return;
    }

    int skip = 0;
    const int pageSize = 25;
    String query = '';
    List residents = [];
    bool loading = false;
    Timer? debounce;

    Future<void> fetch() async {
      loading = true;
      setState(() {});
      try {
        final res = await ResidentsService.getResidents(skip: skip, limit: pageSize, query: query.isEmpty ? null : query);
        residents = res;
      } catch (e) {
        ToastHelper.showError(context, 'Gagal load daftar warga: $e');
      } finally {
        loading = false;
        if (mounted) setState(() {});
      }
    }

    // initial fetch
    await fetch();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          final filtered = residents;

          return AlertDialog(
            title: const Text('Pilih Warga Terdaftar'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Cari nama atau NIK'),
                    onChanged: (v) {
                      query = v;
                      skip = 0;
                      // debounce
                      debounce?.cancel();
                      debounce = Timer(const Duration(milliseconds: 300), () async {
                        await fetch();
                        setStateDialog(() {});
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  if (loading) const Center(child: CircularProgressIndicator()),
                  if (!loading)
                    Flexible(
                      child: filtered.isEmpty
                          ? const Text('Tidak ada hasil')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (context, idx) {
                                final item = filtered[idx];
                                final id = item is Map ? item['id'] : item.id;
                                final name = item is Map ? item['name'] : item.name;
                                final nik = item is Map ? item['nik'] : item.nik;
                                return ListTile(
                                  title: Text('$name'),
                                  subtitle: Text(nik.toString()),
                                  trailing: TextButton(
                                    child: const Text('Tambah'),
                                        onPressed: () async {
                                      try {
                                        final added = await FamiliesService.addResidentToFamily(_selectedFamilyId!, id as int);
                                        if (!mounted) return;
                                        ToastHelper.showSuccess(context, 'Warga berhasil ditambahkan ke keluarga');
                                        Navigator.of(context).pop(added);
                                      } catch (e) {
                                        if (!mounted) return;
                                        ToastHelper.showError(context, 'Gagal menambahkan warga: $e');
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: skip - pageSize >= 0
                        ? () async {
                            skip = (skip - pageSize).clamp(0, skip);
                            await fetch();
                            setStateDialog(() {});
                          }
                        : null,
                    child: const Text('Prev'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      skip += pageSize;
                      await fetch();
                      setStateDialog(() {});
                    },
                    child: const Text('Next'),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                ],
              ),
            ],
          );
        });
      },
    );
    debounce?.cancel();
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

  Future<void> _openHousePicker() async {
    if (_selectedFamilyId == null) {
      ToastHelper.showWarning(context, 'Pilih keluarga terlebih dahulu');
      return;
    }

    bool loading = false;
    List houses = [];
    List residents = [];

    Future<void> fetch() async {
      loading = true;
      setState(() {});
      try {
        houses = await HouseService.getHouses(skip: 0, limit: 500);
        // fetch residents to determine which houses are occupied by selected family
        residents = await ResidentsService.getResidents(skip: 0, limit: 1000);
      } catch (e) {
        ToastHelper.showError(context, 'Gagal load rumah atau warga: $e');
      } finally {
        loading = false;
        if (mounted) setState(() {});
      }
    }

    await fetch();

    // Determine house IDs used by selected family
    final familyHouseIds = <int>{};
    for (var r in residents) {
      final hid = r is Map ? r['house_id'] as int? : (r.houseId as int?);
      final fid = r is Map ? r['family_id'] as int? : (r.familyId as int?);
      if (hid != null && fid == _selectedFamilyId) familyHouseIds.add(hid);
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          final filtered = houses.where((h) {
            final houseStatus = (h is Map ? h['status'] as String? : h.status) ?? 'available';
            final hid = (h is Map ? h['id'] as int? : h.id) ?? 0;
            return houseStatus == 'available' || familyHouseIds.contains(hid);
          }).toList();

          return AlertDialog(
            title: const Text('Pilih Rumah'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (loading) const Center(child: CircularProgressIndicator()),
                  if (!loading)
                    Flexible(
                      child: filtered.isEmpty
                          ? const Text('Tidak ada rumah yang sesuai')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (context, idx) {
                                final item = filtered[idx];
                                final id = item is Map ? item['id'] as int : item.id;
                                final addr = item is Map ? item['address'] as String? : item.address;
                                final num = item is Map ? item['house_number'] as String? : item.houseNumber;
                                final status = item is Map ? item['status'] as String? : item.status;
                                return ListTile(
                                  title: Text(num ?? 'Rumah #$id'),
                                  subtitle: Text(addr ?? '-'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(status ?? 'available'),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        child: const Text('Pilih'),
                                        onPressed: () {
                                          setState(() {
                                            _selectedHouseId = id as int;
                                          });
                                          if (mounted) ToastHelper.showSuccess(context, 'Rumah terpilih');
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ],
          );
        });
      },
    );
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
          // If no house selected, send 0 so backend may auto-assign; if user provided house data, we'll create it below
          'house_id': 0,
      };

        // If user provided house details (and didn't select existing), create a new house first
        try {
          final hasHouseData = _houseAddressController.text.isNotEmpty || _houseNumberController.text.isNotEmpty || _rtController.text.isNotEmpty || _rwController.text.isNotEmpty;
          if (_selectedHouseId == null && hasHouseData) {
            final houseBody = {
              'house_number': _houseNumberController.text.isEmpty ? null : _houseNumberController.text,
              'address': _houseAddressController.text.isEmpty ? null : _houseAddressController.text,
              'rt': _rtController.text.isEmpty ? null : _rtController.text,
              'rw': _rwController.text.isEmpty ? null : _rwController.text,
            };
            final createdHouse = await HouseService.createHouse(houseBody);
            data['house_id'] = createdHouse.id;
            // remember selected house so we will call assign endpoint after resident created
            _selectedHouseId = createdHouse.id;
          } else if (_selectedHouseId != null) {
            data['house_id'] = _selectedHouseId;
          }
        } catch (e) {
          // If house creation failed, show a warning but continue with house_id=0 so backend can assign
          if (mounted) ToastHelper.showWarning(context, 'Gagal membuat rumah: $e');
        }

        // If user selected an existing house via picker, _selectedHouseId will be set

      // Create resident via API
      final created = await ResidentsService.createResident(data);

      // If user selected an existing house (not newly created), call assign endpoint
      if (_selectedHouseId != null) {
        try {
          final assigned = await HouseService.assignHouse(_selectedHouseId!, created.id);
          // prefer the assigned resident returned from server
          if (mounted) {
            ToastHelper.showSuccess(context, 'Warga berhasil ditambahkan dan dipindahkan ke rumah');
            Navigator.pop(context, assigned);
            return;
          }
        } catch (e) {
          // If assign failed, still return created resident but show warning
          if (mounted) ToastHelper.showWarning(context, 'Warga dibuat, namun gagal melakukan assign rumah: $e');
          if (mounted) Navigator.pop(context, created);
          return;
        }
      }

      // Show success toast and return created resident
      if (mounted) {
        ToastHelper.showSuccess(context, 'Warga berhasil ditambahkan');
        Navigator.pop(context, created);
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (widget.initialFamilyId != null) ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.people),
                            label: const Text('Pilih Warga Terdaftar'),
                            onPressed: _openExistingResidentPicker,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 16),

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

                    const Text(
                      'Informasi Rumah (opsional)',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Nomor Rumah',
                            hint: 'Contoh: A-101',
                            controller: _houseNumberController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _openHousePicker,
                          icon: const Icon(Icons.home),
                          label: const Text('Pilih Rumah'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Alamat Rumah',
                      hint: 'Jl. Contoh No.1',
                      controller: _houseAddressController,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'RT',
                            hint: '001',
                            controller: _rtController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'RW',
                            hint: '002',
                            controller: _rwController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

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
