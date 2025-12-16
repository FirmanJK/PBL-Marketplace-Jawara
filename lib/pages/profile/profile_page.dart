import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/shared/input.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class ProfilePage extends StatefulWidget {
  final int tabIndex;

  const ProfilePage({super.key, this.tabIndex = 0});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.tabIndex,
    );
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null && mounted) {
      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_isLoading) return;

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ToastHelper.showWarning(context, 'Semua field harus diisi.');
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await _authService.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      if (mounted) {
        ToastHelper.showSuccess(context, 'Profil berhasil diperbarui.');
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

    if (!mounted) return;
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
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Profil',
        bottom: isMobile
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF0891B2),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF0891B2),
                  tabs: const [
                    Tab(text: 'Informasi'),
                    Tab(text: 'Kata Sandi'),
                  ],
                ),
              )
            : null,
      ),
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return TabBarView(
      controller: _tabController,
      children: [_buildProfileInfo(), _buildPasswordChange()],
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildProfileInfo(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(child: _buildPasswordChange()),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _emailController.text,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      color: const Color(0xFF0891B2).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      color: Color(0xFF0891B2),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Informasi Akun',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomInputField(
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama',
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'Email',
                hintText: 'Masukkan email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'No. HP',
                hintText: 'Masukkan nomor HP',
                prefixIcon: Icons.phone_outlined,
                controller: _phoneController,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveProfile,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0891B2),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordChange() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _changePassword,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.key),
                  label: Text(
                    _isLoading ? 'Memperbarui...' : 'Perbarui Kata Sandi',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
