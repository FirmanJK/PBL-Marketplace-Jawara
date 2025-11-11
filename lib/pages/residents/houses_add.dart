import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class HousesAddPage extends StatefulWidget {
  const HousesAddPage({super.key});

  @override
  State<HousesAddPage> createState() => _HousesAddPageState();
}

class _HousesAddPageState extends State<HousesAddPage> {
  // Controller for the text field
  final _alamatController = TextEditingController();

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _alamatController.clear();
    });
  }

  void _submitForm() {
    // Implement submit logic here
    debugPrint('Alamat Rumah: ${_alamatController.text}');
    // Panggil API atau fungsi simpan data
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Tambah Rumah', // Judul AppBar
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusXLarge,
            boxShadow: AppTheme.shadowMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Agar card tidak memenuhi tinggi layar
            children: [
              Text(
                'Tambah Rumah Baru', // Judul Form
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Alamat Rumah
              _buildTextField(
                label: 'Alamat Rumah',
                hint: 'Contoh: Jl. Merpati No. 5', // Placeholder
                controller: _alamatController,
                 maxLines: 3, // Beri sedikit ruang jika alamat panjang
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                children: [
                  SizedBox(
                    width: 120, // Sesuaikan lebar jika perlu
                    child: CustomButton(
                      text: 'Submit', // Tombol Submit
                      onPressed: _submitForm,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text('Reset', style: TextStyle(color: AppTheme.textMedium)), // Tombol Reset
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

 // Helper widget untuk Text Field (bisa disalin dari file form lain)
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1, // Tambahkan parameter maxLines
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines, // Gunakan maxLines
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
             contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ],
    );
  }
}
