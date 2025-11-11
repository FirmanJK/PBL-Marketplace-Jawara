import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/card.dart';
import 'package:jawara/shared/theme.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1000;

    return BaseLayout(
      title: 'Pemasukan',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pemasukan',
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.textDark,
                  fontSize: isMobile ? 18 : 20,
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                mainAxisSpacing: isMobile ? 12 : 16,
                crossAxisSpacing: isMobile ? 12 : 16,
                childAspectRatio: isMobile ? 2.5 : 2.2,
                children: [
                  SharedCard(
                    title: 'Total Pemasukan',
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppTheme.accentGreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp 5,01 M',
                          style: AppTheme.headingLarge.copyWith(
                            color: AppTheme.accentGreen,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total dari semua kategori',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textMedium,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SharedCard(
                    title: 'Tagihan Iuran',
                    icon: Icons.receipt_long_rounded,
                    color: AppTheme.primary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp 100 rb',
                          style: AppTheme.headingLarge.copyWith(
                            color: AppTheme.primary,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '10 tagihan (@ Rp 10.000)',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textMedium,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SharedCard(
                    title: 'Pemasukan Lainnya',
                    icon: Icons.savings_rounded,
                    color: AppTheme.accentOrange,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp 5,01 M',
                          style: AppTheme.headingLarge.copyWith(
                            color: AppTheme.accentOrange,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '3 transaksi lainnya',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textMedium,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Menu Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.8,
                children: [
                  _buildMenuCard(
                    context,
                    title: 'Kategori Pemasukan',
                    icon: Icons.category_rounded,
                    color: AppTheme.primary,
                    description: 'Kelola kategori pemasukan RT',
                    route: '/income/categories',
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Tagihan Iuran',
                    icon: Icons.receipt_long_rounded,
                    color: AppTheme.accentGreen,
                    description: 'Lihat dan kelola tagihan iuran warga',
                    route: '/income/bills',
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Pemasukan Lainnya',
                    icon: Icons.attach_money_rounded,
                    color: AppTheme.accentOrange,
                    description: 'Kelola pemasukan dari sumber lain',
                    route: '/income/other/list',
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Tambah Pemasukan',
                    icon: Icons.add_circle_rounded,
                    color: AppTheme.accentPurple,
                    description: 'Catat pemasukan baru',
                    route: '/income/other/add',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: AppTheme.borderRadiusMedium,
      child: SharedCard(
        title: title,
        icon: icon,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMedium),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Lihat Detail',
                    style: AppTheme.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
