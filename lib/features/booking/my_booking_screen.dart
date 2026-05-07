import 'package:flutter/material.dart';

import '../home/dashboard_screen.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  bool _isCardView = false;

  final List<BookingItem> _bookings = const [
    BookingItem(
      postId: 'WP-1201',
      bookingId: 4571,
      serviceType: 'Work Permit',
      date: '2026-04-12',
      customerName: 'Rakib Hasan',
      passportNo: 'B12345678',
      packagePrice: 85000,
      paidAmount: 40000,
      statusLabel: 'Applied File',
    ),
    BookingItem(
      postId: 'ST-2003',
      bookingId: 4572,
      serviceType: 'Student Visa',
      date: '2026-04-18',
      customerName: 'Nusrat Jahan',
      passportNo: 'A98765432',
      packagePrice: 120000,
      paidAmount: 120000,
      statusLabel: 'Success Flight',
    ),
    BookingItem(
      postId: 'HJ-3098',
      bookingId: 4573,
      serviceType: 'Hajj Package',
      date: '2026-04-22',
      customerName: 'Abdul Karim',
      passportNo: 'E44112233',
      packagePrice: 230000,
      paidAmount: 80000,
      statusLabel: 'Under Processing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/my',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Booking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    tooltip: 'Sidebar',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Booking File',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: 'List view',
                          icon: Icon(
                            Icons.view_list,
                            color: !_isCardView
                                ? const Color(0xFF2563EB)
                                : Colors.grey,
                          ),
                          onPressed: () => setState(() => _isCardView = false),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: const Color(0xFFE2E8F0),
                        ),
                        IconButton(
                          tooltip: 'Card view',
                          icon: Icon(
                            Icons.grid_view_rounded,
                            color: _isCardView
                                ? const Color(0xFF2563EB)
                                : Colors.grey,
                          ),
                          onPressed: () => setState(() => _isCardView = true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: _isCardView ? _buildCardList() : _buildTableList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableList() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF6FF)),
          columns: const [
            DataColumn(label: Text('Post ID')),
            DataColumn(label: Text('Booking ID')),
            DataColumn(label: Text('Service Type')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Customer Info')),
            DataColumn(label: Text('Package Price')),
            DataColumn(label: Text('Paid Amount')),
            DataColumn(label: Text('Status')),
          ],
          rows: _bookings
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item.postId)),
                    DataCell(Text(item.bookingId.toString())),
                    DataCell(Text(item.serviceType)),
                    DataCell(Text(item.date)),
                    DataCell(Text('${item.customerName}\n${item.passportNo}')),
                    DataCell(Text('৳ ${item.packagePrice}')),
                    DataCell(Text('৳ ${item.paidAmount}')),
                    DataCell(Text(item.statusLabel)),
                  ],
                ),
              )
              .toList(),
        ),
      );

  Widget _buildCardList() => ListView.separated(
        itemCount: _bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _bookings[index];
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Post ID', item.postId),
                _row('Booking ID', item.bookingId.toString()),
                _row('Service Type', item.serviceType),
                _row('Date', item.date),
                _row('Customer', '${item.customerName} (${item.passportNo})'),
                _row('Package Price', '৳ ${item.packagePrice}'),
                _row('Paid Amount', '৳ ${item.paidAmount}'),
                _row('Status', item.statusLabel),
              ],
            ),
          );
        },
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
}

class BookingItem {
  final String postId;
  final int bookingId;
  final String serviceType;
  final String date;
  final String customerName;
  final String passportNo;
  final int packagePrice;
  final int paidAmount;
  final String statusLabel;

  const BookingItem({
    required this.postId,
    required this.bookingId,
    required this.serviceType,
    required this.date,
    required this.customerName,
    required this.passportNo,
    required this.packagePrice,
    required this.paidAmount,
    required this.statusLabel,
  });
}
