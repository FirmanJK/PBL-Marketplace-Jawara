import 'package:flutter/material.dart';
import 'package:jawara/pages/auth/login_page.dart';
import 'package:jawara/pages/auth/register_page.dart';
import 'package:jawara/pages/auth/forgot_password_page.dart';
import 'package:jawara/pages/auth/reset_password_page.dart';
import 'package:jawara/pages/dashboard/sekretaris_dashboard.dart';
import 'package:jawara/pages/dashboard/ketua_rt_dashboard.dart';
import 'package:jawara/pages/dashboard/bendahara_dashboard.dart';
import 'package:jawara/pages/dashboard/warga_dashboard.dart';
import 'package:jawara/pages/admin_dashboard_page.dart';
import 'package:jawara/pages/residents/residents_list.dart';
import 'package:jawara/pages/residents/residents_add.dart';
import 'package:jawara/pages/residents/residents_edit.dart';
import 'package:jawara/pages/residents/families_page.dart';
import 'package:jawara/pages/residents/houses_list.dart';
import 'package:jawara/pages/residents/houses_add.dart';
import 'package:jawara/pages/income/income.dart';
import 'package:jawara/pages/spending/spending.dart';
import 'package:jawara/pages/reports/reports_income.dart';
import 'package:jawara/pages/reports/reports_spending.dart';
import 'package:jawara/pages/reports/reports_print.dart';
import 'package:jawara/pages/activities/activities_list.dart';
import 'package:jawara/pages/activities/activities_data_list.dart';
import 'package:jawara/pages/activities/activities_add.dart';

