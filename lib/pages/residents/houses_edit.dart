import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/models/house.dart';
import 'package:jawara/services/house_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class HousesEditPage extends StatefulWidget {
  final House house;

  const HousesEditPage({super.key, required this.house});

  @override
  State<HousesEditPage> createState() => _HousesEditPageState();
}

class _HousesEditPageState extends State<HousesEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _houseNumberController;
  late TextEditingController _addressController;
  late TextEditingController _rtController;
  late TextEditingController _rwController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _houseNumberController = TextEditingController(text: widget.house.houseNumber ?? '');
    _addressController = TextEditingController(text: widget.house.address ?? '');
    _rtController = TextEditingController(text: widget.house.rt ?? '');
    _rwController = TextEditingController(text: widget.house.rw ?? '');
  }

  @override
  void dispose() {
    _houseNumberController.dispose();
    _addressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final body = {
        'house_number': _houseNumberController.text.trim().isEmpty ? null : _houseNumberController.text.trim(),
        'address': _addressController.text.trim(),
        'rt': _rtController.text.trim().isEmpty ? null : _rtController.text.trim(),
        'rw': _rwController.text.trim().isEmpty ? null : _rwController.text.trim(),
      };
      await HouseService.updateHouse(widget.house.id, body);
      if (!mounted) return;
      ToastHelper.showSuccess(context, 'Perubahan rumah disimpan');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ToastHelper.showError(context, 'Gagal menyimpan perubahan: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Edit Rumah',
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveChanges,
            tooltip: 'Simpan',
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
              TextFormField(
                controller: _houseNumberController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Rumah',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Alamat wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rtController,
                      decoration: const InputDecoration(
                        labelText: 'RT',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rwController,
                      decoration: const InputDecoration(
                        labelText: 'RW',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0891B2),
<<<<<<< HEAD
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
=======
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                  style: const TextStyle(color: Colors.white),
                ),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
              ),
            ],
          ),
        ),
      ),
    );
  }
}
