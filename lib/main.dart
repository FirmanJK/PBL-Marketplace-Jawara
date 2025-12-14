import 'package:flutter/material.dart';
import 'package:jawara/pages/auth/login_page.dart';
import 'package:jawara/pages/auth/register_page.dart';
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
import 'package:jawara/pages/activities/activities_list.dart';
import 'package:jawara/pages/messages/resident_messages.dart';
import 'package:jawara/pages/approvals/resident_approvals.dart';
import 'package:jawara/pages/notifications/notifications_page.dart';
import 'package:jawara/pages/marketplace/marketplace_cart_page.dart';
import 'package:jawara/pages/profile/profile_page.dart';
import 'package:jawara/pages/settings/settings_page.dart';
import 'package:jawara/pages/help_page.dart';
import 'package:jawara/pages/about_page.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/services/database_service.dart';
import 'package:jawara/services/notification_service.dart';
import 'package:jawara/models/resident.dart';

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

        // Dashboards
        '/admin-dashboard': (context) => const AdminDashboardPage(),
        '/ketua-rt-dashboard': (context) => const KetuaRTDashboardPage(),
        '/bendahara-dashboard': (context) => const BendaharaDashboardPage(),
        '/sekretaris-dashboard': (context) => const SekretarisDashboardPage(),
        '/warga-dashboard': (context) => const WargaDashboardPage(),

        // Data Warga & Rumah
        '/residents/list': (context) => const ResidentsListPage(),
        '/residents/add': (context) => const ResidentsAddPage(),
        '/families': (context) => const FamiliesPage(),
        '/houses/list': (context) => const HousesListPage(),
        '/houses/add': (context) => const HousesAddPage(),

        // Keuangan
        '/income': (context) => const IncomePage(),
        '/spending': (context) => const SpendingPage(),
        '/reports/income': (context) => const ReportsIncomePage(),

        // Kegiatan & Komunikasi
        '/activities/list': (context) => const ActivitiesListPage(),
        '/messages': (context) => const CitizenMessagesPage(),
        '/resident-approvals': (context) => const ResidentApprovalsPage(),
        '/notifications': (context) => const NotificationsPage(),

        // Marketplace
        '/marketplace/cart': (context) => const MarketplaceCartPage(),

        // Profil & Pengaturan
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/help': (context) => const HelpPage(),
        '/about': (context) => const AboutPage(),
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
        
        // Handle unknown routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Fitur Dalam Pengembangan'),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.construction,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Fitur Sedang Dalam Pengembangan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Route: ${settings.name}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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