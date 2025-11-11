import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/card.dart';
import 'package:jawara/shared/theme.dart';

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
    return BaseLayout(
      title: 'Pengaturan',
      actions: const [],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              SizedBox(
                width: 420,
                child: SharedCard(
                  title: 'Umum',
                  icon: Icons.tune_rounded,
                  color: AppTheme.secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bahasa', style: AppTheme.bodyMedium),
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
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.language_rounded, size: 20),
                          hintText: 'Pilih bahasa',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Tema', style: AppTheme.bodyMedium),
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
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.brightness_6_rounded, size: 20),
                          hintText: 'Pilih tema',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 420,
                child: SharedCard(
                  title: 'Notifikasi',
                  icon: Icons.notifications_rounded,
                  color: AppTheme.accent,
                  child: Column(
                    children: [
                      _SwitchTile(
                        title: 'Email',
                        subtitle: 'Kirim ringkasan aktivitas ke email',
                        value: _notifEmail,
                        onChanged: (v) => setState(() => _notifEmail = v),
                      ),
                      const SizedBox(height: 8),
                      _SwitchTile(
                        title: 'Push Notification',
                        subtitle: 'Tampilkan pemberitahuan pada perangkat',
                        value: _notifPush,
                        onChanged: (v) => setState(() => _notifPush = v),
                      ),
                      const SizedBox(height: 8),
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
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTheme.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
