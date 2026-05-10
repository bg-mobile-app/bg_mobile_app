import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_palette.dart';
import '../home/dashboard_screen.dart';

class ReturnPassportScreen extends StatefulWidget {
  const ReturnPassportScreen({super.key});

  @override
  State<ReturnPassportScreen> createState() => _ReturnPassportScreenState();
}

class _ReturnPassportScreenState extends State<ReturnPassportScreen> {
  bool _isCardView = false;

  final List<ReturnPassportItem> _items = const [
    ReturnPassportItem(
      postId: 'WP-5001',
      bookingId: 5601,
      serviceType: 'Work Permit',
      date: '2026-04-10',
      customerName: 'Shafiq Islam',
      passportNo: 'B99887766',
      packagePrice: 90000,
      paidAmount: 50000,
      statusLabel: 'Return Requested',
    ),
    ReturnPassportItem(
      postId: 'WP-5002',
      bookingId: 5602,
      serviceType: 'Student Visa',
      date: '2026-04-16',
      customerName: 'Jannat Akter',
      passportNo: 'A44556677',
      packagePrice: 140000,
      paidAmount: 140000,
      statusLabel: 'Return Accepted',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/my/return-passport',
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _breadcrumb(),
                const SizedBox(height: 8),
                const Text(
                  'Return Passport',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _viewToggle(),
                const SizedBox(height: 16),
                _statsGrid(),
                const SizedBox(height: 16),
                if (_isCardView) _buildCardView() else _buildListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumb() {
    return BreadCrumb(
      items: <BreadCrumbItem>[
        BreadCrumbItem(content: const Text('Recruitment Portal', style: TextStyle(color: AppPalette.textMuted, fontSize: 12))),
        BreadCrumbItem(content: const Text('Return Passport', style: TextStyle(color: AppPalette.textStrongBlue, fontSize: 12, fontWeight: FontWeight.w700))),
      ],
      divider: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
    );
  }

  Widget _viewToggle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleButton('List View', Icons.format_list_bulleted, !_isCardView, () => setState(() => _isCardView = false)),
          _toggleButton('Card View', Icons.grid_view_rounded, _isCardView, () => setState(() => _isCardView = true)),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, IconData icon, bool active, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: active ? AppPalette.brandBlue : Colors.transparent,
        foregroundColor: active ? Colors.white : AppPalette.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, size: 15),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  Widget _statsGrid() => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 1.5,
    children: const [
      _StatCard(title: 'RETURN REQUESTS', value: '02', icon: Icons.assignment_return_outlined),
      _StatCard(title: 'COMPLETED RETURNS', value: '01', icon: Icons.task_alt_outlined),
    ],
  );

  Widget _buildListView() => Container(
    decoration: BoxDecoration(
      color: AppPalette.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppPalette.borderSoftBlue),
      boxShadow: AppPalette.cardShadow,
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF6FF)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppPalette.textStrongBlue, fontSize: 12.5),
        dataTextStyle: const TextStyle(color: AppPalette.textPrimary, fontSize: 13),
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
        rows: _items.map((item) => DataRow(cells: [
          DataCell(Text(item.postId)),
          DataCell(Text(item.bookingId.toString())),
          DataCell(Text(item.serviceType)),
          DataCell(Text(item.date)),
          DataCell(Text(item.customerName)),
          DataCell(Text(item.passportNo)),
          DataCell(Text('৳ ${item.packagePrice}')),
          DataCell(Text('৳ ${item.paidAmount}')),
          DataCell(_statusPill(item.statusLabel, item.statusLabel == 'Return Accepted' ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), item.statusLabel == 'Return Accepted' ? const Color(0xFF166534) : const Color(0xFF92400E))),
        ])).toList(),
      ),
    ),
  );

  Widget _buildCardView() => Column(
    children: _items.map((item) {
      final accepted = item.statusLabel == "Return Accepted";
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppPalette.borderSoftBlue),
          boxShadow: AppPalette.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text(
                item.serviceType,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppPalette.textPrimary),
              ),
            ),
            const SizedBox(width: 10),
            _statusPill(item.statusLabel, accepted ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), accepted ? const Color(0xFF166534) : const Color(0xFF92400E)),
          ]),
          const SizedBox(height: 4),
          Text(
            " • ",
            style: const TextStyle(color: AppPalette.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppPalette.borderNeutral),
            ),
            child: Column(children: [
              _row("Post ID", item.postId),
              _row("Booking ID", item.bookingId.toString()),
              _row("Date", item.date),
              _row("Customer", item.customerName),
              _row("Passport", item.passportNo, isLast: true),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accepted ? const Color(0xFFEAF8EE) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accepted ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A)),
            ),
            child: Row(children: [
              Expanded(child: _priceCol("Package Price", item.packagePrice)),
              Container(width: 1, height: 34, color: accepted ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A)),
              Expanded(child: _priceCol("Paid Amount", item.paidAmount)),
            ]),
          ),
        ]),
      );
    }).toList(),
  );

  Widget _row(String label, String value, {bool isLast = false}) => Container(
    padding: const EdgeInsets.symmetric(vertical: 7),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: isLast ? Colors.transparent : AppPalette.borderNeutral)),
    ),
    child: Row(children: [
      SizedBox(width: 96, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppPalette.textMuted, fontSize: 12))),
      Expanded(child: Text(value, style: const TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.w600))),
    ]),
  );

  Widget _priceCol(String label, int amount) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: AppPalette.textMuted, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text("৳ ", style: const TextStyle(fontSize: 16, color: AppPalette.textPrimary, fontWeight: FontWeight.w800)),
    ],
  );

  Widget _statusPill(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
    child: Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.softShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 16, color: AppPalette.brandBlue),
          const SizedBox(width: 6),
          Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: AppPalette.textMuted, fontWeight: FontWeight.w700))),
        ]),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppPalette.textPrimary)),
      ]),
    );
  }
}

class ReturnPassportItem {
  const ReturnPassportItem({required this.postId, required this.bookingId, required this.serviceType, required this.date, required this.customerName, required this.passportNo, required this.packagePrice, required this.paidAmount, required this.statusLabel});

  final String postId;
  final int bookingId;
  final String serviceType;
  final String date;
  final String customerName;
  final String passportNo;
  final int packagePrice;
  final int paidAmount;
  final String statusLabel;
}
