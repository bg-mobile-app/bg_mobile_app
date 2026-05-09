import 'package:flutter/material.dart';
import 'package:fui_kit/fui_kit.dart';

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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                scale: isSelected ? 0.88 : 1.0,
                                child: FUI(
                                  isSelected ? item.selectedIcon : item.icon,
                                  width: isSelected ? 21 : 25,
                                  height: isSelected ? 21 : 25,
                                  color: isSelected
                                      ? primaryColor
                                      : const Color(0xFF98A1AF),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SizeTransition(
                                      sizeFactor: animation,
                                      axis: Axis.vertical,
                                      child: child,
                                    ),
                                  );
                                },
                                child: isSelected
                                    ? Padding(
                                        key: ValueKey(item.label),
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          item.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(
                                        key: ValueKey('no-label'),
                                      ),
                              ),
                            ],
                          ),
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
  final String icon;
  final String selectedIcon;
}

const List<_BottomNavItem> _items = [
  _BottomNavItem(
    label: 'Home',
    icon: RegularStraight.HOME,
    selectedIcon: RegularStraight.HOME,
  ),
  _BottomNavItem(
    label: 'Search',
    icon: RegularStraight.SEARCH,
    selectedIcon: RegularStraight.SEARCH,
  ),
  _BottomNavItem(
    label: 'Booking',
    icon: RegularStraight.CALENDAR,
    selectedIcon: RegularStraight.CALENDAR,
  ),
  _BottomNavItem(
    label: 'Chat',
    icon: RegularStraight.COMMENT,
    selectedIcon: RegularStraight.COMMENT,
  ),
  _BottomNavItem(
    label: 'Profile',
    icon: RegularStraight.USER,
    selectedIcon: RegularStraight.USER,
  ),
];
