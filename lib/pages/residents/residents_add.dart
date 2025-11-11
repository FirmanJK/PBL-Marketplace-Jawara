import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk InputFormatter
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

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

  void _submitForm() {
    // Implement submit logic
    debugPrint('Keluarga: $_selectedKeluarga');
    debugPrint('Nama: ${_namaController.text}');
    debugPrint('NIK: ${_nikController.text}');
    debugPrint('Telepon: ${_teleponController.text}');
    debugPrint('Tempat Lahir: ${_tempatLahirController.text}');
    debugPrint(
      'Tanggal Lahir: ${_selectedTanggalLahir != null ? DateFormat('dd/MM/yyyy').format(_selectedTanggalLahir!) : 'N/A'}',
    );
    debugPrint('Jenis Kelamin: $_selectedJenisKelamin');
    debugPrint('Agama: $_selectedAgama');
    debugPrint('Gol. Darah: $_selectedGolDarah');
    debugPrint('Peran: $_selectedPeran');
    debugPrint('Pendidikan: $_selectedPendidikan');
    debugPrint('Pekerjaan: $_selectedPekerjaan');
    debugPrint('Status: $_selectedStatus');
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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusXLarge,
            boxShadow: AppTheme.shadowMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onChanged: (v) => setState(() => _selectedJenisKelamin = v),
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
                    child: CustomButton(text: 'Submit', onPressed: _submitForm),
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
          value: items.contains(value) ? value : null, // Pastikan value valid
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
          // Jika item pertama adalah hint, jangan tampilkan sebagai pilihan valid
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              // Jika item = hint, buat value-nya null agar tidak bisa dipilih
              value: item == hint ? null : item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == hint ? Colors.grey[400] : AppTheme.textDark,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          // Tampilkan dropdown di bawah
          menuMaxHeight: 300, // Batasi tinggi menu dropdown jika perlu
        ),
      ],
    );
  }
}
