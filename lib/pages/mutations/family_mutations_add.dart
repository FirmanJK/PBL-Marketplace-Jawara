import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/services/mutations_service.dart';
import 'package:jawara/services/families_service.dart';
import 'package:jawara/models/family.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0891B2), width: 2),
          ),
        ),
        hint: Text(hintText, style: TextStyle(color: Colors.grey[600])),
        initialValue: selectedValue,
        isExpanded: true,
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class FamilyMutationsAddPage extends StatefulWidget {
  const FamilyMutationsAddPage({super.key});

  @override
  State<FamilyMutationsAddPage> createState() => _FamilyMutationsAddPageState();
}

class _FamilyMutationsAddPageState extends State<FamilyMutationsAddPage> {
  String? _selectedJenisMutasi;
  String? _selectedKeluarga;
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _alamatAsalController = TextEditingController();
  final TextEditingController _alamatTujuanController = TextEditingController();
  DateTime? _selectedDate;

  final List<String> jenisMutasiOptions = [
    'Masuk Wilayah',
    'Keluar Wilayah',
    'Pindah Alamat',
  ];
  List<Family> keluargaOptions = [];
  int? _selectedKeluargaId;

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  Future<void> _loadFamilies() async {
    try {
      final families = await FamiliesService.getFamilies();
      setState(() {
        keluargaOptions = families;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _alasanController.dispose();
    _alamatAsalController.dispose();
    _alamatTujuanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String get _formattedDate {
    if (_selectedDate == null) return '--/--/----';
    return '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return BaseLayout(
      title: 'Tambah Mutasi Keluarga',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0891B2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.family_restroom,
                            color: Color(0xFF0891B2),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Buat Mutasi Keluarga",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Tambahkan data mutasi keluarga baru",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 24),

                    // Jenis Mutasi
                    const Text(
                      "Jenis Mutasi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomDropdown(
                      hintText: "-- Pilih Jenis Mutasi --",
                      items: jenisMutasiOptions,
                      selectedValue: _selectedJenisMutasi,
                      onChanged: (value) =>
                          setState(() => _selectedJenisMutasi = value),
                    ),
                    const SizedBox(height: 24),

                    // Keluarga
                    const Text(
                      "Keluarga",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Keluarga dropdown (loaded from backend)
                    CustomDropdown(
                      hintText: "-- Pilih Keluarga --",
                      items: keluargaOptions.map((f) => '${f.id} - ${f.familyNumber}').toList(),
                      selectedValue: _selectedKeluarga,
                      onChanged: (value) {
                        if (value == null) return;
                        final id = int.tryParse(value.split(' -').first);
                        setState(() {
                          _selectedKeluarga = value;
                          _selectedKeluargaId = id;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Alamat Asal
                    const Text(
                      "Alamat Asal",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _alamatAsalController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Masukkan alamat asal...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Alamat Tujuan
                    const Text(
                      "Alamat Tujuan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _alamatTujuanController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Masukkan alamat tujuan...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Alasan Mutasi
                    const Text(
                      "Alasan Mutasi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _alasanController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Masukkan alasan disini...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF0891B2), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tanggal Mutasi
                    const Text(
                      "Tanggal Mutasi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formattedDate,
                              style: TextStyle(
                                fontSize: 15,
                                color: _formattedDate == '--/--/----' 
                                    ? Colors.grey[400] 
                                    : const Color(0xFF1F2937),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_month,
                              color: Color(0xFF0891B2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Aksi
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_selectedJenisMutasi == null || _selectedKeluargaId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lengkapi jenis mutasi dan keluarga')),
                                );
                                return;
                              }
                              try {
                                // Build description containing alamat asal, tujuan, dan alasan
                                final descParts = <String>[];
                                final asal = _alamatAsalController.text.trim();
                                final tujuan = _alamatTujuanController.text.trim();
                                final alasan = _alasanController.text.trim();
                                if (asal.isNotEmpty) descParts.add('alamat_lama:${asal}');
                                if (tujuan.isNotEmpty) descParts.add('alamat_baru:${tujuan}');
                                if (alasan.isNotEmpty) descParts.add('alasan:${alasan}');
                                final description = descParts.join('|');

                                await MutationsService.createMutation({
                                  'family_id': _selectedKeluargaId,
                                  'mutation_type': _selectedJenisMutasi,
                                  'description': description,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Mutasi keluarga berhasil disimpan'),
                                    backgroundColor: Color(0xFF10B981),
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal menyimpan mutasi: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: const Text(
                              'Simpan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0891B2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedJenisMutasi = null;
                              _selectedKeluarga = null;
                              _alasanController.clear();
                              _selectedDate = null;
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'Reset',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
  }
}
