import 'package:flutter/material.dart';
import 'package:jawara/models/family.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/families_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class FamilyEditPage extends StatefulWidget {
  final Family family;
  final List<Resident> members;

  const FamilyEditPage({super.key, required this.family, required this.members});

  @override
  State<FamilyEditPage> createState() => _FamilyEditPageState();
}

class _FamilyEditPageState extends State<FamilyEditPage> {
  late TextEditingController _nameController;
  int? _selectedHeadId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.family.namaKeluarga);
    _selectedHeadId = widget.family.headResidentId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ToastHelper.showWarning(context, 'Nama keluarga tidak boleh kosong');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final payload = <String, dynamic>{'family_number': newName};
      if (_selectedHeadId != null) payload['head_resident_id'] = _selectedHeadId;
      await FamiliesService.updateFamily(widget.family.id, payload);
      if (!mounted) return;
      ToastHelper.showSuccess(context, 'Keluarga berhasil diperbarui');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ToastHelper.showError(context, 'Gagal memperbarui keluarga: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Keluarga'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Keluarga', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              initialValue: _selectedHeadId,
              decoration: const InputDecoration(labelText: 'Pilih Kepala Keluarga', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('- Tidak ada -')),
                ...widget.members.map((m) => DropdownMenuItem<int?>(value: m.id, child: Text('${m.name} (NIK: ${m.nik})')))
              ],
              onChanged: (v) {
                setState(() => _selectedHeadId = v);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
                child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
