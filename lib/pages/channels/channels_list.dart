import 'package:flutter/material.dart';
import 'package:jawara/data/channels.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class ChannelsListPage extends StatefulWidget {
  const ChannelsListPage({super.key});

  @override
  State<ChannelsListPage> createState() => _ChannelsListPageState();
}

class _ChannelsListPageState extends State<ChannelsListPage> {
  Color _getTypeColor(String tipe) {
    switch (tipe) {
      case 'Bank':
        return Colors.blue;
      case 'E-Wallet':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Channel Transfer',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari channel transfer...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: channelList.length,
              itemBuilder: (context, index) {
                final channel = channelList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to channel detail page
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          channel.thumbnail != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(channel.thumbnail!),
                                  radius: 28,
                                )
                              : CircleAvatar(
                                  radius: 28,
                                  backgroundColor: _getTypeColor(channel.tipe).withOpacity(0.1),
                                  child: Icon(
                                    Icons.account_balance,
                                    color: _getTypeColor(channel.tipe),
                                    size: 28,
                                  ),
                                ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  channel.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Atas Nama: ${channel.atasNama}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(channel.tipe).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    channel.tipe,
                                    style: TextStyle(
                                      color: _getTypeColor(channel.tipe),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/channels/add');
        },
<<<<<<< HEAD
        icon: const Icon(Icons.add),
        label: const Text('Tambah Channel'),
=======
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Channel', style: TextStyle(color: Colors.white)),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
