import 'package:flutter/material.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/models/auth_response.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:jawara/services/connectivity_service.dart';
import 'package:jawara/widgets/dev_login_helper.dart';
import 'package:jawara/utils/role_helper.dart';
import 'package:jawara/models/user_role.dart';
import 'package:flutter/foundation.dart';

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

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.adminSistem:
        return 'Admin Sistem';
      case UserRole.ketuaRT:
        return 'Ketua RT/RW';
      case UserRole.sekretaris:
        return 'Sekretaris';
      case UserRole.bendahara:
        return 'Bendahara';
      case UserRole.warga:
        return 'Warga';
    }
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

    // If validation errors, don't proceed
    if (_emailError != null || _passwordError != null) {
      return;
    }

    // Show loading state
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Check backend connection first
      print('🔍 Checking backend connection...');
      final isConnected = await ConnectivityService().checkConnection();

      if (!isConnected) {
        if (mounted) {
          ToastHelper.showError(
            context,
            'Server tidak terhubung. Pastikan:\n'
            '1. Backend server sudah running di port 8000\n'
            '2. Perangkat terhubung ke jaringan yang sama\n'
            '3. Firewall tidak memblokir koneksi',
          );
        }
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      print('✓ Backend connected, attempting login...');

      // Call API login
      final response = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Null safety checks
      if (response.user == null) {
        throw Exception('User data is null after login');
      }

      final userRole = response.user.role;
      final roleLabel = _getRoleLabel(userRole);
      
      print('✓ Login successful: ${response.user.name} ($roleLabel)');

      if (mounted) {
        ToastHelper.showSuccess(context, 'Login berhasil sebagai $roleLabel!');
        
        // Navigate to appropriate dashboard based on user role
        final dashboardRoute = RoleHelper.getDashboardRoute(userRole);
        print('🔄 Redirecting to: $dashboardRoute');
        
        // Add delay to ensure state is properly set
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, dashboardRoute);
        }
      }
    } on ErrorResponse catch (e) {
      print('✗ Login error (API): ${e.detail}');
      if (mounted) {
        ToastHelper.showError(context, e.detail);
      }
    } catch (e) {
      print('✗ Login error: $e');
      if (mounted) {
        ToastHelper.showError(context, 'Login gagal: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
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
                          color: Colors.white.withOpacity(0.9),
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
                              color: Colors.black.withOpacity(0.1),
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
                      
                      // Development Login Helper (hanya tampil di debug mode)
                      if (kDebugMode) ...[
                        const DevLoginHelper(),
                        const SizedBox(height: 16),
                      ],
                      
                      Text(
                        '© 2025 Jawara Pintar. All rights reserved.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
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
