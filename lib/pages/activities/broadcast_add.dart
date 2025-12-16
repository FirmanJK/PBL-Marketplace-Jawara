import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class BroadcastAddPage extends StatefulWidget {
  const BroadcastAddPage({super.key});

  @override
  State<BroadcastAddPage> createState() => _BroadcastAddPageState();
}

class _BroadcastAddPageState extends State<BroadcastAddPage> {
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  String _selectedPrioritas = 'Sedang';

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _saveBroadcast() async {
    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();
    
    if (judul.isEmpty || isi.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Mohon lengkapi semua field'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      return;
    }
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Broadcast "$judul" berhasil dikirim')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      
      // Navigate back after success
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Tambah Broadcast',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0891B2).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.campaign, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buat Broadcast Baru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kirim pengumuman ke seluruh warga',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Form Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Broadcast
                    const Text(
                      'Judul Broadcast',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _judulController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan judul broadcast',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Prioritas
                    const Text(
                      'Prioritas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPrioritas,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0891B2)),
                          style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16),
                          items: const [
                            DropdownMenuItem(value: 'Tinggi', child: Text('Prioritas Tinggi')),
                            DropdownMenuItem(value: 'Sedang', child: Text('Prioritas Sedang')),
                            DropdownMenuItem(value: 'Rendah', child: Text('Prioritas Rendah')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedPrioritas = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Isi Pesan
                    const Text(
                      'Isi Pesan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _isiController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan isi pesan broadcast...',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color(0xFF0891B2)),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                color: Color(0xFF0891B2),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveBroadcast,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0891B2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Kirim Broadcast',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple function to show broadcast dialog that can be called from anywhere
void showBroadcastDialog(BuildContext context, {Function(Map<String, dynamic>)? onBroadcastAdded}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => _BroadcastDialog(
      onBroadcastAdded: onBroadcastAdded,
    ),
  );
}

class _BroadcastDialog extends StatefulWidget {
  final Function(Map<String, dynamic>)? onBroadcastAdded;

  const _BroadcastDialog({this.onBroadcastAdded});

  @override
  State<_BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends State<_BroadcastDialog> {
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  String _selectedPrioritas = 'Sedang';

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _saveBroadcast() async {
    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();
    
    if (judul.isEmpty || isi.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Mohon lengkapi semua field'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      return;
    }
    
    // Create broadcast data
    final broadcastData = {
      'title': judul,
      'content': isi,
      'priority': _selectedPrioritas,
      'status': 'Aktif',
      'date': '${DateTime.now().day} Des ${DateTime.now().year}',
    };
    
    // Close dialog first
    if (mounted) {
      Navigator.pop(context);
    }
    
    // Small delay to ensure dialog is closed
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Call callback if provided
    if (widget.onBroadcastAdded != null) {
      widget.onBroadcastAdded!(broadcastData);
    }
    
    // Show success message using the root context
    if (mounted) {
      final rootContext = Navigator.of(context, rootNavigator: true).context;
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Broadcast "$judul" berhasil dikirim')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header biru dengan icon + dan judul
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0891B2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tambah Broadcast',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              
              // Content form
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Judul Broadcast
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0891B2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.folder_outlined, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text('Judul Broadcast', style: TextStyle(fontSize: 14, color: Color(0xFF0891B2), fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0891B2), width: 2),
                        ),
                        child: TextField(
                          controller: _judulController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: 'Masukkan judul broadcast',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Prioritas
                      const Text('Jenis', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0891B2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.campaign, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedPrioritas,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0891B2)),
                                  style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16),
                                  items: const [
                                    DropdownMenuItem(value: 'Tinggi', child: Text('Broadcast Tinggi')),
                                    DropdownMenuItem(value: 'Sedang', child: Text('Broadcast Sedang')),
                                    DropdownMenuItem(value: 'Rendah', child: Text('Broadcast Rendah')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedPrioritas = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Isi Pesan
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0891B2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.attach_money, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text('Nominal', style: TextStyle(fontSize: 14, color: Color(0xFF0891B2), fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: _isiController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: 'Masukkan isi pesan broadcast',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Batal', style: TextStyle(color: Color(0xFF6B7280), fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveBroadcast,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0891B2),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}