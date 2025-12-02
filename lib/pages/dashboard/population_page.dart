import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/card.dart';
import 'package:jawara/shared/theme.dart';

class DashboardPopulationPage extends StatefulWidget {
  const DashboardPopulationPage({super.key});

  @override
  State<DashboardPopulationPage> createState() =>
      _DashboardPopulationPageState();
}

class _DashboardPopulationPageState extends State<DashboardPopulationPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return BaseLayout(
      title: 'Dashboard Kependudukan',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5F3FF),
              const Color(0xFFEDE9FE),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Kependudukan',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data demografi dan statistik warga',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Summary Cards
              _buildSummaryCards(isMobile),
              const SizedBox(height: 24),

              // Charts Grid
              _buildChartsGrid(isMobile),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(bool isMobile) {
    if (isMobile) {
      // Mobile: Stack vertically
      return Column(
        children: [
          _buildSummaryCard(
            title: 'Total Keluarga',
            value: '10',
            subtitle: 'Keluarga terdaftar',
            icon: Icons.family_restroom_rounded,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 12),
          _buildSummaryCard(
            title: 'Total Penduduk',
            value: '12',
            subtitle: 'Warga terdaftar',
            icon: Icons.people_alt_rounded,
            color: AppTheme.accentGreen,
          ),
        ],
      );
    } else {
      // Desktop: Side by side
      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Keluarga',
              value: '10',
              subtitle: 'Keluarga terdaftar',
              icon: Icons.family_restroom_rounded,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Penduduk',
              value: '12',
              subtitle: 'Warga terdaftar',
              icon: Icons.people_alt_rounded,
              color: AppTheme.accentGreen,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildChartsGrid(bool isMobile) {
    if (isMobile) {
      // Mobile: Stack vertically
      return Column(
        children: [
          _buildChartCard(
            title: 'Status Penduduk',
            icon: Icons.toggle_on_rounded,
            color: AppTheme.accentOrange,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildChartCard(
            title: 'Jenis Kelamin',
            icon: Icons.wc_rounded,
            color: AppTheme.primaryLight,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildChartCard(
            title: 'Pekerjaan Penduduk',
            icon: Icons.work_rounded,
            color: AppTheme.accentPurple,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildChartCard(
            title: 'Peran dalam Keluarga',
            icon: Icons.group_work_rounded,
            color: AppTheme.secondary,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildChartCard(
            title: 'Agama',
            icon: Icons.mosque_rounded,
            color: Colors.pink.shade400,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildChartCard(
            title: 'Pendidikan',
            icon: Icons.school_rounded,
            color: Colors.teal.shade400,
            isMobile: isMobile,
          ),
        ],
      );
    } else {
      // Desktop: 2 columns grid
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildChartCard(
            title: 'Status Penduduk',
            icon: Icons.toggle_on_rounded,
            color: AppTheme.accentOrange,
            isMobile: isMobile,
          ),
          _buildChartCard(
            title: 'Jenis Kelamin',
            icon: Icons.wc_rounded,
            color: AppTheme.primaryLight,
            isMobile: isMobile,
          ),
          _buildChartCard(
            title: 'Pekerjaan Penduduk',
            icon: Icons.work_rounded,
            color: AppTheme.accentPurple,
            isMobile: isMobile,
          ),
          _buildChartCard(
            title: 'Peran dalam Keluarga',
            icon: Icons.group_work_rounded,
            color: AppTheme.secondary,
            isMobile: isMobile,
          ),
          _buildChartCard(
            title: 'Agama',
            icon: Icons.mosque_rounded,
            color: Colors.pink.shade400,
            isMobile: isMobile,
          ),
          _buildChartCard(
            title: 'Pendidikan',
            icon: Icons.school_rounded,
            color: Colors.teal.shade400,
            isMobile: isMobile,
          ),
        ],
      );
    }
  }

  // Helper Widget for Summary Cards
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.08),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.25),
                      color.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTheme.headingLarge.copyWith(
              color: color,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textMedium,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Chart Cards
  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.2),
                      color.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPieChartByTitle(title, color, isMobile),
        ],
      ),
    );
  }

  // Helper untuk membuat pie chart berdasarkan judul
  Widget _buildPieChartByTitle(String title, Color baseColor, bool isMobile) {
    final double radius = isMobile ? 40 : 55;
    final double fontSize = isMobile ? 10 : 12;
    final double centerSpaceRadius = isMobile ? 25 : 35;

    // Helper untuk membuat section dengan responsive size
    PieChartSectionData createSection(
      Color color,
      double value,
      String titleText,
    ) {
      return PieChartSectionData(
        color: color,
        value: value,
        title: titleText,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    List<PieChartSectionData> sections;
    List<Map<String, dynamic>> legendData;

    // Data berdasarkan 12 penduduk aktual
    if (title.contains('Status')) {
      // Status Hidup: 11 Hidup, 1 Wafat
      sections = [
        createSection(AppTheme.accentGreen, 11, '92%'),
        createSection(AppTheme.textMedium, 1, '8%'),
      ];
      legendData = [
        {'label': 'Hidup', 'value': '11', 'color': AppTheme.accentGreen},
        {'label': 'Wafat', 'value': '1', 'color': AppTheme.textMedium},
      ];
    } else if (title.contains('Jenis Kelamin')) {
      // 10 Laki-laki, 2 Perempuan
      sections = [
        createSection(AppTheme.primary, 10, '83%'),
        createSection(Colors.pink.shade400, 2, '17%'),
      ];
      legendData = [
        {'label': 'Laki-laki', 'value': '10', 'color': AppTheme.primary},
        {'label': 'Perempuan', 'value': '2', 'color': Colors.pink.shade400},
      ];
    } else if (title.contains('Pekerjaan')) {
      // Distribusi pekerjaan
      sections = [
        createSection(AppTheme.accentPurple, 5, '42%'),
        createSection(AppTheme.accentPurple.withOpacity(0.7), 4, '33%'),
        createSection(AppTheme.accentPurple.withOpacity(0.4), 3, '25%'),
      ];
      legendData = [
        {'label': 'Wiraswasta', 'value': '5', 'color': AppTheme.accentPurple},
        {'label': 'Karyawan', 'value': '4', 'color': AppTheme.accentPurple.withOpacity(0.7)},
        {'label': 'Lainnya', 'value': '3', 'color': AppTheme.accentPurple.withOpacity(0.4)},
      ];
    } else if (title.contains('Peran')) {
      // Peran: 10 Kepala Keluarga, 2 lainnya
      sections = [
        createSection(AppTheme.secondary, 10, '83%'),
        createSection(AppTheme.secondaryLight, 2, '17%'),
      ];
      legendData = [
        {'label': 'Kepala Keluarga', 'value': '10', 'color': AppTheme.secondary},
        {'label': 'Anggota', 'value': '2', 'color': AppTheme.secondaryLight},
      ];
    } else if (title.contains('Agama')) {
      // Mayoritas Islam
      sections = [
        createSection(Colors.pink.shade400, 10, '83%'),
        createSection(Colors.pink.shade200, 2, '17%'),
      ];
      legendData = [
        {'label': 'Islam', 'value': '10', 'color': Colors.pink.shade400},
        {'label': 'Lainnya', 'value': '2', 'color': Colors.pink.shade200},
      ];
    } else {
      // Pendidikan
      sections = [
        createSection(Colors.teal.shade600, 5, '42%'),
        createSection(Colors.teal.shade400, 4, '33%'),
        createSection(Colors.teal.shade200, 3, '25%'),
      ];
      legendData = [
        {'label': 'SMA/SMK', 'value': '5', 'color': Colors.teal.shade600},
        {'label': 'S1', 'value': '4', 'color': Colors.teal.shade400},
        {'label': 'SMP', 'value': '3', 'color': Colors.teal.shade200},
      ];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isMobile ? 100 : 130,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: centerSpaceRadius,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...legendData.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 11,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                Text(
                  item['value'],
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
