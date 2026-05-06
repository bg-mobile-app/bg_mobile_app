import 'package:flutter/material.dart';

import 'customer_profile_edit_screen.dart';
import 'dashboard_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});


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
              _ProfileHeader(),
              SizedBox(height: 16),
              _SectionTitle(
                title: 'Personal Details',
                subtitle: 'As mentioned on your passport or government approved IDs',
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Basic Info',
                items: [
                  _InfoItem(label: 'Name', value: 'Demo User'),
                  _InfoItem(label: 'Date of Birth', value: '1990-01-01'),
                  _InfoItem(label: 'Gender', value: 'Male'),
                ],
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Contact Info',
                items: [
                  _InfoItem(label: 'Email Address', value: 'demo.user@example.com'),
                  _InfoItem(label: 'Phone Number', value: '+1 555 0102'),
                  _InfoItem(label: 'Address', value: 'Dhaka, Bangladesh'),
                  _InfoItem(label: 'Police Station', value: 'Dhanmondi'),
                  _InfoItem(label: 'District', value: 'Dhaka'),
                ],
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Passport Info',
                items: [
                  _InfoItem(label: 'Passport Number', value: 'A12345678'),
                  _InfoItem(label: 'Passport Expire Date', value: '2030-02-28'),
                  _InfoItem(label: 'Passport Issue Date', value: '2020-03-01'),
                ],
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Personalized Info',
                items: [
                  _InfoItem(label: 'Liked Services', value: 'Work permit, Student visa'),
                  _InfoItem(label: 'Liked Countries', value: 'Japan, Malaysia'),
                  _InfoItem(label: 'Liked Job Type', value: 'Factory, Hospitality'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/img/logo/logo_black.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Demo User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('demo.user@example.com', style: TextStyle(color: Color(0xFF475569))),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CustomerProfileEditScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
      ],
    );
  }
}

class _InfoGroup extends StatelessWidget {
  const _InfoGroup({required this.title, required this.items});

  final String title;
  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
