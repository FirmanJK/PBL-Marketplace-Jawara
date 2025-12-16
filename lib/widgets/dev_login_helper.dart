import 'package:flutter/material.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/role_helper.dart';
import 'package:jawara/utils/test_helper.dart';
import 'package:jawara/data/demo_users.dart';
import 'package:jawara/utils/toast_helper.dart';

/// Widget helper untuk development - Quick login dengan role berbeda
class DevLoginHelper extends StatefulWidget {
  const DevLoginHelper({super.key});

  @override
  State<DevLoginHelper> createState() => _DevLoginHelperState();
}

class _DevLoginHelperState extends State<DevLoginHelper> {
  bool _isLoading = false;
  bool _showCredentials = false;

  Future<void> _quickLogin(UserRole role) async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final credentials = DemoUsers.getCredentialsForRole(role);
      final authService = AuthService();
      
      final response = await authService.login(
        credentials['email']!,
        credentials['password']!,
      );
      
      if (!mounted) return;
      
      // Show success message
      ToastHelper.showSuccess(
        context, 
        'Login berhasil sebagai ${_getRoleLabel(role)}',
      );
      
      // Navigate to appropriate dashboard
      final dashboardRoute = RoleHelper.getDashboardRoute(response.user.role);
      Navigator.pushNamedAndRemoveUntil(
        context,
        dashboardRoute,
        (route) => false,
      );
      
    } catch (e) {
      if (!mounted) return;
      ToastHelper.showError(
        context,
        'Login gagal: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.developer_mode, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Development Login Helper',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() => _showCredentials = !_showCredentials);
                },
                icon: Icon(
                  _showCredentials ? Icons.visibility_off : Icons.visibility,
                  color: Colors.orange,
                  size: 20,
                ),
                tooltip: 'Show/Hide Credentials',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Quick login untuk testing dengan role berbeda:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          
          // Login buttons untuk setiap role
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserRole.values.map((role) {
              return _buildRoleButton(role);
            }).toList(),
          ),
          
          // Show credentials if toggled
          if (_showCredentials) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Login Credentials:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            ...DemoUsers.getUsersData().map((user) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleColor(UserRoleExtension.fromString(user['role'])).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getRoleLabel(UserRoleExtension.fromString(user['role'])),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getRoleColor(UserRoleExtension.fromString(user['role'])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${user['email']} / ${user['password']}',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
          
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.adminSistem:
        return Colors.red;
      case UserRole.ketuaRT:
        return Colors.blue;
      case UserRole.sekretaris:
        return Colors.green;
      case UserRole.bendahara:
        return Colors.purple;
      case UserRole.warga:
        return Colors.orange;
    }
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

  Widget _buildRoleButton(UserRole role) {
    final color = _getRoleColor(role);
    IconData icon;
    
    switch (role) {
      case UserRole.adminSistem:
        icon = Icons.admin_panel_settings;
        break;
      case UserRole.ketuaRT:
        icon = Icons.account_balance;
        break;
      case UserRole.sekretaris:
        icon = Icons.edit_document;
        break;
      case UserRole.bendahara:
        icon = Icons.account_balance_wallet;
        break;
      case UserRole.warga:
        icon = Icons.person;
        break;
    }
    
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : () => _quickLogin(role),
      icon: Icon(icon, size: 16),
      label: Text(
        _getRoleLabel(role),
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// Widget untuk menampilkan informasi user yang sedang login
class CurrentUserInfo extends StatelessWidget {
  const CurrentUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    
    if (user == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${user.role.label} • ${user.email}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, size: 20),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}

/// Widget untuk menampilkan credentials demo
class DemoCredentials extends StatelessWidget {
  const DemoCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    final demoUsers = TestHelper.getDemoUsers();
    
    return ExpansionTile(
      title: const Text('Demo Login Credentials'),
      leading: const Icon(Icons.key),
      children: demoUsers.map((user) {
        return ListTile(
          title: Text(user['name']),
          subtitle: Text('${user['email']} / ${user['password']}'),
          trailing: Chip(
            label: Text(
              UserRoleExtension.fromString(user['role']).label,
              style: const TextStyle(fontSize: 10),
            ),
          ),
          onTap: () {
            // Copy credentials to clipboard
            final credentials = '${user['email']} / ${user['password']}';
            // You can implement clipboard copy here if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Credentials: $credentials'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}