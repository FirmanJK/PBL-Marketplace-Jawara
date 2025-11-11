import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class BroadcastAddPage extends StatefulWidget {
  const BroadcastAddPage({super.key});

  @override
  State<BroadcastAddPage> createState() => _BroadcastAddPageState();
}

class _BroadcastAddPageState extends State<BroadcastAddPage> {
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();

  // Placeholder state for file uploads
  String _fotoFileName = 'Belum ada file dipilih';
  String _dokumenFileName = 'Belum ada file dipilih';

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _judulController.clear();
      _isiController.clear();
      _fotoFileName = 'Belum ada file dipilih';
      _dokumenFileName = 'Belum ada file dipilih';
    });
  }

  void _submitForm() {
    // Implement submit logic here
    debugPrint('Judul: ${_judulController.text}');
    debugPrint('Isi: ${_isiController.text}');
    debugPrint('Foto: $_fotoFileName');
    debugPrint('Dokumen: $_dokumenFileName');
    // Nanti tambahkan logika upload file dan kirim data
  }

  // Placeholder function for picking files (implement later)
  void _pickFoto() {
    // Implement file picking logic for images
    setState(() {
      _fotoFileName = 'gambar_kegiatan.jpg'; // Dummy name
    });
    debugPrint('Memilih foto...');
  }

  void _pickDokumen() {
    // Implement file picking logic for documents
    setState(() {
      _dokumenFileName = 'proposal_acara.pdf'; // Dummy name
    });
    debugPrint('Memilih dokumen...');
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Tambah Broadcast',
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
            children: [
              Text(
                'Buat Broadcast Baru',
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Judul Broadcast
              _buildTextField(
                label: 'Judul Broadcast',
                hint: 'Masukkan judul broadcast',
                controller: _judulController,
              ),
              const SizedBox(height: 24),

              // Isi Broadcast
              _buildTextArea(
                label: 'Isi Broadcast',
                hint: 'Tulis isi broadcast di sini...',
                controller: _isiController,
                maxLines: 8, // Lebih banyak baris untuk isi broadcast
              ),
              const SizedBox(height: 24),

              // Upload Foto
              _buildFileUploadSection(
                label: 'Foto',
                description: 'Maksimal 10 gambar (.png / .jpg), ukuran maksimal 5MB per gambar.',
                fileName: _fotoFileName,
                onTapUpload: _pickFoto,
                uploadButtonText: 'Upload foto png/jpg',
              ),
              const SizedBox(height: 24),

              // Upload Dokumen
              _buildFileUploadSection(
                label: 'Dokumen',
                description: 'Maksimal 10 file (.pdf), ukuran maksimal 5MB per file.',
                fileName: _dokumenFileName,
                onTapUpload: _pickDokumen,
                uploadButtonText: 'Upload dokumen pdf',
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
                    child: const Text('Reset', style: TextStyle(color: AppTheme.textMedium)),
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

  // Helper widget untuk Text Field (sama seperti di ActivitiesAddPage)
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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

  // Helper widget untuk Text Area (sama seperti di ActivitiesAddPage)
  Widget _buildTextArea({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 5,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
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

  // Helper widget untuk File Upload Section
  Widget _buildFileUploadSection({
    required String label,
    required String description,
    required String fileName,
    required VoidCallback onTapUpload,
    required String uploadButtonText,
  }) {
    bool fileChosen = !fileName.startsWith('Belum');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        Text(description, style: AppTheme.bodySmall.copyWith(color: AppTheme.textLight)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: AppTheme.borderRadiusLarge,
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  fileName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fileChosen ? Colors.green.shade700 : AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: fileChosen ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                icon: Icon(Icons.upload_file, size: 18, color: AppTheme.primary),
                label: Text(uploadButtonText, style: TextStyle(color: AppTheme.primary)),
                onPressed: onTapUpload,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusSmall),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
