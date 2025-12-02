import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/card.dart';
import 'package:jawara/shared/theme.dart';

class DashboardFinancePage extends StatefulWidget {
  const DashboardFinancePage({super.key});

  @override
  State<DashboardFinancePage> createState() => _DashboardFinancePageState();
}

class _DashboardFinancePageState extends State<DashboardFinancePage> {
  String _selectedYear = '2025';
  final List<String> _yearOptions = ['2025', '2024', '2023'];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Dashboard Keuangan',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF0F9FF),
              const Color(0xFFE0F2FE),
              Colors.white,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final isMobile = screenWidth < 600;

            // Grid settings
            int summaryCrossAxisCount = isMobile ? 1 : 3;
            int chartCrossAxisCount = isMobile ? 1 : 2;

            double summaryAspectRatio = isMobile ? 1.8 : 2.2;
            double chartAspectRatio = isMobile ? 0.9 : 1.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ringkasan Keuangan',
                              style: AppTheme.headingMedium.copyWith(
                                color: AppTheme.textDark,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pantau keuangan warga Anda',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: AppTheme.shadowSmall,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedYear,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppTheme.primary,
                            ),
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                            items: _yearOptions.map((String year) {
                              return DropdownMenuItem<String>(
                                value: year,
                                child: Text(year),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedYear = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Summary Cards Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: summaryCrossAxisCount,
                    mainAxisSpacing: isMobile ? 12 : 16,
                    crossAxisSpacing: isMobile ? 12 : 16,
                    childAspectRatio: summaryAspectRatio,
                    children: [
                      _buildSummaryCard(
                        title: 'Total Pemasukan',
                        value: 'Rp 5,01 M',
                        subtitle: 'Tagihan: Rp 100 rb + Lainnya: Rp 5 M',
                        icon: Icons.trending_up_rounded,
                        color: AppTheme.accentGreen,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentGreen.withOpacity(0.1),
                            AppTheme.accentGreen.withOpacity(0.05),
                          ],
                        ),
                      ),
                      _buildSummaryCard(
                        title: 'Total Pengeluaran',
                        value: 'Rp 152,1 rb',
                        subtitle: '4 transaksi pengeluaran',
                        icon: Icons.trending_down_rounded,
                        color: AppTheme.accentRed,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentRed.withOpacity(0.1),
                            AppTheme.accentRed.withOpacity(0.05),
                          ],
                        ),
                      ),
                      _buildSummaryCard(
                        title: 'Saldo',
                        value: 'Rp 4,86 M',
                        subtitle: 'Pemasukan - Pengeluaran',
                        icon: Icons.account_balance_wallet_rounded,
                        color: AppTheme.primary,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primary.withOpacity(0.1),
                            AppTheme.primary.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Charts Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: chartCrossAxisCount,
                    mainAxisSpacing: isMobile ? 12 : 16,
                    crossAxisSpacing: isMobile ? 12 : 16,
                    childAspectRatio: chartAspectRatio,
                    children: [
                      _buildChartCard(
                        title: 'Pemasukan per Bulan',
                        icon: Icons.bar_chart_rounded,
                        color: AppTheme.primary,
                        isBarChart: true,
                        isMobile: isMobile,
                      ),
                      _buildChartCard(
                        title: 'Pengeluaran per Bulan',
                        icon: Icons.bar_chart_rounded,
                        color: AppTheme.accentRed,
                        isBarChart: true,
                        isMobile: isMobile,
                      ),
                      _buildChartCard(
                        title: 'Pemasukan Berdasarkan Kategori',
                        icon: Icons.pie_chart_rounded,
                        color: AppTheme.accentOrange,
                        isBarChart: false,
                        isMobile: isMobile,
                      ),
                      _buildChartCard(
                        title: 'Pengeluaran Berdasarkan Kategori',
                        icon: Icons.pie_chart_rounded,
                        color: AppTheme.accentPurple,
                        isBarChart: false,
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper Widget for Summary Cards
  Widget _buildSummaryCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: gradient,
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
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textMedium,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // Helper Widget for Chart Cards
  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isBarChart,
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
          if (isBarChart)
            SizedBox(
              height: isMobile ? 200 : 250,
              child: _buildBarChart(title, isMobile),
            )
          else
            _buildPieChart(title, isMobile),
        ],
      ),
    );
  }

  // Helper Widget untuk Pie Chart
  Widget _buildPieChart(String title, bool isMobile) {
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

    // Data berdasarkan data aktual di aplikasi
    List<PieChartSectionData> sections;
    List<Map<String, dynamic>> legendData;

    if (title.contains('Pemasukan')) {
      // Data pemasukan: Tagihan (100rb) vs Lainnya (5M)
      sections = [
        createSection(AppTheme.accentGreen, 5010700, '98%'),
        createSection(const Color(0xFF34D399), 100000, '2%'),
      ];
      legendData = [
        {'label': 'Pemasukan Lain', 'value': 'Rp 5,01 M', 'color': AppTheme.accentGreen},
        {'label': 'Tagihan Iuran', 'value': 'Rp 100 rb', 'color': const Color(0xFF34D399)},
      ];
    } else {
      // Data pengeluaran berdasarkan kategori aktual
      sections = [
        createSection(AppTheme.accentRed, 100100, '66%'),
        createSection(AppTheme.accentOrange, 51000, '33%'),
        createSection(const Color(0xFFFBBF24), 1000, '1%'),
      ];
      legendData = [
        {'label': 'Operasional', 'value': 'Rp 100 rb', 'color': AppTheme.accentRed},
        {'label': 'Pemeliharaan', 'value': 'Rp 51 rb', 'color': AppTheme.accentOrange},
        {'label': 'Lainnya', 'value': 'Rp 1 rb', 'color': const Color(0xFFFBBF24)},
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

  // Helper Widget untuk Bar Chart
  Widget _buildBarChart(String title, bool isMobile) {
    bool isPemasukan = title.contains('Pemasukan');
    Color barColor = isPemasukan ? AppTheme.accentGreen : AppTheme.accentRed;

    // Data dummy untuk 12 bulan
    List<BarChartGroupData> barGroups = List.generate(12, (index) {
      double value;
      if (isPemasukan) {
        // Simulasi data pemasukan per bulan (dalam jutaan)
        value = (index % 3 == 0)
            ? 0.5
            : (index % 2 == 0)
            ? 0.3
            : 0.4;
      } else {
        // Simulasi data pengeluaran per bulan (dalam ratusan ribu)
        value = (index % 3 == 0)
            ? 0.15
            : (index % 2 == 0)
            ? 0.1
            : 0.12;
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: barColor,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: isPemasukan ? 0.6 : 0.2,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'Mei',
                  'Jun',
                  'Jul',
                  'Agu',
                  'Sep',
                  'Okt',
                  'Nov',
                  'Des',
                ];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}M',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: isPemasukan ? 0.1 : 0.05,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
