import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.primaryColor = const Color(0xFF2563EB),
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFF)],
          ),
          border: Border.all(color: const Color(0xFFE3ECFF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(color: primaryColor);
                }
                return const IconThemeData(color: Color(0xFF7C8BA1));
              }),
            ),
            child: NavigationBar(
              height: 66,
              backgroundColor: Colors.transparent,
              indicatorColor: const Color(0x1F2563EB),
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_rounded),
                  selectedIcon: Icon(Icons.search_rounded),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: 'Booking',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  selectedIcon: Icon(Icons.chat_bubble_rounded),
                  label: 'Chat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
