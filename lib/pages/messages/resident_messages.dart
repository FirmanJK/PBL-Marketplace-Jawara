import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/data/messages.dart';
import 'package:jawara/models/message.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class CitizenMessagesPage extends StatefulWidget {
  const CitizenMessagesPage({super.key});

  @override
  State<CitizenMessagesPage> createState() => _CitizenMessagesPageState();
}

class _CitizenMessagesPageState extends State<CitizenMessagesPage> {
  bool _isLocaleInitialized = false;
  List<CitizenMessage> _messages = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _initializeLocale();
    _loadMessages();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    setState(() {
      _isLocaleInitialized = true;
    });
  }

  Future<void> _loadMessages() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      setState(() {
        _messages = dummyCitizenMessages;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<CitizenMessage> _getFilteredMessages() {
    var filtered = _messages;

    // Filter by status
    if (_filterStatus != 'Semua') {
      filtered = filtered.where((message) {
        switch (_filterStatus) {
          case 'Pending':
            return message.status == Status.pending;
          case 'Diterima':
            return message.status == Status.accepted;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((message) {
        return message.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            message.senderName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            message.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: StandardAppBar(title: 'Pesan Warga'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    final filteredMessages = _getFilteredMessages();

    return Scaffold(
      appBar: StandardAppBar(title: 'Pesan Warga'),
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
                    hintText: 'Cari judul, pengirim, atau isi pesan...',
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
                : filteredMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tidak ada pesan warga'
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
                    onRefresh: _loadMessages,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = filteredMessages[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _showMessageDetail(
                              context,
                              message,
                              dateFormatter,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  Row(
                                    children: [
                                      // Icon
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF0891B2,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.mail_outline,
                                          color: Color(0xFF0891B2),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Title & Status
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    message.status ==
                                                        Status.accepted
                                                    ? const Color(0xFFD1FAE5)
                                                    : const Color(0xFFFEF3C7),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                message.status ==
                                                        Status.accepted
                                                    ? 'Diterima'
                                                    : 'Pending',
                                                style: TextStyle(
                                                  color:
                                                      message.status ==
                                                          Status.accepted
                                                      ? const Color(0xFF047857)
                                                      : const Color(0xFFD97706),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Sender Info
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          message.senderName,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Date
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        dateFormatter.format(message.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Message Preview
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Text(
                                      message.description,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Tap untuk melihat detail
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),
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

  void _showMessageDetail(
    BuildContext context,
    CitizenMessage message,
    DateFormat dateFormatter,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Expanded(
              child: Text(
                message.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message Content
              Text(
                message.description,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0891B2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
