import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/data/messages.dart';
import 'package:jawara/models/message.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart';

class CitizenMessagesPage extends StatefulWidget {
  const CitizenMessagesPage({super.key});

  @override
  State<CitizenMessagesPage> createState() => _CitizenMessagesPageState();
}

class _CitizenMessagesPageState extends State<CitizenMessagesPage> {
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    setState(() {
      _isLocaleInitialized = true;
    });
  }

  Widget _buildStatusChip(Status status) {
    Color color;
    String label;
    Color textColor;

    switch (status) {
      case Status.accepted:
        color = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF047857);
        label = 'Diterima';
        break;
      case Status.pending:
        color = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        label = 'Pending';
        break;
      default:
        color = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        label = 'Status Lain';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, CitizenMessage message) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (String result) {
        if (result == 'detail') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CitizenMessageDetailPage(message: message),
            ),
          );
        } else if (result == 'edit') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CitizenMessageEditPage(message: message),
            ),
          );
        } else if (result == 'delete') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Simulasi: Menghapus pesan ${message.title}'),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'detail',
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Color(0xFF0891B2)),
              SizedBox(width: 8),
              Text('Detail', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: Colors.orange),
              SizedBox(width: 8),
              Text('Edit', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Hapus', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    if (!_isLocaleInitialized) {
      return BaseLayout(
        title: 'Pesan Warga',
        child: Container(
          width: double.infinity,
          color: const Color(0xFFF4F7FC),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF0891B2)),
          ),
        ),
      );
    }

    final headers = [
      'NO',
      'PENGIRIM',
      'JUDUL',
      'STATUS',
      'TANGGAL DIBUAT',
      'AKSI',
    ];
    final sortable = ['PENGIRIM', 'JUDUL', 'STATUS', 'TANGGAL DIBUAT'];
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    final rows = dummyCitizenMessages.map((message) {
      return <Widget>[
        Text(message.id.toString()),
        Text(message.senderName, overflow: TextOverflow.ellipsis),
        Text(message.title, overflow: TextOverflow.ellipsis),
        _buildStatusChip(message.status),
        Text(dateFormatter.format(message.createdAt)),

        _buildActionMenu(context, message),
      ];
    }).toList();

    return BaseLayout(
      title: 'Pesan Warga',
      actions: [
        Padding(
          padding: EdgeInsets.only(right: isMobile ? 8.0 : 16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
              size: isMobile ? 16 : 20,
            ),
            label: Text(
              isMobile ? '' : 'Filter',
              style: const TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0891B2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
            ),
          ),
        ),
      ],
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    child: CustomDataTable(
                      headers: headers,
                      rows: rows,
                      sortable: sortable,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CitizenMessageDetailPage extends StatelessWidget {
  final CitizenMessage message;

  const CitizenMessageDetailPage({super.key, required this.message});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double sidebarWidth = 70.0;
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Detail Informasi / Aspirasi Warga',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: sidebarWidth,
              right: 16.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF4F7FC),
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      width: 700,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            "Detail Informasi / Aspirasi Warga",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),

                          _buildDetailRow("Judul", message.title),
                          _buildDetailRow("Deskripsi", message.description),
                          _buildDetailRow("Status", message.statusInIndonesian),
                          _buildDetailRow("Dibuat oleh", message.creatorName),
                          _buildDetailRow(
                            "Tanggal Dibuat",
                            dateFormatter.format(message.createdAt),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CitizenMessageEditPage extends StatefulWidget {
  final CitizenMessage message;

  const CitizenMessageEditPage({super.key, required this.message});

  @override
  State<CitizenMessageEditPage> createState() => _CitizenMessageEditPageState();
}

class _CitizenMessageEditPageState extends State<CitizenMessageEditPage> {
  bool _isSidebarExpanded = true;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Status _selectedStatus;

  final List<Status> statusOptions = Status.values;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.message.title);
    _descriptionController = TextEditingController(
      text: widget.message.description,
    );
    _selectedStatus = widget.message.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _statusToString(Status status) {
    switch (status) {
      case Status.accepted:
        return 'Diterima';
      case Status.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sidebarWidth = _isSidebarExpanded ? 280.0 : 70.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isSidebarExpanded = !_isSidebarExpanded;
            });
          },
        ),
        title: const Flexible(
          child: Text(
            'Edit Informasi Aspirasi Warga',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(left: sidebarWidth),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF4F7FC),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      width: 700,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Edit Informasi Aspirasi Warga",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          const Text(
                            "Judul Pesan",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: widget.message.title,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            "Deskripsi Pesan",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "mobile igmana bang",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<Status>(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              value: _selectedStatus,
                              items: statusOptions.map((Status status) {
                                return DropdownMenuItem<Status>(
                                  value: status,
                                  child: Text(_statusToString(status)),
                                );
                              }).toList(),
                              onChanged: (Status? newValue) {
                                setState(() {
                                  _selectedStatus = newValue!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 40),

                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Pesan ID ${widget.message.id} berhasil diperbarui! Judul: ${_titleController.text}',
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0891B2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
