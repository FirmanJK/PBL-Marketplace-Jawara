import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara/models/verification_result.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketplaceUploadPage extends StatefulWidget {
  final int? verificationResultId;

  const MarketplaceUploadPage({super.key, this.verificationResultId});

  @override
  State<MarketplaceUploadPage> createState() => _MarketplaceUploadPageState();
}

class _MarketplaceUploadPageState extends State<MarketplaceUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  File? _selectedImage;
  bool _isLoading = false;
  bool _verificationSuccess = false;
  bool _isAdmin = false;
  VerificationResult? _verificationResult;
  String _selectedUnit = 'kg';
  final List<String> _units = ['kg', 'piece', 'bundle'];

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    if (widget.verificationResultId != null) {
      _loadVerificationResult();
    }
  }

  Future<void> _checkAdminStatus() async {
    final authService = AuthService();
    final isAdmin = authService.currentRole == UserRole.adminSistem;
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  Future<void> _loadVerificationResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final result = await ApiService.get(
        '/verification-results/${widget.verificationResultId!}',
        token: token,
      );

      if (result is Map && result['data'] != null) {
        setState(() {
          _verificationResult = VerificationResult.fromJson(result['data']);
        });
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
          _selectedImage = File(image.path);
        });

        // IMMEDIATELY VERIFY THE IMAGE AFTER PICKING
        await _verifyImageImmediately();
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal mengambil gambar: $e');
      }
    }
  }

  Future<void> _verifyImageImmediately() async {
    if (_selectedImage == null) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        setState(() => _isLoading = false);
        if (mounted) {
          ToastHelper.showWarning(context, 'Silakan login terlebih dahulu');
        }
        return;
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0891B2)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sedang Memverifikasi...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mohon tunggu, kami sedang memeriksa kualitas sayur/buah Anda',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }

      final verificationResult = await ApiService.multipart(
        '/marketplace/verify-vegetable',
        'POST',
        files: {'file': _selectedImage!.path},
        token: token,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (verificationResult == null) {
        setState(() => _isLoading = false);
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
                    setState(() => _selectedImage = null);
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

      // CHECK VERIFICATION RESULT
      final isValid = verificationResult?['is_valid'] ?? false;
      final confidence = verificationResult?['confidence'] ?? 0;
      final vegetableType =
          verificationResult?['vegetable_type'] ?? 'Tidak Diketahui';

      setState(() => _isLoading = false);

      if (!isValid) {
        // TIDAK UTUH - SHOW ALERT
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
                    'Produk Anda tidak memenuhi standar kualitas marketplace. Silakan ambil foto yang lebih baik.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _selectedImage = null);
                  },
                  child: const Text('Ambil Foto Lain'),
                ),
              ],
            ),
          );
        }
      } else {
        // UTUH - SHOW SUCCESS
        if (mounted) {
          ToastHelper.showSuccess(
            context,
            '✅ $vegetableType Anda Terverifikasi UTUH! (${(confidence * 100).toStringAsFixed(1)}%)',
          );
        }
        setState(() => _verificationSuccess = true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastHelper.showError(context, 'Gagal memverifikasi: $e');
        setState(() => _selectedImage = null);
      }
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImage == null) {
      ToastHelper.showWarning(context, 'Silakan pilih gambar produk');
      return;
    }

    if (!_verificationSuccess) {
      ToastHelper.showWarning(
        context,
        'Produk belum terverifikasi. Silakan ambil foto terlebih dahulu.',
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        setState(() => _isLoading = false);
        if (mounted) {
          ToastHelper.showWarning(context, 'Silakan login terlebih dahulu');
        }
        return;
      }

      // Step 1: Upload image first
      String? uploadedImageFilename;
      try {
        uploadedImageFilename = await ApiService.uploadProductImage(
          _selectedImage!.path,
          token: token,
        );
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Gagal upload gambar: $e');
        }
        setState(() => _isLoading = false);
        return;
      }

      if (mounted) {
        ToastHelper.showInfo(context, 'Mengupload produk ke marketplace...');
      }

      // Step 2: Create product with uploaded image filename
      final response = await ApiService.post(
        '/marketplace/products',
        body: {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'stock': int.parse(_quantityController.text),
          'unit': _selectedUnit,
          'image': uploadedImageFilename,
        },
        token: token,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        ToastHelper.showSuccess(
          context,
          '✅ Produk berhasil diunggah ke marketplace!',
        );

        // Reset form
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _quantityController.text = '1';
        setState(() {
          _selectedImage = null;
          _verificationSuccess = false;
        });

        // Navigate to marketplace catalog
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/marketplace/catalog',
              (route) => false,
            );
          }
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastHelper.showError(context, 'Gagal mengupload produk: $e');
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ToastHelper.showInfo(context, 'Logging out...');
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Icons.inventory_2,
                  color: Color(0xFF0891B2),
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Upload Produk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF0891B2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF0891B2)),
                    SizedBox(width: 12),
                    Text('Profil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF0891B2)),
                    SizedBox(width: 12),
                    Text('Pengaturan'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Keluar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                          child: kIsWeb
                              ? Image.network(
                                  _selectedImage!.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap untuk ambil foto produk',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Verification Status Indicator
              if (_selectedImage != null)
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
                              ? 'Produk terverifikasi ✓'
                              : 'Tap foto untuk memverifikasi produk',
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

              // Nama Produk
              CustomInputField(
                controller: _nameController,
                label: 'Nama Produk',
                hintText: 'Contoh: Sayuran Segar Bayam',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Deskripsi
              CustomInputField(
                controller: _descriptionController,
                label: 'Deskripsi Produk',
                hintText: 'Jelaskan kondisi, manfaat, dan detail produk Anda',
                inputType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga
              CustomInputField(
                controller: _priceController,
                label: 'Harga per Unit (Rp)',
                hintText: 'Contoh: 15000',
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

              // Quantity & Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInputField(
                      controller: _quantityController,
                      label: 'Jumlah',
                      hintText: 'Contoh: 10',
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah wajib diisi';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Harus angka';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Satuan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedUnit,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: _units
                                .map(
                                  (unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedUnit = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  text: 'Upload Produk ke Marketplace',
                  onPressed: _submitProduct,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
