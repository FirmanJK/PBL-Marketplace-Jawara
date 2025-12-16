import 'package:flutter/material.dart';
import 'package:jawara/models/family.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/families_service.dart';
import 'package:flutter/services.dart';
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

      if (newName.length != 16) {
        ToastHelper.showWarning(context, 'NIK harus 16 digit');
        return;
      }
      if (int.tryParse(newName) == null) {
        ToastHelper.showWarning(context, 'NIK hanya boleh berisi angka');
        return;
      }

    setState(() => _isSaving = true);
    try {
      final payload = <String, dynamic>{'family_number': newName, 'head_resident_id': _selectedHeadId};
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
    // Build a deduplicated list of dropdown items for head selection to
    // avoid duplicate-value assertion errors when widget.members contains
    // repeated entries.
    final List<DropdownMenuItem<int?>> headItems = [];
    final seen = <int>{};
    headItems.add(const DropdownMenuItem<int?>(value: null, child: Text('- Tidak ada -')));
    for (final m in widget.members) {
      if (seen.contains(m.id)) continue;
      seen.add(m.id);
      headItems.add(DropdownMenuItem<int?>(
        value: m.id,
        child: Text(
          m.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ));
    }

    // Ensure the selected value exists exactly once in items; if not,
    // fallback to null to avoid Dropdown assertion about duplicate values.
    final int? _dropdownSelected = (() {
      final matches = headItems.where((it) => it.value == _selectedHeadId).length;
      return matches == 1 ? _selectedHeadId : null;
    })();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Keluarga'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F2937),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'NIK', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<int?>(
              value: _dropdownSelected,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Pilih Kepala Keluarga', border: OutlineInputBorder()),
              items: headItems,
              onChanged: (v) {
                setState(() => _selectedHeadId = v);
              },
            ),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0891B2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: _isSaving 
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
