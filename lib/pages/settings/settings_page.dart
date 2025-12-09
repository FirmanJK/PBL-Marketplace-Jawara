import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _language = 'id_ID';
  String _theme = 'system';
  bool _notifEmail = true;
  bool _notifPush = true;
  bool _notifSound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Pengaturan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Umum Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0891B2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Color(0xFF0891B2),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Umum',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bahasa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _language,
                      items: const [
                        DropdownMenuItem(
                          value: 'id_ID',
                          child: Text('Indonesia'),
                        ),
                        DropdownMenuItem(
                          value: 'en_US',
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (val) => setState(() => _language = val!),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.language, size: 20),
                        hintText: 'Pilih bahasa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tema',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _theme,
                      items: const [
                        DropdownMenuItem(
                          value: 'light',
                          child: Text('Terang'),
                        ),
                        DropdownMenuItem(
                          value: 'dark',
                          child: Text('Gelap'),
                        ),
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('Ikuti Sistem'),
                        ),
                      ],
                      onChanged: (val) => setState(() => _theme = val!),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.brightness_6, size: 20),
                        hintText: 'Pilih tema',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notifikasi Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Color(0xFF10B981),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SwitchTile(
                      title: 'Email',
                      subtitle: 'Kirim ringkasan aktivitas ke email',
                      value: _notifEmail,
                      onChanged: (v) => setState(() => _notifEmail = v),
                    ),
                    const SizedBox(height: 12),
                    _SwitchTile(
                      title: 'Push Notification',
                      subtitle: 'Tampilkan pemberitahuan pada perangkat',
                      value: _notifPush,
                      onChanged: (v) => setState(() => _notifPush = v),
                    ),
                    const SizedBox(height: 12),
                    _SwitchTile(
                      title: 'Suara',
                      subtitle: 'Bunyikan alarm saat ada notifikasi penting',
                      value: _notifSound,
                      onChanged: (v) => setState(() => _notifSound = v),
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

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0891B2),
          ),
        ],
      ),
    );
  }
}
