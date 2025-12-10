import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final AuthService _authService = AuthService();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (_isLoading) return;

    if (_currentPassController.text.isEmpty ||
        _newPassController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      ToastHelper.showWarning(context, 'Semua field kata sandi harus diisi.');
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      ToastHelper.showWarning(context, 'Kata sandi baru tidak cocok.');
      return;
    }

    if (_newPassController.text.length < 8) {
      ToastHelper.showWarning(context, 'Kata sandi baru minimal 8 karakter.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.changePassword(
        currentPassword: _currentPassController.text,
        newPassword: _newPassController.text,
      );

      if (mounted) {
        ToastHelper.showSuccess(context, 'Kata sandi berhasil diperbarui.');
        _currentPassController.clear();
        _newPassController.clear();
        _confirmPassController.clear();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StandardAppBar(title: 'Ganti Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
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
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Color(0xFF8B5CF6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Ganti Kata Sandi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  label: 'Kata Sandi Saat Ini',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  controller: _currentPassController,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Kata Sandi Baru',
                  hintText: 'Minimal 8 karakter',
                  prefixIcon: Icons.lock_outline,
                  controller: _newPassController,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Konfirmasi Kata Sandi Baru',
                  hintText: 'Ulangi kata sandi baru',
                  prefixIcon: Icons.lock_outline,
                  controller: _confirmPassController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _changePassword,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.key, color: Colors.white),
                    label: Text(
                      _isLoading ? 'Memperbarui...' : 'Perbarui Kata Sandi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
