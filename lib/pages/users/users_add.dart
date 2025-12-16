import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/users_service.dart';

class UsersAddPage extends StatefulWidget {
  const UsersAddPage({super.key});

  @override
  State<UsersAddPage> createState() => _UsersAddPageState();
}

class _UsersAddPageState extends State<UsersAddPage> {
  // Controllers
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  String? _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  // Options for dropdown (sesuai BUSINESS_FLOW.md)
  final List<String> _roleOptions = [
    'admin',
    'ketua_rw',
    'ketua_rt',
    'sekretaris',
    'bendahara',
    'warga',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Validation
    setState(() => _errorMessage = null);

    if (_namaController.text.isEmpty) {
      setState(() => _errorMessage = 'Nama tidak boleh kosong');
      return;
    }

    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = 'Email tidak boleh kosong');
      return;
    }

    if (_usernameController.text.isEmpty) {
      setState(() => _errorMessage = 'Username tidak boleh kosong');
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Password tidak boleh kosong');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(
        () => _errorMessage = 'Password dan Konfirmasi Password tidak cocok!',
      );
      return;
    }

    if (_selectedRole == null || _selectedRole!.isEmpty) {
      setState(() => _errorMessage = 'Pilih role terlebih dahulu');
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Password minimal 6 karakter');
      return;
    }

    // Submit
    setState(() => _isSubmitting = true);

    try {
      final user = await UsersService.createUser(
        name: _namaController.text,
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        phone: _hpController.text.isEmpty ? null : _hpController.text,
        role: _selectedRole!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengguna ${user.name} berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Gagal menambah pengguna: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Tambah Pengguna',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusXLarge,
            boxShadow: AppTheme.shadowMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Akun Pengguna', style: AppTheme.headingMedium),
              const SizedBox(height: 32),
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() => _errorMessage = null);
                        },
                      ),
                    ],
                  ),
                ),

              // Nama Lengkap
              _buildTextField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                controller: _namaController,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 24),

              // Email
              _buildTextField(
                label: 'Email',
                hint: 'Masukkan email aktif',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 24),

              // Username
              _buildTextField(
                label: 'Username',
                hint: 'Masukkan username',
                controller: _usernameController,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 24),

              // Nomor HP
              _buildTextField(
                label: 'Nomor HP',
                hint: 'cth: 08xxxxxxxxxx',
                controller: _hpController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 24),

              // Password
              _buildPasswordField(
                label: 'Password',
                hint: 'Masukkan password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 24),

              // Konfirmasi Password
              _buildPasswordField(
                label: 'Konfirmasi Password',
                hint: 'Masukkan ulang password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 24),

              // Role Dropdown
              _buildDropdownField(
                label: 'Role',
                hint: '-- Pilih Role --',
                value: _selectedRole,
                items: _roleOptions,
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomButton(
                      text: _isSubmitting ? 'Menyimpan...' : 'Simpan',
                      onPressed: _isSubmitting ? () {} : _submitForm,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _isSubmitting ? null : _resetForm,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: AppTheme.textMedium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppTheme.textMedium,
              ),
              onPressed: enabled ? onToggleVisibility : null,
            ),
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusLarge,
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                _getRoleLabel(item),
                style: const TextStyle(color: AppTheme.textDark),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          menuMaxHeight: 300,
        ),
      ],
    );
  }

  // Helper method untuk role label display (sesuai BUSINESS_FLOW.md)
  String _getRoleLabel(String role) {
    const Map<String, String> roleLabels = {
      'admin': 'Admin Sistem',
      'ketua_rw': 'Ketua RW',
      'ketua_rt': 'Ketua RT',
      'sekretaris': 'Sekretaris',
      'bendahara': 'Bendahara',
      'warga': 'Warga',
    };
    return roleLabels[role] ?? role;
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _emailController.clear();
      _usernameController.clear();
      _hpController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedRole = null;
      _obscurePassword = true;
      _obscureConfirmPassword = true;
      _errorMessage = null;
    });
  }
}
