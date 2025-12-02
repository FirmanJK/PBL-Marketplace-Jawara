import 'package:flutter/material.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/models/auth_response.dart';
import 'package:jawara/utils/toast_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndLogin() async {
    setState(() {
      // Reset errors
      _emailError = null;
      _passwordError = null;

      // Validate email
      if (_emailController.text.trim().isEmpty) {
        _emailError = 'Email tidak boleh kosong';
      } else if (!_emailController.text.contains('@')) {
        _emailError = 'Format email tidak valid';
      }

      // Validate password
      if (_passwordController.text.trim().isEmpty) {
        _passwordError = 'Password tidak boleh kosong';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
      }
    });

    // If no validation errors, proceed to login
    if (_emailError == null && _passwordError == null) {
      _performLogin();
    }
  }

  Future<void> _performLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        // Login berhasil - tampilkan toast
        ToastHelper.showSuccess(context, 'Login berhasil! 🎉');
        // Navigate immediately - toast stays visible during transition (2s duration)
        Navigator.pushReplacementNamed(context, '/dashboard/finance');
      }
    } on ErrorResponse catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Popup toast error di atas
      if (mounted) {
        ToastHelper.showError(context, e.detail);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show different messages based on error type
      String errorMessage = 'Terjadi kesalahan';
      if (e.toString().contains('Connection refused')) {
        errorMessage =
            'Tidak bisa terhubung ke server. Pastikan backend running di localhost:8000';
      } else if (e.toString().contains('Connection timed out')) {
        errorMessage = 'Koneksi timeout. Cek apakah backend sedang berjalan';
      } else {
        errorMessage = 'Gagal login: ${e.toString()}';
      }

      // Popup toast error di atas
      if (mounted) {
        ToastHelper.showError(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 48.0 : 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo dan Judul
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.book_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Jawara Pintar',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sistem Manajemen RT Modern',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      // Form Login
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth > 600
                              ? 480
                              : double.infinity,
                        ),
                        padding: EdgeInsets.all(
                          constraints.maxWidth > 600 ? 32.0 : 24.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 0,
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Selamat Datang Kembali! 👋',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan login untuk melanjutkan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            CustomInputField(
                              label: 'Email',
                              hintText: 'nama@email.com',
                              prefixIcon: Icons.email_outlined,
                              controller: _emailController,
                              errorText: _emailError,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            CustomInputField(
                              label: 'Password',
                              hintText: 'Masukkan password Anda',
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              controller: _passwordController,
                              errorText: _passwordError,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  debugPrint('Lupa password!');
                                },
                                child: const Text(
                                  'Lupa Password?',
                                  style: TextStyle(
                                    color: Color(0xFF06B6D4),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: _isLoading ? 'Memproses...' : 'Masuk',
                              icon: _isLoading ? null : Icons.arrow_forward,
                              onPressed: _isLoading ? () {} : _validateAndLogin,
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey[300]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'Atau',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey[300]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigasi ke halaman daftar
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: const Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      color: Color(0xFF06B6D4),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '© 2025 Jawara Pintar. All rights reserved.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
