import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/theme/app_colors.dart';
import '../../common/theme/app_palette.dart';
import '../../common/theme/app_text_styles.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 960 ? 3 : (width >= 640 ? 2 : 1);

    return DashboardPageScaffold(
      currentHref: '/dashboard/customer',
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _DashboardBreadcrumbs(),
                    const SizedBox(height: 14),
                    Text(
                      'Dashboard Overview',
                      style: AppTextStyles.headline1.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppPalette.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppPalette.borderSoftBlue),
                        boxShadow: AppPalette.softShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'This Month',
                              style: AppTextStyles.subtitle1.copyWith(fontSize: 17),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: AppPalette.textPrimary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: width < 640 ? 2.45 : 2.0,
                      children: const [
                        DashboardSmallCard(label: 'Total Applied Job', icon: Icons.menu_book_outlined, value: '0'),
                        DashboardSmallCard(label: 'Under Processing', icon: Icons.hourglass_top_rounded, value: '0'),
                        DashboardSmallCard(label: 'Success Flight', icon: Icons.flight_takeoff_rounded, value: '0'),
                        DashboardSmallCard(label: 'Reject Flight', icon: Icons.flight_land_rounded, value: '0', red: true),
                        DashboardSmallCard(label: 'Return Passport', icon: Icons.badge_outlined, value: '0'),
                        DashboardSmallCard(label: 'Total Appointment', icon: Icons.event_note_rounded, value: '0'),
                        DashboardSmallCard(label: 'Total Amount', icon: Icons.payments_outlined, value: '৳0'),
                        DashboardSmallCard(label: 'Paid Amount', icon: Icons.account_balance_wallet_outlined, value: '৳0'),
                        DashboardSmallCard(label: 'Due Amount', icon: Icons.money_off_csred_outlined, value: '৳0', red: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardBreadcrumbs extends StatelessWidget {
  const _DashboardBreadcrumbs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.home_outlined, size: 14, color: AppPalette.textMuted),
        SizedBox(width: 6),
        Text('Home', style: TextStyle(fontSize: 12, color: AppPalette.textMuted, fontWeight: FontWeight.w500)),
        SizedBox(width: 6),
        Icon(Icons.chevron_right_rounded, size: 16, color: AppPalette.textMuted),
        SizedBox(width: 6),
        Text('Dashboard', style: TextStyle(fontSize: 12, color: AppPalette.brandBlue, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

const List<SidebarLink> kDashboardSidebarLinks = [
  SidebarLink(name: 'Dashboard', icon: Icons.dashboard, href: '/dashboard/customer'),
  SidebarLink(name: 'My Profile', icon: Icons.person, href: '/dashboard/customer/profile'),
  SidebarLink(name: 'My Favourite', icon: Icons.favorite_border, href: '/dashboard/customer/favourite'),
    SidebarLink(
      name: 'My Booking',
      icon: Icons.grid_view,
      children: [
        SidebarLink(name: 'My Booking', href: '/dashboard/booking/my'),
        SidebarLink(name: 'Success File', href: '/dashboard/booking/my/success-file'),
        SidebarLink(name: 'Return Passport', href: '/dashboard/booking/my/return-passport'),
      ],
    ),
    SidebarLink(
      name: 'Appointment Booking',
      icon: Icons.calendar_month,
      href: '/dashboard/booking/appointment',
    ),
    SidebarLink(name: 'Check Status', icon: Icons.radio_button_checked, href: '/dashboard/customer/check-status'),
    SidebarLink(name: 'Payment', icon: Icons.payment, href: '/dashboard/my-payments'),
    SidebarLink(name: 'Notifications', icon: Icons.notifications_none, href: '/dashboard/notifications'),
    SidebarLink(name: 'Change Password', icon: Icons.swap_horiz, href: '/dashboard/customer/change-password'),
];

class DashboardPageScaffold extends StatelessWidget {
  const DashboardPageScaffold({super.key, required this.child, required this.currentHref});

  final Widget child;
  final String currentHref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: CustomerSidebarDrawer(
        currentHref: currentHref,
        fullName: 'Demo User',
        userId: 'BG-1024',
        email: 'demo.user@example.com',
        phone: '+1 555 0102',
        profileImage: 'assets/img/logo/logo_black.png',
        links: kDashboardSidebarLinks,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Image.asset(
          'assets/img/logo/logo_black.png',
          height: 34,
          fit: BoxFit.contain,
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu, color: Colors.black87),
              tooltip: 'Sidebar',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
    );
  }
}

class CustomerSidebarDrawer extends StatefulWidget {
  const CustomerSidebarDrawer({
    super.key,
    required this.currentHref,
    required this.fullName,
    required this.userId,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.links,
  });

  final String fullName;
  final String currentHref;
  final String userId;
  final String email;
  final String phone;
  final String profileImage;
  final List<SidebarLink> links;

  @override
  State<CustomerSidebarDrawer> createState() => _CustomerSidebarDrawerState();
}

class _CustomerSidebarDrawerState extends State<CustomerSidebarDrawer> {
  String? _openKey;

  void _handleNavigation(SidebarLink link) {
    Navigator.pop(context);
    final href = link.href;
    if (href == null || href == widget.currentHref) return;
    if (href == '/dashboard/booking/my') {
      context.go('/booking');
      return;
    }
    context.go(href);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SidebarUserInfo(
                fullName: widget.fullName,
                userId: widget.userId,
                email: widget.email,
                phone: widget.phone,
                profileImage: widget.profileImage,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.links.length,
                  itemBuilder: (context, index) {
                    final link = widget.links[index];
                    return _SidebarNavTile(
                      link: link,
                      isOpen: _openKey == link.name,
                      onExpandToggle: () {
                        setState(() {
                          _openKey = _openKey == link.name ? null : link.name;
                        });
                      },
                      onTap: _handleNavigation,
                    );
                  },
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: Color(0xFF475569),),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout clicked')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarUserInfo extends StatelessWidget {
  const _SidebarUserInfo({
    required this.fullName,
    required this.userId,
    required this.email,
    required this.phone,
    required this.profileImage,
  });

  final String fullName;
  final String userId;
  final String email;
  final String phone;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 40, backgroundImage: AssetImage(profileImage)),
        const SizedBox(height: 8),
        Text(
          fullName.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text('User ID: $userId', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
        Text('User Email: $email', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
        Text('User Phone: $phone', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
      ],
    );
  }
}

class _SidebarNavTile extends StatelessWidget {
  const _SidebarNavTile({required this.link, required this.isOpen, required this.onExpandToggle, required this.onTap});

  final SidebarLink link;
  final bool isOpen;
  final VoidCallback onExpandToggle;
  final ValueChanged<SidebarLink> onTap;

  @override
  Widget build(BuildContext context) {
    if (link.children.isNotEmpty) {
      return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: isOpen,
        onExpansionChanged: (_) => onExpandToggle(),
        leading: Icon(link.icon ?? Icons.circle, size: 20),
        title: Text(link.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: link.children
            .map(
              (child) => ListTile(
                contentPadding: const EdgeInsets.only(left: 40, right: 0),
                title: Text(child.name),
                onTap: () => onTap(child),
              ),
            )
            .toList(),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(link.icon ?? Icons.circle, size: 20),
      title: Text(link.name, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () => onTap(link),
    );
  }
}

class SidebarLink {
  const SidebarLink({
    required this.name,
    this.href,
    this.icon,
    this.children = const [],
  });

  final String name;
  final String? href;
  final IconData? icon;
  final List<SidebarLink> children;
}

class DashboardDummyScreen extends StatelessWidget {
  const DashboardDummyScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/dummy/$title',
      child: Center(child: Text('$title screen (Coming Soon)')),
    );
  }
}

class DashboardSmallCard extends StatelessWidget {
  const DashboardSmallCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.red = false,
  });

  final String label;
  final IconData icon;
  final String value;
  final bool red;

  @override
  Widget build(BuildContext context) {
    final borderColor = red ? const Color(0xFFF6C6C6) : const Color(0xFFC9D1E8);
    final iconBg = red ? const Color(0xFFF8DDDD) : const Color(0xFFE7EEFF);
    final iconColor = red ? const Color(0xFFB01414) : AppColors.primary;
    final labelColor = red ? const Color(0xFFC11212) : const Color(0xFFB3BAD1);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 48,
                    height: 0.95,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
