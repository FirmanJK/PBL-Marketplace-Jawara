import 'package:flutter/material.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/models/auth_response.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? token;
  
  const ResetPasswordPage({super.key, this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;
  bool _passwordReset = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      _passwordError = null;
      _confirmPasswordError = null;

      // Validate password
      if (_passwordController.text.trim().isEmpty) {
        _passwordError = 'Password tidak boleh kosong';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
      }

      // Validate confirm password
      if (_confirmPasswordController.text.trim().isEmpty) {
        _confirmPasswordError = 'Konfirmasi password tidak boleh kosong';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Password tidak sama';
      }
    });

    // If validation errors, don't proceed
    if (_passwordError != null || _confirmPasswordError != null) {
      return;
    }

    // Show loading state
    setState(() => _isLoading = true);

    try {
      // Call AuthService to reset password
      final token = widget.token ?? 'demo_reset_token';
      await _authService.resetPassword(token, _passwordController.text.trim());

      if (mounted) {
        setState(() {
          _passwordReset = true;
          _isLoading = false;
        });
        
        ToastHelper.showSuccess(
          context, 
          'Password berhasil direset!'
        );
      }
    } on ErrorResponse catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastHelper.showError(context, e.detail);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastHelper.showError(
          context, 
          'Gagal reset password: ${e.toString()}'
        );
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                    child: Icon(
                      _passwordReset ? Icons.check_circle : Icons.lock_reset,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    _passwordReset ? 'Password Berhasil Direset!' : 'Reset Password',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    _passwordReset 
                      ? 'Anda sekarang dapat login dengan password baru'
                      : 'Masukkan password baru Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Form atau Success Message
                  Container(
                    constraints: const BoxConstraints(maxWidth: 480),
                    padding: const EdgeInsets.all(32.0),
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
                    child: _passwordReset ? _buildSuccessContent() : _buildFormContent(),
                  ),
                  const SizedBox(height: 24),
                  
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
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      children: [
        const Text(
          'Password Baru 🔐',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Masukkan password baru yang aman dan mudah diingat',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        CustomInputField(
          label: 'Password Baru',
          hintText: 'Masukkan password baru',
          isPassword: true,
          prefixIcon: Icons.lock_outline,
          controller: _passwordController,
          errorText: _passwordError,
        ),
        const SizedBox(height: 20),
        
        CustomInputField(
          label: 'Konfirmasi Password',
          hintText: 'Masukkan ulang password baru',
          isPassword: true,
          prefixIcon: Icons.lock_outline,
          controller: _confirmPasswordController,
          errorText: _confirmPasswordError,
        ),
        const SizedBox(height: 32),
        
        CustomButton(
          text: _isLoading ? 'Memproses...' : 'Reset Password',
          icon: _isLoading ? null : Icons.save,
          onPressed: _isLoading ? () {} : _resetPassword,
        ),
        const SizedBox(height: 24),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingat password? ',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, 
                '/login', 
                (route) => false
              ),
              child: const Text(
                'Kembali Login',
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
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        
        const Text(
          'Password Berhasil Direset!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        
        Text(
          'Password Anda telah berhasil diubah. Sekarang Anda dapat login dengan password baru.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        CustomButton(
          text: 'Login Sekarang',
          icon: Icons.login,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login', 
            (route) => false
          ),
        ),
      ],
    );
  }
}