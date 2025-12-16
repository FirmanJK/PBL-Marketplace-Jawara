import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:intl/intl.dart';

class PopulationPage extends StatelessWidget {
  const PopulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk statistik kependudukan
    final int totalWarga = 1234;
    final int totalKeluarga = 456;
    final int totalRumah = 320;
    
    return Scaffold(
      appBar: StandardAppBar(title: 'Kependudukan'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.family_restroom,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Data Kependudukan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Warga', '$totalWarga'),
                    _buildStatItem('Keluarga', '$totalKeluarga'),
                    _buildStatItem('Rumah', '$totalRumah'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildMenuCard(
            context,
            icon: Icons.people_outline,
            title: 'Data Warga',
            subtitle: 'Kelola data warga',
            color: const Color(0xFF3B82F6),
            route: '/residents/list',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.person_add_outlined,
            title: 'Tambah Warga',
            subtitle: 'Daftarkan warga baru',
            color: const Color(0xFF10B981),
            route: '/residents/add',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.family_restroom_outlined,
            title: 'Data Keluarga',
            subtitle: 'Kelola data keluarga',
            color: const Color(0xFF8B5CF6),
            route: '/families',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.home_outlined,
            title: 'Data Rumah',
            subtitle: 'Kelola data rumah',
            color: const Color(0xFFF59E0B),
            route: '/houses/list',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.add_home_outlined,
            title: 'Tambah Rumah',
            subtitle: 'Daftarkan rumah baru',
            color: const Color(0xFF06B6D4),
            route: '/houses/add',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.swap_horiz_outlined,
            title: 'Mutasi Data',
            subtitle: 'Kelola perubahan data',
            color: const Color(0xFFEC4899),
            route: '/mutations',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}