import 'package:flutter/material.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form Controllers
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController nikController;
  late TextEditingController familyNumberController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  late TextEditingController birthPlaceController;

  // Form State
  String? selectedGender;
  DateTime? selectedBirthDate;
  bool isLoading = false;
  bool showPassword = false;
  bool showPasswordConfirm = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    nikController = TextEditingController();
    familyNumberController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    birthPlaceController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    nikController.dispose();
    familyNumberController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    birthPlaceController.dispose();
    super.dispose();
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Email tidak boleh kosong';
    }
    if (!value!.contains('@')) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Password tidak boleh kosong';
    }
    if (value!.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? validateNIK(String? value) {
    if (value?.isEmpty ?? true) {
      return 'NIK tidak boleh kosong';
    }
    if (value!.length != 16) {
      return 'NIK harus 16 digit';
    }
    if (!value.isNumericOnly()) {
      return 'NIK hanya boleh berisi angka';
    }
    return null;
  }

  String? validateFamilyNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Nomor KK tidak boleh kosong';
    }
    if (value!.length != 16) {
      return 'Nomor KK harus 16 digit';
    }
    if (!value.isNumericOnly()) {
      return 'Nomor KK hanya boleh berisi angka';
    }
    return null;
  }

  String? validatePasswordMatch(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Pick birth date
  Future<void> _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  // Handle register
  Future<void> _handleRegister() async {
    if (!formKey.currentState!.validate()) {
      ToastHelper.showError(context, 'Silakan lengkapi semua field');
      return;
    }

    if (selectedGender == null) {
      ToastHelper.showError(context, 'Pilih jenis kelamin');
      return;
    }

    if (selectedBirthDate == null) {
      ToastHelper.showError(context, 'Pilih tanggal lahir');
      return;
    }

    // Check age >= 17
    final today = DateTime.now();
    final age =
        today.year -
        selectedBirthDate!.year -
        ((today.month < selectedBirthDate!.month ||
                (today.month == selectedBirthDate!.month &&
                    today.day < selectedBirthDate!.day))
            ? 1
            : 0);

    if (age < 17) {
      ToastHelper.showError(context, 'Usia minimal 17 tahun untuk registrasi');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService().register(
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirm: passwordConfirmController.text,
        nik: nikController.text.trim(),
        familyNumber: familyNumberController.text.trim(),
        gender: selectedGender!,
        birthDate: selectedBirthDate!,
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        birthPlace: birthPlaceController.text.trim().isEmpty
            ? null
            : birthPlaceController.text.trim(),
      );

      if (mounted) {
        ToastHelper.showSuccess(context, 'Akun berhasil dibuat! 🎉');
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Gagal membuat akun';
        if (e.toString().contains('detail')) {
          errorMessage = e.toString().replaceAll('Exception:', '').trim();
        }
        ToastHelper.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
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
              final isWideScreen = constraints.maxWidth > 600;

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? 48.0 : 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
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
                        'Sistem Manajemen RT yang Modern',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Form Daftar Akun
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isWideScreen ? 720 : double.infinity,
                        ),
                        padding: EdgeInsets.all(isWideScreen ? 32.0 : 24.0),
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
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Daftar Akun Baru 🎉',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Lengkapi formulir untuk membuat akun',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              isWideScreen
                                  ? Column(
                                      children: [
                                        // Identitas Pribadi
                                        _buildTextFormField(
                                          label: 'Nama Lengkap',
                                          hintText: 'Masukkan nama lengkap',
                                          controller: nameController,
                                          validator: (v) => (v?.isEmpty ?? true)
                                              ? 'Nama tidak boleh kosong'
                                              : null,
                                          prefixIcon: Icons.person_outline,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTwoColumnRow(
                                          context,
                                          _buildTextFormField(
                                            label: 'NIK',
                                            hintText: 'Masukkan NIK sesuai KTP',
                                            controller: nikController,
                                            inputType: TextInputType.number,
                                            validator: validateNIK,
                                            prefixIcon:
                                                Icons.perm_identity_rounded,
                                          ),
                                          _buildTextFormField(
                                            label: 'Nomor KK',
                                            hintText: 'Nomor Kartu Keluarga',
                                            controller: familyNumberController,
                                            inputType: TextInputType.number,
                                            validator: validateFamilyNumber,
                                            prefixIcon: Icons.family_restroom,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _buildGenderDropdown(),
                                        _buildTwoColumnRow(
                                          context,
                                          _buildBirthDatePicker(),
                                          _buildTextFormField(
                                            label: 'Tempat Lahir',
                                            hintText: 'Kota/Kabupaten',
                                            controller: birthPlaceController,
                                            prefixIcon:
                                                Icons.location_on_outlined,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Kontak
                                        _buildTwoColumnRow(
                                          context,
                                          _buildTextFormField(
                                            label: 'Email',
                                            hintText: 'Masukkan email aktif',
                                            controller: emailController,
                                            inputType:
                                                TextInputType.emailAddress,
                                            validator: validateEmail,
                                            prefixIcon: Icons.email_outlined,
                                          ),
                                          _buildTextFormField(
                                            label: 'No Telepon',
                                            hintText: '08xxxxxxxxx',
                                            controller: phoneController,
                                            inputType: TextInputType.phone,
                                            prefixIcon:
                                                Icons.phone_android_rounded,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Akun
                                        _buildTextFormField(
                                          label: 'Username',
                                          hintText: 'Username (3+ karakter)',
                                          controller: usernameController,
                                          validator: (v) {
                                            if (v?.isEmpty ?? true)
                                              return 'Username tidak boleh kosong';
                                            if (v!.length < 3)
                                              return 'Username minimal 3 karakter';
                                            return null;
                                          },
                                          prefixIcon:
                                              Icons.account_circle_outlined,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTwoColumnRow(
                                          context,
                                          _buildTextFormField(
                                            label: 'Password',
                                            hintText:
                                                'Masukkan password (6+ karakter)',
                                            controller: passwordController,
                                            isPassword: true,
                                            validator: validatePassword,
                                            prefixIcon: Icons.lock_outline,
                                          ),
                                          _buildTextFormField(
                                            label: 'Konfirmasi Password',
                                            hintText: 'Masukkan ulang password',
                                            controller:
                                                passwordConfirmController,
                                            isPassword: true,
                                            validator: validatePasswordMatch,
                                            prefixIcon: Icons.lock_outline,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _buildTextFormField(
                                          label: 'Nama Lengkap',
                                          hintText: 'Masukkan nama lengkap',
                                          controller: nameController,
                                          validator: (v) => (v?.isEmpty ?? true)
                                              ? 'Nama tidak boleh kosong'
                                              : null,
                                          prefixIcon: Icons.person_outline,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'NIK',
                                          hintText: 'Masukkan NIK sesuai KTP',
                                          controller: nikController,
                                          inputType: TextInputType.number,
                                          validator: validateNIK,
                                          prefixIcon:
                                              Icons.perm_identity_rounded,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'Nomor KK',
                                          hintText: 'Nomor Kartu Keluarga',
                                          controller: familyNumberController,
                                          inputType: TextInputType.number,
                                          validator: validateFamilyNumber,
                                          prefixIcon: Icons.family_restroom,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildGenderDropdown(),
                                        const SizedBox(height: 20),
                                        _buildBirthDatePicker(),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'Tempat Lahir',
                                          hintText: 'Kota/Kabupaten',
                                          controller: birthPlaceController,
                                          prefixIcon:
                                              Icons.location_on_outlined,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'Email',
                                          hintText: 'Masukkan email aktif',
                                          controller: emailController,
                                          inputType: TextInputType.emailAddress,
                                          validator: validateEmail,
                                          prefixIcon: Icons.email_outlined,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'No Telepon',
                                          hintText: '08xxxxxxxxx',
                                          controller: phoneController,
                                          inputType: TextInputType.phone,
                                          prefixIcon:
                                              Icons.phone_android_rounded,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'Username',
                                          hintText: 'Username (3+ karakter)',
                                          controller: usernameController,
                                          validator: (v) {
                                            if (v?.isEmpty ?? true)
                                              return 'Username tidak boleh kosong';
                                            if (v!.length < 3)
                                              return 'Username minimal 3 karakter';
                                            return null;
                                          },
                                          prefixIcon:
                                              Icons.account_circle_outlined,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'Password',
                                          hintText:
                                              'Masukkan password (6+ karakter)',
                                          controller: passwordController,
                                          isPassword: true,
                                          validator: validatePassword,
                                          prefixIcon: Icons.lock_outline,
                                          onPasswordToggle: () {
                                            setState(
                                              () =>
                                                  showPassword = !showPassword,
                                            );
                                          },
                                          showPassword: showPassword,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildTextFormField(
                                          label: 'Konfirmasi Password',
                                          hintText: 'Masukkan ulang password',
                                          controller: passwordConfirmController,
                                          isPassword: true,
                                          validator: validatePasswordMatch,
                                          prefixIcon: Icons.lock_outline,
                                          onPasswordToggle: () {
                                            setState(
                                              () => showPasswordConfirm =
                                                  !showPasswordConfirm,
                                            );
                                          },
                                          showPassword: showPasswordConfirm,
                                        ),
                                      ],
                                    ),

                              const SizedBox(height: 32),
                              // Tombol Buat Akun
                              CustomButton(
                                text: isLoading ? 'Mendaftar...' : 'Buat Akun',
                                icon: Icons.check_circle_outline_rounded,
                                onPressed: isLoading
                                    ? () {}
                                    : () => _handleRegister(),
                              ),

                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Masuk',
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
                      ),

                      const SizedBox(height: 24),

                      // Copyright
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

  // Helper to build TextFormField
  Widget _buildTextFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    IconData? prefixIcon,
    String? Function(String?)? validator,
    VoidCallback? onPasswordToggle,
    bool showPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword && !showPassword,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      showPassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: onPasswordToggle,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0xFF06B6D4), width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedGender,
          decoration: InputDecoration(
            hintText: '-- Pilih Jenis Kelamin --',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(Icons.wc_outlined, color: Colors.grey[600]),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0xFF06B6D4), width: 2),
            ),
          ),
          items: ['Laki-laki', 'Perempuan'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBirthDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickBirthDate,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF06B6D4)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedBirthDate != null
                        ? '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                        : 'Pilih tanggal lahir',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedBirthDate != null
                          ? Colors.black
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwoColumnRow(BuildContext context, Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }
}

extension StringExtension on String {
  bool isNumericOnly() {
    return this == '' ? false : !this.contains(RegExp(r'[^0-9]'));
  }
}
