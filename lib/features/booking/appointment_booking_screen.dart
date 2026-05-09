import 'package:flutter/material.dart';

import '../home/dashboard_screen.dart';
import 'appointment_ticket_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  bool _isCardView = true;

  final List<AppointmentBookingItem> _items = const [
    AppointmentBookingItem(
      postId: 'WP-7011',
      bookingId: 6701,
      fullName: 'Sabbir Hossain',
      country: 'Malaysia',
      visaCategory: 'Work Permit',
      meeting: 'Physical',
      date: 'May 01, 2026',
      time: '10:30 AM',
      passportNo: 'B12345678',
      avatarText: 'SH',
      avatarColor: Color(0xFF2563EB),
      actionLabel: 'Download Ticket',
    ),
    AppointmentBookingItem(
      postId: 'EP-8200',
      bookingId: 6702,
      fullName: 'Amara Ling',
      country: 'Singapore',
      visaCategory: 'Employment',
      meeting: 'Virtual',
      date: 'May 03, 2026',
      time: '02:15 PM',
      passportNo: 'A87654321',
      avatarText: 'AL',
      avatarColor: Color(0xFFC7D2FE),
      avatarTextColor: Color(0xFF475569),
      actionLabel: 'Join Meeting',
    ),
    AppointmentBookingItem(
      postId: 'SK-4412',
      bookingId: 6703,
      fullName: 'David Kim',
      country: 'South Korea',
      visaCategory: 'D-10 Visa',
      meeting: 'Physical',
      date: 'May 05, 2026',
      time: '09:00 AM',
      passportNo: 'C12673458',
      avatarText: 'DK',
      avatarColor: Color(0xFF6B7280),
      actionLabel: 'Download Ticket',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/appointment',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Appointment Booking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    tooltip: 'Sidebar',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Review and manage your upcoming recruitment interviews and visa processing appointments.',
                style: TextStyle(color: Color(0xFF475569), fontSize: 14),
              ),
              const SizedBox(height: 14),
              _viewSwitcher(),
              const SizedBox(height: 14),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name, ID or country...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
                label: const Text('Filters'),
              ),
              const SizedBox(height: 10),
              Expanded(child: _isCardView ? _buildCardView() : _buildListView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewSwitcher() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _switchButton(
            label: 'Cards',
            icon: Icons.grid_view,
            isActive: _isCardView,
            onTap: () => setState(() => _isCardView = true),
          ),
          _switchButton(
            label: 'List',
            icon: Icons.view_list,
            isActive: !_isCardView,
            onTap: () => setState(() => _isCardView = false),
          ),
        ],
      ),
    );
  }

  Widget _switchButton({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? const Color(0xFF2563EB) : const Color(0xFF334155),
        backgroundColor: isActive ? Colors.white : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Widget _buildListView() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF6FF)),
          columns: const [
            DataColumn(label: Text('Post ID')),
            DataColumn(label: Text('Booking ID')),
            DataColumn(label: Text('Full Name')),
            DataColumn(label: Text('Country')),
            DataColumn(label: Text('Visa Category')),
            DataColumn(label: Text('Meeting')),
            DataColumn(label: Text('Date & Time')),
            DataColumn(label: Text('Overview')),
          ],
          rows: _items
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item.postId)),
                    DataCell(Text(item.bookingId.toString())),
                    DataCell(Text(item.fullName)),
                    DataCell(Text(item.country)),
                    DataCell(Text(item.visaCategory)),
                    DataCell(Text(item.meeting)),
                    DataCell(Text('${item.date} ${item.time}')),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF2563EB)),
                        onPressed: () => _openTicket(item),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      );

  Widget _buildCardView() => ListView.separated(
        itemCount: _items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == _items.length) return _buildPremiumBanner();
          final item = _items[index];
          final meetingIcon = item.meeting == 'Virtual' ? Icons.videocam : Icons.groups;
          final actionIcon = item.meeting == 'Virtual' ? Icons.videocam_outlined : Icons.confirmation_number_outlined;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: item.avatarColor,
                      child: Text(item.avatarText, style: TextStyle(color: item.avatarTextColor, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              const Icon(Icons.public, size: 14, color: Color(0xFF475569)),
                              const SizedBox(width: 4),
                              Text(item.country, style: const TextStyle(color: Color(0xFF475569))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)),
                      child: Text(item.postId, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _metaCard('VISA CATEGORY', item.visaCategory)),
                    const SizedBox(width: 8),
                    Expanded(child: _metaCard('MEETING TYPE', item.meeting, icon: meetingIcon)),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _dateTimeBlock(Icons.calendar_today_outlined, 'Date', item.date)),
                    Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
                    Expanded(child: _dateTimeBlock(Icons.access_time, 'Time', item.time)),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _openTicket(item),
                        icon: Icon(actionIcon, size: 18),
                        label: Text(item.actionLabel),
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

  Widget _metaCard(String label, String value, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Row(
          children: [if (icon != null) ...[Icon(icon, size: 16, color: const Color(0xFF2563EB)), const SizedBox(width: 4)], Flexible(child: Text(value, style: const TextStyle(fontSize: 22 / 1.375, fontWeight: FontWeight.w600)))],
        ),
      ]),
    );
  }

  Widget _dateTimeBlock(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E293B)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20 / 1.25)),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: AssetImage('assets/img/customer/appointment/Malaysia.webp'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xB3000000), BlendMode.darken),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('PREMIUM ASSISTANCE', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 11)),
        const SizedBox(height: 8),
        const Text('Need help with your interview?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28 / 1.4)),
        const SizedBox(height: 8),
        const Text(
          'Our executive consultants are available for mock interviews and documentation reviews to increase your success rate.',
          style: TextStyle(color: Color(0xFFE2E8F0), height: 1.4),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB), minimumSize: const Size.fromHeight(44)),
          child: const Text('Connect with Consultant'),
        ),
      ]),
    );
  }

  void _openTicket(AppointmentBookingItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppointmentTicketScreen(
          id: item.bookingId,
          name: item.fullName,
          passportNo: item.passportNo,
          appointmentDate: '${item.date} ${item.time}',
          toCountry: item.country,
        ),
      ),
    );
  }
}

class AppointmentBookingItem {
  final String postId;
  final int bookingId;
  final String fullName;
  final String country;
  final String visaCategory;
  final String meeting;
  final String date;
  final String time;
  final String passportNo;
  final String avatarText;
  final Color avatarColor;
  final Color avatarTextColor;
  final String actionLabel;

  const AppointmentBookingItem({
    required this.postId,
    required this.bookingId,
    required this.fullName,
    required this.country,
    required this.visaCategory,
    required this.meeting,
    required this.date,
    required this.time,
    required this.passportNo,
    required this.avatarText,
    required this.avatarColor,
    this.avatarTextColor = Colors.white,
    required this.actionLabel,
  });
}
