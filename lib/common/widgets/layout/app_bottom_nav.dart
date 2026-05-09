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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE5EAF3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 12 : 0,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0x1A2563EB)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            size: 33,
                            color: isSelected
                                ? primaryColor
                                : const Color(0xFF98A1AF),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const List<_BottomNavItem> _items = [
  _BottomNavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_outlined,
  ),
  _BottomNavItem(
    label: 'Search',
    icon: Icons.search_rounded,
    selectedIcon: Icons.search_rounded,
  ),
  _BottomNavItem(
    label: 'Booking',
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month_outlined,
  ),
  _BottomNavItem(
    label: 'Chat',
    icon: Icons.chat_bubble_outline_rounded,
    selectedIcon: Icons.chat_bubble_outline_rounded,
  ),
  _BottomNavItem(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_outline_rounded,
  ),
];
