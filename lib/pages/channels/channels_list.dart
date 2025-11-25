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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: channel.thumbnail != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(channel.thumbnail!),
                            radius: 24,
                          )
                        : CircleAvatar(
                            backgroundColor: _getTypeColor(channel.tipe).withOpacity(0.1),
                            child: Icon(
                              Icons.account_balance,
                              color: _getTypeColor(channel.tipe),
                            ),
                          ),
                    title: Text(
                      channel.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Atas Nama: ${channel.atasNama}'),
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
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                    onTap: () {},
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
        icon: const Icon(Icons.add),
        label: const Text('Tambah Channel'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
