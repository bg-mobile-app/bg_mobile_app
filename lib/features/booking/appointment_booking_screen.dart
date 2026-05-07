import 'package:flutter/material.dart';

import '../home/dashboard_screen.dart';

import 'appointment_ticket_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  bool _isCardView = false;

  final List<AppointmentBookingItem> _items = const [
    AppointmentBookingItem(postId: 'WP-7011', bookingId: 6701, fullName: 'Sabbir Hossain', country: 'Malaysia', visaCategory: 'Work Permit', meeting: 'Physical', dateTime: '2026-05-01 10:30 AM', passportNo: 'B12345678'),
    AppointmentBookingItem(postId: 'WP-7012', bookingId: 6702, fullName: 'Farzana Islam', country: 'Canada', visaCategory: 'Student Visa', meeting: 'Physical', dateTime: '2026-05-03 03:00 PM', passportNo: 'A87654321'),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/appointment',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Appointment Booking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.menu, color: Colors.black87),
                tooltip: 'Sidebar',
              ),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  IconButton(tooltip: 'List view', icon: Icon(Icons.view_list, color: !_isCardView ? const Color(0xFF2563EB) : Colors.grey), onPressed: () => setState(() => _isCardView = false)),
                  Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
                  IconButton(tooltip: 'Card view', icon: Icon(Icons.grid_view_rounded, color: _isCardView ? const Color(0xFF2563EB) : Colors.grey), onPressed: () => setState(() => _isCardView = true)),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            Expanded(child: _isCardView ? _buildCardView() : _buildListView()),
          ]),
        ),
      ),
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
              .map((item) => DataRow(cells: [
                    DataCell(Text(item.postId)),
                    DataCell(Text(item.bookingId.toString())),
                    DataCell(Text(item.fullName)),
                    DataCell(Text(item.country)),
                    DataCell(Text(item.visaCategory)),
                    DataCell(Text(item.meeting)),
                    DataCell(Text(item.dateTime)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF2563EB)),
                        onPressed: () => _openTicket(item),
                      ),
                    ),
                  ]))
              .toList(),
        ),
      );

  Widget _buildCardView() => ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _row('Post ID', item.postId),
              _row('Booking ID', item.bookingId.toString()),
              _row('Full Name', item.fullName),
              _row('Country', item.country),
              _row('Visa Category', item.visaCategory),
              _row('Meeting', item.meeting),
              _row('Date & Time', item.dateTime),
              const SizedBox(height: 4),
              OutlinedButton.icon(onPressed: () => _openTicket(item), icon: const Icon(Icons.download), label: const Text('Download Ticket')),
            ]),
          );
        },
      );

  void _openTicket(AppointmentBookingItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppointmentTicketScreen(
          id: item.bookingId,
          name: item.fullName,
          passportNo: item.passportNo,
          appointmentDate: item.dateTime,
          toCountry: item.country,
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569)))),
          Expanded(child: Text(value)),
        ]),
      );
}

class AppointmentBookingItem {
  final String postId;
  final int bookingId;
  final String fullName;
  final String country;
  final String visaCategory;
  final String meeting;
  final String dateTime;
  final String passportNo;

  const AppointmentBookingItem({required this.postId, required this.bookingId, required this.fullName, required this.country, required this.visaCategory, required this.meeting, required this.dateTime, required this.passportNo});
}
