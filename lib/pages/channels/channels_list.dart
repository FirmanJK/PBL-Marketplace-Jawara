import 'package:flutter/material.dart';
import 'package:jawara/data/channels.dart';
import 'package:jawara/shared/base_layout.dart';

class ChannelsListPage extends StatefulWidget {
  const ChannelsListPage({super.key});

  @override
  State<ChannelsListPage> createState() => _ChannelsListPageState();
}

class _ChannelsListPageState extends State<ChannelsListPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return BaseLayout(
      title: 'Daftar Channel Transfer',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Column(
          children: [
            // JUDUL
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daftar Channel Transfer",
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),

            // CARD TABEL - FULL WIDTH & EXPANDED
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: DataTable(
                            headingRowHeight: 56,
                            dataRowHeight: 64,
                            columnSpacing: 32,
                            headingRowColor: WidgetStateProperty.all(
                              Colors.deepPurple.shade50,
                            ),
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "NO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "NAMA CHANNEL",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "TIPE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "ATAS NAMA",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "THUMBNAIL",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "AKSI",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: channelList.map((channel) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(channel.id.toString())),
                                  DataCell(Text(channel.nama)),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: channel.tipe == 'Bank'
                                            ? Colors.blue.shade100
                                            : channel.tipe == 'E-Wallet'
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        channel.tipe,
                                        style: TextStyle(
                                          color: channel.tipe == 'Bank'
                                              ? Colors.blue.shade700
                                              : channel.tipe == 'E-Wallet'
                                              ? Colors.green.shade700
                                              : Colors.orange.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(channel.atasNama)),
                                  DataCell(
                                    channel.thumbnail != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              channel.thumbnail!,
                                            ),
                                            radius: 20,
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {},
                                      tooltip: 'Lihat detail',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PAGINATION
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 193, 200, 202),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),

            SizedBox(height: isMobile ? 12 : 16),
          ],
        ),
      ),
    );
  }
}
