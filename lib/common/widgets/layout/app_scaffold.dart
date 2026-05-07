import 'package:flutter/material.dart';

import '../../../features/booking/appointment_booking_screen.dart';
import '../../../features/home/dashboard_screen.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/booking/my_booking_screen.dart';
import '../../../features/search/work_permit_list_screen.dart';
import '../../../features/booking/return_passport_screen.dart';
import '../../../features/booking/success_flight_screen.dart';
import '../../../features/home/customer_profile_screen.dart';
import '../../../features/home/change_password_screen.dart';
import '../../../features/home/check_status_screen.dart';
import '../../../features/home/payments_screen.dart';
import '../../../features/home/notifications_screen.dart';
import 'app_bottom_nav.dart';
import 'navigation_state.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  List<Widget> get _screens => const [
        HomeScreen(),
        WorkPermitListScreen(),
        MyBookingScreen(),
        _DummyScreen(title: 'Chat'),
        _DashboardHostScreen(),
      ];

  @override
  void initState() {
    super.initState();
    bottomNavIndexNotifier.value = _currentIndex;
    bottomNavIndexNotifier.addListener(_syncBottomNav);
  }

  void _syncBottomNav() {
    if (!mounted) return;
    setState(() => _currentIndex = bottomNavIndexNotifier.value);
  }

  @override
  void dispose() {
    bottomNavIndexNotifier.removeListener(_syncBottomNav);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          bottomNavIndexNotifier.value = index;
        },
      ),
    );
  }
}

class _DashboardHostScreen extends StatelessWidget {
  const _DashboardHostScreen();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: dashboardRouteNotifier,
      builder: (_, route, __) {
        switch (route) {
          case '/dashboard/customer':
            return const DashboardScreen();
          case '/dashboard/customer/profile':
            return const CustomerProfileScreen();
          case '/dashboard/booking/my/success-file':
            return const SuccessFlightScreen();
          case '/dashboard/booking/my/return-passport':
            return const ReturnPassportScreen();
          case '/dashboard/booking/appointment':
            return const AppointmentBookingScreen();
          case '/dashboard/customer/change-password':
            return const ChangePasswordScreen();
          case '/dashboard/customer/check-status':
            return const CheckStatusScreen();
          case '/dashboard/my-payments':
            return const PaymentsScreen();
          case '/dashboard/notifications':
            return const NotificationsScreen();
          default:
            return DashboardDummyScreen(
              title: route.split('/').last.replaceAll('-', ' '),
            );
        }
      },
    );
  }
}

class _DummyScreen extends StatelessWidget {
  const _DummyScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Screen (Coming Soon)'),
      ),
    );
  }
}
