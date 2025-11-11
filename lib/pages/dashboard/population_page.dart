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
    return BaseLayout(
      title: 'Dashboard Kependudukan',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringkasan Kependudukan',
                style: AppTheme.headingSmall.copyWith(color: AppTheme.textDark),
              ),
              const SizedBox(height: 16),

              // Summary Cards
              _buildSummaryCards(),
              const SizedBox(height: 24),

              // Charts Grid
              _buildChartsGrid(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 1 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isMobile ? 2.2 : 2.5,
          children: [
            _buildSummaryCard(
              title: 'Total Keluarga',
              value: '10',
              icon: Icons.family_restroom_rounded,
              color: AppTheme.primary,
            ),
            _buildSummaryCard(
              title: 'Total Penduduk',
              value: '12',
              icon: Icons.people_alt_rounded,
              color: AppTheme.accentGreen,
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 1 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isMobile ? 0.95 : 1.0,
          children: [
            _buildChartCard(
              title: 'Status Penduduk',
              icon: Icons.toggle_on_rounded,
              color: AppTheme.accentOrange,
            ),
            _buildChartCard(
              title: 'Jenis Kelamin',
              icon: Icons.wc_rounded,
              color: AppTheme.primaryLight,
            ),
            _buildChartCard(
              title: 'Pekerjaan Penduduk',
              icon: Icons.work_rounded,
              color: AppTheme.accentPurple,
            ),
            _buildChartCard(
              title: 'Peran dalam Keluarga',
              icon: Icons.group_work_rounded,
              color: AppTheme.secondary,
            ),
            _buildChartCard(
              title: 'Agama',
              icon: Icons.mosque_rounded,
              color: Colors.pink.shade400,
            ),
            _buildChartCard(
              title: 'Pendidikan',
              icon: Icons.school_rounded,
              color: Colors.teal.shade400,
            ),
          ],
        );
      },
    );
  }

  // Helper Widget for Summary Cards
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return SharedCard(
      title: title,
      icon: icon,
      color: color,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTheme.headingLarge.copyWith(color: color, fontSize: 36),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  // Helper Widget for Chart Cards
  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SharedCard(
      title: title,
      icon: icon,
      color: color,
      child: Container(
        height: isMobile ? 200 : 250,
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: _buildPieChartByTitle(title, color, isMobile),
      ),
    );
  }

  // Helper untuk membuat pie chart berdasarkan judul
  Widget _buildPieChartByTitle(String title, Color baseColor, bool isMobile) {
    final double radius = isMobile ? 55 : 70;
    final double fontSize = isMobile ? 12 : 14;
    final double centerSpaceRadius = isMobile ? 35 : 45;

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

    // Data berdasarkan 12 penduduk aktual
    if (title.contains('Status')) {
      // Status Hidup: 11 Hidup, 1 Wafat
      sections = [
        createSection(Colors.green.shade400, 11, '91.7%'),
        createSection(Colors.grey.shade400, 1, '8.3%'),
      ];
    } else if (title.contains('Jenis Kelamin')) {
      // 10 Laki-laki, 2 Perempuan
      sections = [
        createSection(Colors.blue.shade400, 10, '83.3%'),
        createSection(Colors.pink.shade400, 2, '16.7%'),
      ];
    } else if (title.contains('Pekerjaan')) {
      // Contoh distribusi (data dummy realistis)
      sections = [
        createSection(const Color(0xFF8B5CF6), 4, '33.3%'),
        createSection(const Color(0xFFA78BFA), 4, '33.3%'),
        createSection(const Color(0xFFC4B5FD), 4, '33.3%'),
      ];
    } else if (title.contains('Peran')) {
      // Peran: 10 Kepala Keluarga, 2 lainnya
      sections = [
        createSection(const Color(0xFF06B6D4), 10, '83.3%'),
        createSection(const Color(0xFF22D3EE), 2, '16.7%'),
      ];
    } else if (title.contains('Agama')) {
      // Mayoritas Islam (contoh)
      sections = [
        createSection(Colors.pink.shade300, 10, '83.3%'),
        createSection(Colors.pink.shade500, 2, '16.7%'),
      ];
    } else {
      // Pendidikan (contoh distribusi)
      sections = [
        createSection(Colors.teal.shade300, 4, '33.3%'),
        createSection(Colors.teal.shade500, 5, '41.7%'),
        createSection(Colors.teal.shade700, 3, '25%'),
      ];
    }

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: centerSpaceRadius,
        sectionsSpace: 3,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
