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

class ChannelsAddPage extends StatefulWidget {
  const ChannelsAddPage({super.key});

  @override
  State<ChannelsAddPage> createState() => _ChannelsAddPageState();
}

class _ChannelsAddPageState extends State<ChannelsAddPage> {
  String? _selectedTipe;
  final TextEditingController _namaChannelController = TextEditingController();
  final TextEditingController _nomorAkunController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  String? _qrFileName;

  final List<String> tipeOptions = ['Bank', 'E-Wallet', 'QRIS'];

  @override
  void dispose() {
    _namaChannelController.dispose();
    _nomorAkunController.dispose();
    _namaPemilikController.dispose();
    super.dispose();
  }

  void _uploadQrPhoto() {
    setState(() {
      _qrFileName = 'qr_code_sample.png';
    });
  }

  void _handleSimpan() {
    print('Menyimpan Transfer Channel:');
    print('Nama Channel: ${_namaChannelController.text}');
    print('Tipe: $_selectedTipe');
    print('Nomor Akun: ${_nomorAkunController.text}');
    print('Nama Pemilik: ${_namaPemilikController.text}');
    print('File QR: ${_qrFileName ?? "Belum ada file dipilih"}');
  }

  void _handleReset() {
    setState(() {
      _namaChannelController.clear();
      _selectedTipe = null;
      _nomorAkunController.clear();
      _namaPemilikController.clear();
      _qrFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return BaseLayout(
      title: 'Tambah Channel Transfer',
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
                          "Buat Channel Transfer",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Nama Channel
                        const Text(
                          "Nama Channel",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _namaChannelController,
                          decoration: InputDecoration(
                            hintText: "Contoh: BCA / Gopay / QRIS",
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

                        // Tipe
                        const Text(
                          "Tipe",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        CustomDropdown(
                          hintText: "-- Pilih Tipe --",
                          items: tipeOptions,
                          selectedValue: _selectedTipe,
                          onChanged: (value) {
                            setState(() {
                              _selectedTipe = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Nomor Rekening/Akun
                        const Text(
                          "Nomor Rekening/Akun",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nomorAkunController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Masukkan nomor rekening/akun",
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

                        // Nama Pemilik
                        const Text(
                          "Nama Pemilik",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _namaPemilikController,
                          decoration: InputDecoration(
                            hintText: "Masukkan nama pemilik rekening",
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

                        // Upload QR
                        const Text(
                          "Upload QR",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _uploadQrPhoto,
                              icon: const Icon(Icons.upload_file, size: 18),
                              label: const Text('Pilih File'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _qrFileName ?? 'Belum ada file dipilih',
                                style: TextStyle(
                                  color: _qrFileName != null
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Tombol Aksi
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _handleSimpan,
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
                            OutlinedButton(
                              onPressed: _handleReset,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
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
