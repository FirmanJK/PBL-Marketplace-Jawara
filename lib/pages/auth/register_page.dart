import 'package:flutter/material.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/input.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                                      _buildTwoColumnRow(
                                        context,
                                        const CustomInputField(
                                          label: 'Nama Lengkap',
                                          hintText: 'Masukkan nama lengkap',
                                        ),
                                        const CustomInputField(
                                          label: 'NIK',
                                          hintText: 'Masukkan NIK sesuai KTP',
                                          prefixIcon:
                                              Icons.perm_identity_rounded,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTwoColumnRow(
                                        context,
                                        const CustomInputField(
                                          label: 'Email',
                                          hintText: 'Masukkan email aktif',
                                          prefixIcon: Icons.email_outlined,
                                        ),
                                        const CustomInputField(
                                          label: 'No Telepon',
                                          hintText: '08xxxxxxxxx',
                                          prefixIcon:
                                              Icons.phone_android_rounded,
                                          inputType: TextInputType.phone,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTwoColumnRow(
                                        context,
                                        const CustomInputField(
                                          label: 'Password',
                                          hintText: 'Masukkan password',
                                          isPassword: true,
                                          prefixIcon: Icons.lock_outline,
                                        ),
                                        const CustomInputField(
                                          label: 'Konfirmasi Password',
                                          hintText: 'Masukkan ulang password',
                                          isPassword: true,
                                          prefixIcon: Icons.lock_outline,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTwoColumnRow(
                                        context,
                                        _buildGenderDropdown(),
                                        _buildExistingHomeDropdown(),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const CustomInputField(
                                        label: 'Nama Lengkap',
                                        hintText: 'Masukkan nama lengkap',
                                      ),
                                      const SizedBox(height: 20),
                                      const CustomInputField(
                                        label: 'NIK',
                                        hintText: 'Masukkan NIK sesuai KTP',
                                        prefixIcon: Icons.perm_identity_rounded,
                                      ),
                                      const SizedBox(height: 20),
                                      const CustomInputField(
                                        label: 'Email',
                                        hintText: 'Masukkan email aktif',
                                        prefixIcon: Icons.email_outlined,
                                      ),
                                      const SizedBox(height: 20),
                                      const CustomInputField(
                                        label: 'No Telepon',
                                        hintText: '08xxxxxxxxx',
                                        prefixIcon: Icons.phone_android_rounded,
                                        inputType: TextInputType.phone,
                                      ),
                                      const SizedBox(height: 20),
                                      const CustomInputField(
                                        label: 'Password',
                                        hintText: 'Masukkan password',
                                        isPassword: true,
                                        prefixIcon: Icons.lock_outline,
                                      ),
                                      const SizedBox(height: 20),
                                      const CustomInputField(
                                        label: 'Konfirmasi Password',
                                        hintText: 'Masukkan ulang password',
                                        isPassword: true,
                                        prefixIcon: Icons.lock_outline,
                                      ),
                                      const SizedBox(height: 20),
                                      _buildGenderDropdown(),
                                      const SizedBox(height: 20),
                                      _buildExistingHomeDropdown(),
                                    ],
                                  ),

                            const SizedBox(height: 20),
                            const CustomInputField(
                              label: 'Alamat Rumah (Jika Tidak Ada di List)',
                              hintText: 'Blok 5A / No.10',
                            ),
                            const SizedBox(height: 20),
                            _buildHomeOwnershipDropdown(),
                            const SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Foto Identitas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Color(0xFF06B6D4),
                                        size: 30,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Upload foto KK/KTP (.png/.jpg)',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CustomButton(
                                        text: 'Pilih File',
                                        onPressed: () {
                                          debugPrint('Pilih File Identitas');
                                        },
                                        isOutlined: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Tombol Buat Akun
                            CustomButton(
                              text: 'Buat Akun',
                              icon: Icons.check_circle_outline_rounded,
                              onPressed: () {
                                // Tampilkan dialog sukses
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF10B981),
                                          size: 28,
                                        ),
                                        SizedBox(width: 12),
                                        Text('Berhasil!'),
                                      ],
                                    ),
                                    content: const Text(
                                      'Akun Anda berhasil dibuat. Silakan login untuk melanjutkan.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (route) => false,
                                          );
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Color(0xFF06B6D4),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                                    // Coba pop dulu, kalau tidak bisa maka push ke login
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
          decoration: InputDecoration(
            hintText: '-- Pilih Jenis Kelamin --',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
            debugPrint('Jenis Kelamin dipilih: $newValue');
          },
        ),
      ],
    );
  }

  Widget _buildExistingHomeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Rumah yang Sudah Ada',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: '-- Pilih Rumah --',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
          items: ['Blok A/1', 'Blok B/2', 'Blok C/3'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            debugPrint('Rumah dipilih: $newValue');
          },
          validator: (value) {
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHomeOwnershipDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status kepemilikan rumah',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: '-- Pilih Status --',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
          items: ['Milik Sendiri', 'Sewa', 'Lainnya'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            debugPrint('Status dipilih: $newValue');
          },
        ),
      ],
    );
  }
}
