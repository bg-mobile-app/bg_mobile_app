import 'package:flutter/material.dart';

import '../../../features/home/dashboard_screen.dart';
import '../../../features/home/home_screen.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    _DummyScreen(title: 'Search'),
    _DummyScreen(title: 'My Booking'),
    _DummyScreen(title: 'Chat'),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
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
