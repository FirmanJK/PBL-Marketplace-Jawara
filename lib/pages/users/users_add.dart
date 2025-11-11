import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk InputFormatter
// import 'package:intl/intl.dart'; // Tidak perlu format tanggal
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart'; // Import CustomButton
import 'package:jawara/shared/theme.dart'; // Import tema

class UsersAddPage extends StatefulWidget {
  const UsersAddPage({super.key});

  @override
  State<UsersAddPage> createState() => _UsersAddPageState();
}

class _UsersAddPageState extends State<UsersAddPage> {
  // Controllers
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  String? _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Options for dropdown
  final List<String> _roleOptions = [
    '-- Pilih Role --',
    'Admin',
    'Operator',
    'Viewer',
    // Tambahkan role lain jika ada
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _emailController.clear();
      _hpController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedRole = null;
      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });
  }

  void _submitForm() {
    // Implement submit logic here
    // Validasi password cocok, dll.
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan Konfirmasi Password tidak cocok!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint('Nama: ${_namaController.text}');
    debugPrint('Email: ${_emailController.text}');
    debugPrint('Nomor HP: ${_hpController.text}');
    debugPrint(
      'Password: ${_passwordController.text}',
    ); // Hati-hati logging password
    debugPrint('Role: $_selectedRole');
    // Panggil API atau fungsi simpan data pengguna
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
              Text(
                'Tambah Akun Pengguna', // Judul Form
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 32),

              // Nama Lengkap
              _buildTextField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                controller: _namaController,
              ),
              const SizedBox(height: 24),

              // Email
              _buildTextField(
                label: 'Email',
                hint: 'Masukkan email aktif',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Nomor HP
              _buildTextField(
                label: 'Nomor HP',
                hint: 'cth: 08xxxxxxxxxx',
                controller: _hpController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              ),
              const SizedBox(height: 24),

              // Role Dropdown
              _buildDropdownField(
                label: 'Role',
                hint: '-- Pilih Role --',
                value: _selectedRole,
                items: _roleOptions,
                onChanged: (value) {
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
                    width: 120, // Sesuaikan lebar jika perlu
                    child: CustomButton(
                      text: 'Simpan', // Tombol Simpan
                      onPressed: _submitForm,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: AppTheme.textMedium),
                    ), // Tombol Reset
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppTheme.textMedium,
              ),
              onPressed: onToggleVisibility,
            ),
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
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
              value: item == hint ? null : item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == hint ? Colors.grey[400] : AppTheme.textDark,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          menuMaxHeight: 300,
        ),
      ],
    );
  }
}
