import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/data/residents.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:jawara/pages/approvals/resident_approval_detail.dart';

class ResidentApprovalsPage extends StatefulWidget {
  const ResidentApprovalsPage({super.key});

  @override
  State<ResidentApprovalsPage> createState() => _ResidentApprovalsPageState();
}

class _ResidentApprovalsPageState extends State<ResidentApprovalsPage> {
  List<Resident> _residents = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _residents = dummyResidents;
      _isLoading = false;
    });
  }

  List<Resident> _getFilteredResidents() {
    var filtered = _residents;

    // Filter by status
    if (_filterStatus != 'Semua') {
      filtered = filtered.where((resident) {
        switch (_filterStatus) {
          case 'Pending':
            return resident.registrationStatus == RegistrationStatus.pending;
          case 'Diterima':
            return resident.registrationStatus == RegistrationStatus.accepted;
          case 'Nonaktif':
            return resident.registrationStatus == RegistrationStatus.inactive;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((resident) {
        return resident.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            resident.nik.contains(_searchQuery) ||
            (resident.email ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  Widget _buildStatusChip(RegistrationStatus status) {
    Color bgColor;
    Color textColor;
    String label;
    
    switch (status) {
      case RegistrationStatus.accepted:
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF047857);
        label = 'Diterima';
        break;
      case RegistrationStatus.pending:
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        label = 'Pending';
        break;
      case RegistrationStatus.inactive:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
        label = 'Nonaktif';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredResidents = _getFilteredResidents();

    return Scaffold(
      appBar: StandardAppBar(title: 'Penerimaan Warga'),
      body: Column(
        children: [
          // Search Bar & Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama, NIK, email...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pending'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Diterima'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Nonaktif'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredResidents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tidak ada pengajuan warga'
                              : 'Tidak ada hasil pencarian',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadResidents,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredResidents.length,
                      itemBuilder: (context, index) {
                        final resident = filteredResidents[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () async {
                              // Langsung ke halaman detail
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResidentApprovalDetailPage(
                                    resident: resident,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _loadResidents();
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                                    child: Text(
                                      resident.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFF0891B2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Name & Status
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          resident.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildStatusChip(resident.registrationStatus),
                                      ],
                                    ),
                                  ),

                                  // Action Icons (only for pending)
                                  if (resident.registrationStatus == RegistrationStatus.pending) ...[
                                    IconButton(
                                      onPressed: () {
                                        _showApprovalDialog(context, resident, false);
                                      },
                                      icon: const Icon(Icons.close),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.red.withOpacity(0.1),
                                        foregroundColor: Colors.red,
                                      ),
                                      tooltip: 'Tolak',
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      onPressed: () {
                                        _showApprovalDialog(context, resident, true);
                                      },
                                      icon: const Icon(Icons.check),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.green.withOpacity(0.1),
                                        foregroundColor: Colors.green,
                                      ),
                                      tooltip: 'Terima',
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterStatus == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = label;
        });
      },
      selectedColor: const Color(0xFF0891B2).withOpacity(0.2),
      checkmarkColor: const Color(0xFF0891B2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF0891B2) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _showApprovalDialog(BuildContext context, Resident resident, bool isApprove) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isApprove ? Colors.green : Colors.red).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isApprove ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: isApprove ? Colors.green : Colors.red,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isApprove ? 'Terima Warga?' : 'Tolak Warga?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isApprove
                    ? 'Warga akan diterima dan dapat mengakses sistem'
                    : 'Warga akan ditolak dan tidak dapat mengakses sistem',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      resident.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIK: ${resident.nik}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleApproval(resident, isApprove);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApprove ? Colors.green : Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(isApprove ? 'Terima' : 'Tolak'),
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

  void _handleApproval(Resident resident, bool isApprove) {
    // Simulate API call
    if (isApprove) {
      ToastHelper.showSuccess(
        context,
        '${resident.name} berhasil diterima',
      );
    } else {
      ToastHelper.showSuccess(
        context,
        '${resident.name} berhasil ditolak',
      );
    }
    
    // Reload data
    _loadResidents();
  }
}
