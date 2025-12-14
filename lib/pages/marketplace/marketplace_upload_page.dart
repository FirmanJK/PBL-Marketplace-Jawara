import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara/data/products.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart' show CustomInputField;

class MarketplaceUploadPage extends StatefulWidget {
  const MarketplaceUploadPage({super.key});

  @override
  State<MarketplaceUploadPage> createState() => _MarketplaceUploadPageState();
}

class _MarketplaceUploadPageState extends State<MarketplaceUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  File? _selectedImage;
  bool _isLoading = false;

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
              leading: const Icon(Icons.photo_library, color: Color(0xFF0891B2)),
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
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e')),
        );
      }
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih gambar produk')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await ProductService.createProduct(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageFile: _selectedImage!,
        userId: 1, // TODO: Ambil dari session user yang login
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil diunggah!')),
        );
        
        // Reset form
        _formKey.currentState!.reset();
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() => _selectedImage = null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah produk: $e')),
        );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Text('Unggah Produk', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Image Picker Section
            GestureDetector(
              onTap: _isLoading ? null : _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 64, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk ambil foto',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
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
                text: 'Unggah Produk',
                onPressed: _submitProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
