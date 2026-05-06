import 'package:flutter/material.dart';

import 'customer_profile_screen.dart';
import '../booking/success_flight_screen.dart';
import '../booking/return_passport_screen.dart';
import '../booking/appointment_booking_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color _brandBlue = Color(0xFF2563EB);

  static const List<SidebarLink> _sidebarLinks = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomerSidebarDrawer(
        fullName: 'Demo User',
        userId: 'BG-1024',
        email: 'demo.user@example.com',
        phone: '+1 555 0102',
        profileImage: 'assets/img/logo/logo_black.png',
        links: _sidebarLinks,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DASHBOARD OVERVIEW',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF94A3B8)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'This Month',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: const [
                  DashboardSmallCard(
                    label: 'Total Applied Job',
                    icon: Icons.menu_book,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Under Processing',
                    icon: Icons.hourglass_top,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Success Flight',
                    icon: Icons.flight_takeoff,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Reject Flight',
                    icon: Icons.flight_land,
                    value: '৳0',
                    red: true,
                  ),
                  DashboardSmallCard(
                    label: 'Return Passport',
                    icon: Icons.badge_outlined,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Total Appointment',
                    icon: Icons.event_note,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Total Amount',
                    icon: Icons.payments_outlined,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Paid Amount',
                    icon: Icons.account_balance_wallet_outlined,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Due Amount',
                    icon: Icons.money_off_csred_outlined,
                    value: '৳0',
                    red: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerSidebarDrawer extends StatefulWidget {
  const CustomerSidebarDrawer({
    super.key,
    required this.fullName,
    required this.userId,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.links,
  });

  final String fullName;
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

    final href = link.href ?? '';
    if (href == '/dashboard/customer') {
      return;
    }

    if (href == '/dashboard/customer/profile') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const CustomerProfileScreen(),
        ),
      );
      return;
    }

    if (href == '/dashboard/booking/my/success-file') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const SuccessFlightScreen(),
        ),
      );
      return;
    }

    if (href == '/dashboard/booking/my/return-passport') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ReturnPassportScreen(),
        ),
      );
      return;
    }

    if (href == '/dashboard/booking/appointment') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AppointmentBookingScreen(),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to ${link.name}')),
    );
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Icon(
                  icon,
                  color: red ? Colors.orange : Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
