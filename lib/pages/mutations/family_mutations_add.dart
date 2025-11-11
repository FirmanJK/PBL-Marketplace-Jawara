import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        hint: Text(hintText),
        value: selectedValue,
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
  DateTime? _selectedDate;

  final List<String> jenisMutasiOptions = [
    'Masuk Wilayah',
    'Keluar Wilayah',
    'Pindah Alamat',
  ];
  final List<String> keluargaOptions = [
    'Keluarga Budi',
    'Keluarga Siti',
    'Keluarga Amir',
  ];

  @override
  void dispose() {
    _alasanController.dispose();
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
        child: Column(
          children: [
            // CARD FORM - FULL WIDTH & EXPANDED
            Expanded(
              child: Card(
                elevation: 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Buat Mutasi Keluarga",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Jenis Mutasi
                        const Text(
                          "Jenis Mutasi",
                          style: TextStyle(fontWeight: FontWeight.w600),
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
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        CustomDropdown(
                          hintText: "-- Pilih Keluarga --",
                          items: keluargaOptions,
                          selectedValue: _selectedKeluarga,
                          onChanged: (value) =>
                              setState(() => _selectedKeluarga = value),
                        ),
                        const SizedBox(height: 24),

                        // Alasan Mutasi
                        const Text(
                          "Alasan Mutasi",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _alasanController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Masukkan alasan disini...",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tanggal Mutasi
                        const Text(
                          "Tanggal Mutasi",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.white,
                              ),
                              child: Text(
                                _formattedDate,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.black54,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Tombol Aksi
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('Simpan Mutasi:');
                                print('Jenis: $_selectedJenisMutasi');
                                print('Keluarga: $_selectedKeluarga');
                                print('Alasan: ${_alasanController.text}');
                                print('Tanggal: $_formattedDate');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Simpan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedJenisMutasi = null;
                                  _selectedKeluarga = null;
                                  _alasanController.clear();
                                  _selectedDate = null;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
