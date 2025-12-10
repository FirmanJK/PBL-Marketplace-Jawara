import 'package:flutter/material.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/models/resident_approval.dart';
import 'package:jawara/services/resident_approval_service.dart';
import 'package:jawara/services/families_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class ResidentApprovalDetailPage extends StatefulWidget {
  final Resident resident;
  final int? approvalId; // ID untuk backend call
  final Function? onApprovalChanged; // Callback untuk refresh list

  const ResidentApprovalDetailPage({
    super.key,
    required this.resident,
    this.approvalId,
    this.onApprovalChanged,
  });

  @override
  State<ResidentApprovalDetailPage> createState() =>
      _ResidentApprovalDetailPageState();
}

class _ResidentApprovalDetailPageState
    extends State<ResidentApprovalDetailPage> {
  bool _isProcessing = false;
  List<Map<String, dynamic>> _families = [];
  bool _familiesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  Future<void> _loadFamilies() async {
    if (_familiesLoaded) return;
    try {
      final families = await FamiliesService.getFamilies();
      setState(() {
        _families = families.map((f) {
          return {'id': f.id, 'headName': f.headResidentName ?? 'Keluarga'};
        }).toList();
        _familiesLoaded = true;
      });
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal load keluarga: $e');
      }
    }
  }

  Future<void> _handleApprove() async {
    if (widget.approvalId == null) {
      ToastHelper.showError(context, 'ID pengajuan tidak ditemukan');
      return;
    }

    // Show family picker
    if (!mounted) return;
    _showFamilyPickerDialog((familyId) async {
      setState(() => _isProcessing = true);

      try {
        await ResidentApprovalService.approveResident(
          widget.approvalId!,
          familyId: familyId,
          note: 'Disetujui',
        );

        if (!mounted) return;
        ToastHelper.showSuccess(
          context,
          '${widget.resident.name} berhasil diterima',
        );

        widget.onApprovalChanged?.call();
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ToastHelper.showError(context, 'Gagal menerima: $e');
        setState(() => _isProcessing = false);
      }
    });
  }

  Future<void> _handleReject() async {
    if (widget.approvalId == null) {
      ToastHelper.showError(context, 'ID pengajuan tidak ditemukan');
      return;
    }

    if (!mounted) return;
    _showRejectDialog((note) async {
      setState(() => _isProcessing = true);

      try {
        await ResidentApprovalService.rejectResident(
          widget.approvalId!,
          note: note,
        );

        if (!mounted) return;
        ToastHelper.showSuccess(
          context,
          '${widget.resident.name} berhasil ditolak',
        );

        widget.onApprovalChanged?.call();
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ToastHelper.showError(context, 'Gagal menolak: $e');
        setState(() => _isProcessing = false);
      }
    });
  }

  void _showFamilyPickerDialog(Function(int) onSelected) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Keluarga'),
        content: SizedBox(
          width: double.maxFinite,
          child: _families.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _families.length,
                  itemBuilder: (context, idx) {
                    final family = _families[idx];
                    return ListTile(
                      title: Text('Keluarga ${family['headName']}'),
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(family['id'] as int);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(Function(String) onSubmit) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pengajuan'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Alasan penolakan',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ToastHelper.showError(context, 'Alasan penolakan harus diisi');
                return;
              }
              Navigator.pop(context);
              onSubmit(reason);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan'),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.resident.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF0891B2),
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.resident.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(widget.resident.registrationStatus),
                ],
              ),
            ),

            // Detail Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Pribadi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    icon: Icons.badge_outlined,
                    label: 'NIK',
                    value: widget.resident.nik,
                  ),
                  _buildDetailCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: widget.resident.email ?? '-',
                  ),
                  _buildDetailCard(
                    icon: widget.resident.gender == 'Laki-laki'
                        ? Icons.male
                        : Icons.female,
                    label: 'Jenis Kelamin',
                    value: widget.resident.gender,
                  ),
                  _buildDetailCard(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    value: widget.resident.address ?? '-',
                  ),
                  _buildDetailCard(
                    icon: Icons.info_outline,
                    label: 'Status',
                    value: widget.resident.status,
                  ),
                  const SizedBox(height: 24),

                  // Photo Section
                  const Text(
                    'Foto Identitas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Foto tidak tersedia',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          widget.resident.registrationStatus == RegistrationStatus.pending
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : _handleReject,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.close),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _handleApprove,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.check),
                      label: const Text('Terima'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildStatusChip(RegistrationStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case RegistrationStatus.accepted:
        bgColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
        label = 'Diterima';
        break;
      case RegistrationStatus.pending:
        bgColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
        label = 'Pending';
        break;
      case RegistrationStatus.inactive:
        bgColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
        label = 'Nonaktif';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0891B2), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
