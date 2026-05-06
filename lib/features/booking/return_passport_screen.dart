import 'package:flutter/material.dart';

class ReturnPassportScreen extends StatefulWidget {
  const ReturnPassportScreen({super.key});

  @override
  State<ReturnPassportScreen> createState() => _ReturnPassportScreenState();
}

class _ReturnPassportScreenState extends State<ReturnPassportScreen> {
  bool _isCardView = false;

  final List<ReturnPassportItem> _items = const [
    ReturnPassportItem(postId: 'WP-5001', bookingId: 5601, serviceType: 'Work Permit', date: '2026-04-10', customerName: 'Shafiq Islam', passportNo: 'B99887766', packagePrice: 90000, paidAmount: 50000, statusLabel: 'Return Requested'),
    ReturnPassportItem(postId: 'WP-5002', bookingId: 5602, serviceType: 'Student Visa', date: '2026-04-16', customerName: 'Jannat Akter', passportNo: 'A44556677', packagePrice: 140000, paidAmount: 140000, statusLabel: 'Return Accepted'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Scaffold.maybeOf(context)?.openEndDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    tooltip: 'Sidebar',
                  ),
                  const Text('Return Passport', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: 'List view',
                          icon: Icon(Icons.view_list, color: !_isCardView ? const Color(0xFF2563EB) : Colors.grey),
                          onPressed: () => setState(() => _isCardView = false),
                        ),
                        Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
                        IconButton(
                          tooltip: 'Card view',
                          icon: Icon(Icons.grid_view_rounded, color: _isCardView ? const Color(0xFF2563EB) : Colors.grey),
                          onPressed: () => setState(() => _isCardView = true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: _isCardView ? _buildCardView() : _buildListView()),
            ],
          ),
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
            DataColumn(label: Text('Service Type')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Customer Name')),
            DataColumn(label: Text('Passport No')),
            DataColumn(label: Text('Package Price')),
            DataColumn(label: Text('Paid Amount')),
            DataColumn(label: Text('Status')),
          ],
          rows: _items
              .map((item) => DataRow(cells: [
                    DataCell(Text(item.postId)),
                    DataCell(Text(item.bookingId.toString())),
                    DataCell(Text(item.serviceType)),
                    DataCell(Text(item.date)),
                    DataCell(Text(item.customerName)),
                    DataCell(Text(item.passportNo)),
                    DataCell(Text('৳ ${item.packagePrice}')),
                    DataCell(Text('৳ ${item.paidAmount}')),
                    DataCell(Text(item.statusLabel)),
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
              _row('Service Type', item.serviceType),
              _row('Date', item.date),
              _row('Customer Name', item.customerName),
              _row('Passport No', item.passportNo),
              _row('Package Price', '৳ ${item.packagePrice}'),
              _row('Paid Amount', '৳ ${item.paidAmount}'),
              _row('Status', item.statusLabel),
            ]),
          );
        },
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569)))),
            Expanded(child: Text(value)),
          ],
        ),
      );
}

class ReturnPassportItem {
  final String postId;
  final int bookingId;
  final String serviceType;
  final String date;
  final String customerName;
  final String passportNo;
  final int packagePrice;
  final int paidAmount;
  final String statusLabel;

  const ReturnPassportItem({required this.postId, required this.bookingId, required this.serviceType, required this.date, required this.customerName, required this.passportNo, required this.packagePrice, required this.paidAmount, required this.statusLabel});
}
