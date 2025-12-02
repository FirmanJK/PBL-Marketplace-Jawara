import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:jawara/pages/activities/activities_add.dart';
import 'package:jawara/pages/activities/activities_list.dart';
import 'package:jawara/pages/activities/broadcast_add.dart';
import 'package:jawara/pages/activities/broadcast_list.dart';
import 'package:jawara/pages/activity_logs_page.dart';
// Import dari subfolder
import 'package:jawara/pages/auth/login_page.dart';
import 'package:jawara/pages/auth/register_page.dart';
import 'package:jawara/pages/channels/channels_add.dart';
import 'package:jawara/pages/channels/channels_list.dart';
import 'package:jawara/pages/dashboard/activities_page.dart';
import 'package:jawara/pages/dashboard/finance_page.dart';
import 'package:jawara/pages/dashboard/population_page.dart';
import 'package:jawara/pages/income.dart';
import 'package:jawara/pages/income/income_bill.dart';
import 'package:jawara/pages/income/income_bills.dart';
import 'package:jawara/pages/income/income_categories.dart';
import 'package:jawara/pages/income/income_other_add.dart';
import 'package:jawara/pages/income/income_other_list.dart';
import 'package:jawara/pages/mutations/family_mutations_add.dart';
import 'package:jawara/pages/mutations/family_mutations_list.dart';
import 'package:jawara/pages/notifications/notifications_page.dart';
import 'package:jawara/pages/profile/profile_page.dart';
import 'package:jawara/pages/reports/reports_income.dart';
import 'package:jawara/pages/reports/reports_print.dart';
import 'package:jawara/pages/reports/reports_spending.dart';
import 'package:jawara/pages/resident_approvals.dart';
import 'package:jawara/pages/resident_messages.dart';
import 'package:jawara/pages/residents/families_page.dart';
import 'package:jawara/pages/residents/houses_add.dart';
import 'package:jawara/pages/residents/houses_list.dart';
import 'package:jawara/pages/residents/residents_add.dart';
import 'package:jawara/pages/residents/residents_detail.dart';
import 'package:jawara/pages/residents/residents_edit.dart';
import 'package:jawara/pages/residents/residents_list.dart';
import 'package:jawara/pages/settings/settings_page.dart';
import 'package:jawara/pages/spending.dart';
import 'package:jawara/pages/spending/spending_add.dart';
import 'package:jawara/pages/spending/spending_list.dart';
import 'package:jawara/pages/users/user_management.dart';
import 'package:jawara/pages/users/users_add.dart';
import 'package:jawara/pages/marketplace_page.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/notification_service.dart';
import 'package:jawara/services/database_service.dart';
import 'package:jawara/models/resident.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database service with error handling
  try {
    await DatabaseService().database;
    print(' Database initialized');
  } catch (e) {
    print(' Database initialization failed: $e');
  }
  
  // Initialize notification service (database-only version)
  try {
    await NotificationService().initialize();
    print(' Notification service initialized');
  } catch (e) {
    print(' Notification service initialization failed: $e');
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
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      routes: {
        // Auth
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),

        // Dashboard
        '/dashboard/finance': (context) => const DashboardFinancePage(),
        '/dashboard/activities': (context) => const DashboardActivitiesPage(),
        '/dashboard/population': (context) => const DashboardPopulationPage(),

        // Data Warga & Rumah
        '/residents/list': (context) => const ResidentsListPage(),
        '/residents/add': (context) => const ResidentsAddPage(),
        '/residents/edit': (context) {
          final resident = ModalRoute.of(context)!.settings.arguments as Resident;
          return ResidentsEditPage(resident: resident);
        },
        '/families': (context) => const FamiliesPage(),
        '/houses/list': (context) => const HousesListPage(),
        '/houses/add': (context) => const HousesAddPage(),

        // Pemasukan (Income)
        '/income': (context) => const IncomePage(),
        '/income/categories': (context) => const IncomeCategoriesPage(),
        '/income/bill': (context) => const IncomeBillPage(),
        '/income/bills': (context) => const IncomeBillsPage(),
        '/income/other/list': (context) => const IncomeOtherListPage(),
        '/income/other/add': (context) => const IncomeOtherAddPage(),

        // Pengeluaran (Spending)
        '/spending': (context) => const SpendingPage(),
        '/spending/list': (context) => const SpendingListPage(),
        '/spending/add': (context) => const SpendingAddPage(),

        // Laporan Keuangan (Reports)
        '/reports/income': (context) => const ReportsIncomePage(),
        '/reports/spending': (context) => const ReportsSpendingPage(),
        '/reports/print': (context) => const ReportsPrintPage(),

        // Kegiatan & Broadcast
        '/activities/list': (context) => const ActivitiesListPage(),
        '/activities/add': (context) => const ActivitiesAddPage(),
        '/broadcast/list': (context) => const BroadcastListPage(),
        '/broadcast/add': (context) => const BroadcastAddPage(),

        // Pesan Warga (Resident Messages)
        '/messages': (context) => const CitizenMessagesPage(),
        '/messages/aspirations': (context) => const CitizenMessagesPage(),

        // Penerimaan Warga (Resident Approvals)
        '/resident-approvals': (context) => const ResidentApprovalsPage(),

        // Mutasi Keluarga (Family Mutations)
        '/family-mutations/list': (context) => const FamilyMutationsListPage(),
        '/family-mutations/add': (context) => const FamilyMutationsAddPage(),

        // Log Aktifitas (Activity Logs)
        '/activity-logs': (context) => const ActivityLogsPage(),

        // Manajemen Pengguna (User Management)
        '/users': (context) => const UserManagementPage(),
        '/users/add': (context) => const UsersAddPage(),

        // Channel Transfer
        '/channels/list': (context) => const ChannelsListPage(),
        '/channels/add': (context) => const ChannelsAddPage(),

        // Marketplace
        '/marketplace': (context) => const MarketplacePage(),
        '/marketplace/upload': (context) => const MarketplacePage(),
        '/marketplace/catalog': (context) => const MarketplacePage(),

        // Notifikasi
        '/notifications': (context) => const NotificationsPage(),

        // Profil & Pengaturan
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