import 'package:jawara/pages/activities/broadcast_list.dart';
import 'package:jawara/pages/activities/broadcast_add.dart';
import 'package:jawara/pages/activities/activity_logs_page.dart';
import 'package:jawara/pages/messages/resident_messages.dart';
import 'package:jawara/pages/approvals/resident_approvals.dart';
import 'package:jawara/pages/notifications/notifications_page.dart';
import 'package:jawara/pages/marketplace/marketplace_page.dart';
import 'package:jawara/pages/marketplace/marketplace_cart_page.dart';
import 'package:jawara/pages/marketplace/marketplace_catalog_page.dart';
import 'package:jawara/pages/marketplace/marketplace_upload_page.dart';
import 'package:jawara/pages/marketplace/marketplace_checkout_page.dart';
import 'package:jawara/pages/marketplace/marketplace_cart_checkout_page.dart';
import 'package:jawara/pages/marketplace/marketplace_transactions_page.dart';
import 'package:jawara/pages/mutations/mutations_main_page.dart';
import 'package:jawara/pages/mutations/family_mutations_list.dart';
import 'package:jawara/pages/mutations/family_mutations_add.dart';
import 'package:jawara/pages/income/income_categories.dart';
import 'package:jawara/pages/income/income_bills.dart';
import 'package:jawara/pages/income/income_bill.dart';
import 'package:jawara/pages/income/income_other_list.dart';
import 'package:jawara/pages/income/income_other_add.dart';
import 'package:jawara/pages/spending/spending_add.dart';
import 'package:jawara/pages/spending/spending_list.dart';
import 'package:jawara/pages/users/user_management.dart';
import 'package:jawara/pages/profile/profile_page.dart';
import 'package:jawara/pages/settings/settings_page.dart';
import 'package:jawara/pages/help_page.dart';
import 'package:jawara/pages/about_page.dart';
import 'package:jawara/pages/finance_page.dart';
import 'package:jawara/pages/residents/population_page.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/services/database_service.dart';
import 'package:jawara/services/notification_service.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/models/marketplace_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services with minimal setup
  try {
    await DatabaseService().database;
    print('✓ Database initialized');
  } catch (e) {
    print('✗ Database initialization failed: $e');
  }

  try {
    await NotificationService().initialize();
    print('✓ Notification service initialized');
  } catch (e) {
    print('✗ Notification service initialization failed: $e');
  }

  try {
    final authService = AuthService();
    await authService.initialize();
    print('✓ Auth service initialized');
  } catch (e) {
    print('✗ Auth service initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jawara Pintar',
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        // Auth
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/reset-password': (context) => const ResetPasswordPage(),

        // Dashboards
        '/admin-dashboard': (context) => const AdminDashboardPage(),
        '/ketua-rt-dashboard': (context) => const KetuaRTDashboardPage(),
        '/bendahara-dashboard': (context) => const BendaharaDashboardPage(),
        '/sekretaris-dashboard': (context) => const SekretarisDashboardPage(),
        '/warga-dashboard': (context) => const WargaDashboardPage(),

        // Data Warga & Rumah
        '/residents': (context) => const ResidentsListPage(),
        '/residents/list': (context) => const ResidentsListPage(),
        '/residents/add': (context) => const ResidentsAddPage(),
        '/residents/grid': (context) => const ResidentsListPage(),
        '/families': (context) => const FamiliesPage(),
        '/houses': (context) => const HousesListPage(),
        '/houses/list': (context) => const HousesListPage(),
        '/houses/add': (context) => const HousesAddPage(),

        // Keuangan
        '/income': (context) => const IncomePage(),
        '/income/bills': (context) => const IncomeBillsPage(),
        '/income/bill': (context) => const IncomeBillPage(),
        '/income/categories': (context) => const IncomeCategoriesPage(),
        '/income/other/add': (context) => const IncomeOtherAddPage(),
        '/income/other/list': (context) => const IncomeOtherListPage(),
        '/spending': (context) => const SpendingPage(),
        '/spending/add': (context) => const SpendingAddPage(),
        '/spending/list': (context) => const SpendingListPage(),
        '/reports': (context) => const ReportsIncomePage(),
        '/reports/income': (context) => const ReportsIncomePage(),
        '/reports/spending': (context) => const ReportsSpendingPage(),
        '/reports/print': (context) => const ReportsPrintPage(),

        // Kegiatan & Komunikasi
        '/activities': (context) => const ActivitiesListPage(),
        '/activities/list': (context) => const ActivitiesDataListPage(),
        '/activities/add': (context) => const ActivitiesAddPage(),
        '/broadcast': (context) => const BroadcastListPage(),
        '/broadcast/list': (context) => const BroadcastListPage(),
        '/broadcast/add': (context) => const BroadcastAddPage(),
        '/activity-logs': (context) => const ActivityLogsPage(),
        '/messages': (context) => const CitizenMessagesPage(),
        '/resident-approvals': (context) => const ResidentApprovalsPage(),
        '/approvals': (context) => const ResidentApprovalsPage(),
        '/notifications': (context) => const NotificationsPage(),

        // Mutasi & Perubahan Data
        '/mutations': (context) => const MutationsMainPage(),
        '/mutations/family': (context) => const FamilyMutationsListPage(),
        '/mutations/add': (context) => const FamilyMutationsAddPage(),
        '/mutations/list': (context) => const FamilyMutationsListPage(),
        '/family-mutations/list': (context) => const FamilyMutationsListPage(),
        '/family-mutations/add': (context) => const FamilyMutationsAddPage(),

        // Marketplace
        '/marketplace': (context) => const MarketplacePage(),
        '/marketplace/cart': (context) => const MarketplaceCartPage(),
        '/marketplace/catalog': (context) => const MarketplaceCatalogPage(),
        '/marketplace/upload': (context) => const MarketplaceUploadPage(),
        '/marketplace/checkout': (context) =>
            const MarketplaceCartCheckoutPage(),
        '/marketplace/transactions': (context) =>
            const MarketplaceTransactionsPage(),
        '/marketplace/orders': (context) => const MarketplaceTransactionsPage(),

        // Manajemen Pengguna
        '/users': (context) => const UserManagementPage(),
        '/users/add': (context) => const ResidentsAddPage(),
        '/users/management': (context) => const UserManagementPage(),

        // Profil & Pengaturan
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/help': (context) => const HelpPage(),
        '/about': (context) => const AboutPage(),

        // Dashboard Menu Routes
        '/dashboard/finance': (context) => const FinancePage(),
        '/dashboard/activities': (context) => const ActivitiesListPage(),
        '/dashboard/population': (context) => const PopulationPage(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with parameters
        if (settings.name == '/residents/edit') {
          final resident = settings.arguments as Resident?;
          if (resident != null) {
            return MaterialPageRoute(
              builder: (context) => ResidentsEditPage(resident: resident),
            );
          }
        }

        if (settings.name == '/marketplace/checkout') {
          final product = settings.arguments as MarketplaceProduct?;
          if (product != null) {
            return MaterialPageRoute(
              builder: (context) => MarketplaceCheckoutPage(product: product),
            );
          }
        }

        // Handle unknown routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Halaman Tidak Ditemukan'),
              backgroundColor: const Color(0xFF0891B2),
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Halaman Tidak Ditemukan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Route: ${settings.name}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0891B2),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
