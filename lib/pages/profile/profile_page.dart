import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/card.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/shared/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController(text: 'Admin');
  final _emailController = TextEditingController(text: 'admin@jawara.id');
  final _phoneController = TextEditingController(text: '08xxxxxxxxxx');

  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil disimpan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _changePassword() {
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi tidak cocok.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kata sandi diperbarui.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Profil',
      actions: const [],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1000;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: isWide ? 420 : double.infinity,
                        child: SharedCard(
                          title: 'Informasi Akun',
                          icon: Icons.account_circle_rounded,
                          color: AppTheme.primary,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              CustomInputField(
                                label: 'Nama Lengkap',
                                hintText: 'Masukkan nama',
                                prefixIcon: Icons.person_outline,
                                controller: _nameController,
                              ),
                              const SizedBox(height: 12),
                              CustomInputField(
                                label: 'Email',
                                hintText: 'Masukkan email',
                                prefixIcon: Icons.email_outlined,
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              CustomInputField(
                                label: 'No. HP',
                                hintText: 'Masukkan nomor HP',
                                prefixIcon: Icons.phone_outlined,
                                controller: _phoneController,
                                inputType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Simpan Perubahan',
                                      icon: Icons.save_rounded,
                                      onPressed: _saveProfile,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isWide ? 420 : double.infinity,
                        child: SharedCard(
                          title: 'Ganti Kata Sandi',
                          icon: Icons.lock_rounded,
                          color: AppTheme.accentPurple,
                          child: Column(
                            children: [
                              CustomInputField(
                                label: 'Kata Sandi Saat Ini',
                                hintText: '••••••••',
                                prefixIcon: Icons.lock_outline,
                                controller: _currentPassController,
                                isPassword: true,
                              ),
                              const SizedBox(height: 12),
                              CustomInputField(
                                label: 'Kata Sandi Baru',
                                hintText: 'Minimal 8 karakter',
                                prefixIcon: Icons.lock_outline,
                                controller: _newPassController,
                                isPassword: true,
                              ),
                              const SizedBox(height: 12),
                              CustomInputField(
                                label: 'Konfirmasi Kata Sandi Baru',
                                hintText: 'Ulangi kata sandi baru',
                                prefixIcon: Icons.lock_outline,
                                controller: _confirmPassController,
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Perbarui Kata Sandi',
                                      icon: Icons.key_rounded,
                                      onPressed: _changePassword,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
