import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara/data/products.dart';
import 'package:jawara/models/marketplace_product.dart';
import 'package:jawara/services/api_service.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart' show CustomInputField;
import 'package:jawara/utils/toast_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketplaceEditPage extends StatefulWidget {
  final MarketplaceProduct product;

  const MarketplaceEditPage({super.key, required this.product});

  @override
  State<MarketplaceEditPage> createState() => _MarketplaceEditPageState();
}

class _MarketplaceEditPageState extends State<MarketplaceEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  File? _newImage;
  bool _isLoading = false;
  bool _isVerifying = false;
  bool _verificationSuccess = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Tampilkan dialog untuk memilih sumber gambar
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0891B2)),
              title: const Text('Ambil Foto dari Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF0891B2),
              ),
              title: const Text('Pilih dari Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.grey),
              title: const Text('Batal'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _newImage = File(image.path);
          _verificationSuccess = false;
        });
        // Langsung verifikasi setelah pilih gambar
        _verifyImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
      }
    }
  }

  Future<void> _verifyImage(File imageFile) async {
    setState(() => _isVerifying = true);

    try {
      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF0891B2)),
                  SizedBox(height: 16),
                  Text('Memverifikasi kualitas sayur...'),
                ],
              ),
            ),
          ),
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) throw Exception('Token tidak ditemukan');

      // Call verification API using multipart
      final verificationResult = await ApiService.multipart(
        '/marketplace/verify-vegetable',
        'POST',
        files: {'file': imageFile.path},
        token: token,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (verificationResult == null) {
        setState(() => _isVerifying = false);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Verifikasi Gagal'),
              content: const Text(
                'Terjadi kesalahan saat memverifikasi. Silakan coba ambil foto lagi.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _newImage = null);
                    _pickImage();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
        return;
      }

      final isValid = verificationResult?['is_valid'] ?? false;
      final confidence = verificationResult?['confidence'] ?? 0;
      final vegetableType =
          verificationResult?['vegetable_type'] ?? 'Tidak Diketahui';

      setState(() => _isVerifying = false);

      if (!isValid) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sayur Tidak Utuh ❌'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jenis: $vegetableType'),
                  const SizedBox(height: 8),
                  Text(
                    'Tingkat Kepercayaan: ${(confidence * 100).toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Produk Anda tidak memenuhi standar kualitas. Silakan ambil foto yang lebih baik.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _newImage = null);
                  },
                  child: const Text('Ambil Foto Lain'),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ToastHelper.showSuccess(
            context,
            '✅ $vegetableType Terverifikasi UTUH! (${(confidence * 100).toStringAsFixed(1)}%)',
          );
        }
        setState(() => _verificationSuccess = true);
      }
    } catch (e) {
      setState(() => _isVerifying = false);
      if (mounted) {
        Navigator.pop(context, false); // Close loading dialog if exist
      }
      if (mounted) {
        ToastHelper.showError(context, 'Gagal memverifikasi: $e');
        setState(() => _newImage = null);
      }
    }
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    // Jika ada gambar baru, wajib terverifikasi
    if (_newImage != null && !_verificationSuccess) {
      ToastHelper.showWarning(
        context,
        'Silakan tunggu hingga gambar terverifikasi',
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await ProductService.updateProduct(
        id: widget.product.id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageFile: _newImage?.path, // Kirim path string
      );

      if (mounted) {
        ToastHelper.showSuccess(context, 'Produk berhasil diperbarui!');
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal memperbarui produk: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0891B2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF0891B2),
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Edit Produk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _newImage != null
                            ? Image.file(
                                _newImage!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : widget.product.getImageUrl().isNotEmpty
                            ? Image.network(
                                widget.product.getImageUrl(),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                    ),
                                  );
                                },
                              )
                            : const Center(child: Icon(Icons.image, size: 64)),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Ganti Foto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Verification Status Indicator
              if (_newImage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _verificationSuccess
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _verificationSuccess
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF9800),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _verificationSuccess ? Icons.check_circle : Icons.info,
                        color: _verificationSuccess
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _verificationSuccess
                              ? 'Foto terverifikasi ✓'
                              : 'Sedang verifikasi foto produk...',
                          style: TextStyle(
                            color: _verificationSuccess
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF9800),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Nama Barang
              CustomInputField(
                controller: _nameController,
                label: 'Nama Barang',
                hintText: 'Masukkan nama barang',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga
              CustomInputField(
                controller: _priceController,
                label: 'Harga Jual (Rp)',
                hintText: 'Masukkan harga',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Deskripsi
              CustomInputField(
                controller: _descriptionController,
                label: 'Deskripsi Barang',
                hintText: 'Masukkan deskripsi',
                inputType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              if (_isLoading)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                CustomButton(
                  text: 'Simpan Perubahan',
                  onPressed: _submitUpdate,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
