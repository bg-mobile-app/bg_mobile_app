import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_palette.dart';
import '../home/dashboard_screen.dart';

class SuccessFlightScreen extends StatefulWidget {
  const SuccessFlightScreen({super.key});

  @override
  State<SuccessFlightScreen> createState() => _SuccessFlightScreenState();
}

class _SuccessFlightScreenState extends State<SuccessFlightScreen> {
  bool _isCardView = false;

  final List<SuccessFlightItem> _items = const [
    SuccessFlightItem(
      postId: 'WP-1201',
      bookingId: 4571,
      serviceType: 'Work Permit',
      date: '2026-04-12',
      customerName: 'Rakib Hasan',
      passportNo: 'B12345678',
      packagePrice: 85000,
      paidAmount: 85000,
      statusLabel: 'Success Flight',
    ),
    SuccessFlightItem(
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
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/my/success-file',
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
                  'Success Flight',
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
        BreadCrumbItem(
          content: const Text(
            'Recruitment Portal',
            style: TextStyle(color: AppPalette.textMuted, fontSize: 12),
          ),
        ),
        BreadCrumbItem(
          content: const Text(
            'Success Flight',
            style: TextStyle(
              color: AppPalette.textStrongBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
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
      _StatCard(title: 'SUCCESS FILES', value: '02', icon: Icons.flight_takeoff_outlined),
      _StatCard(title: 'FULLY PAID', value: '02', icon: Icons.verified_outlined),
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
          DataCell(_statusPill(item.statusLabel, const Color(0xFFD1FAE5), const Color(0xFF166534))),
        ])).toList(),
      ),
    ),
  );

  Widget _buildCardView() => Column(
        children: _items.map((item) {
          final dueAmount = item.packagePrice - item.paidAmount;
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBC1D6)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: Color(0xFF166534),
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.customerName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF191B24),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD8E6FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.postId,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF38485D),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '•',
                                  style: TextStyle(color: Color(0xFF737687), fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.serviceType,
                                    style: const TextStyle(fontSize: 15, color: Color(0xFF434655)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _statusPill(item.statusLabel, const Color(0xFFD1FAE5), const Color(0xFF166534)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _detailTile('BOOKING ID', item.bookingId.toString(), Icons.confirmation_num_outlined)),
                          const SizedBox(width: 14),
                          Expanded(child: _detailTile('STATUS', item.statusLabel, Icons.groups_outlined)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(child: _detailTile('DATE', _displayDate(item.date), Icons.calendar_today_outlined)),
                          const SizedBox(width: 14),
                          Expanded(child: _detailTile('SERVICE TYPE', item.serviceType, Icons.article_outlined)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBBC1D6)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flight, color: Color(0xFF434655), size: 30),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PASSPORT NUMBER',
                                    style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700, color: Color(0xFF737687)),
                                  ),
                                  Text(item.passportNo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            const Icon(Icons.verified, color: Color(0xFF737687), size: 28),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(color: Color(0xFFBBC1D6)),
                      const SizedBox(height: 12),
                      _amountRow('Package Price', '${_money(item.packagePrice)} BDT', const Color(0xFF191B24), false),
                      const SizedBox(height: 12),
                      _amountRow('Paid Amount', '${_money(item.paidAmount)} BDT', AppPalette.brandBlue, true),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('DUE AMOUNT', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('${_money(dueAmount)} BDT', style: const TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w800, fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );

  Widget _detailTile(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700, color: Color(0xFF737687))),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, size: 22, color: AppPalette.brandBlue),
            const SizedBox(width: 8),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
          ],
        ),
      ],
    );
  }

  Widget _amountRow(String label, String value, Color color, bool bold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: Color(0xFF434655))),
        Text(value, style: TextStyle(fontSize: 19, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: color)),
      ],
    );
  }

  String _displayDate(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[int.parse(parts[1]) - 1]} ${parts[2]}, ${parts[0]}';
  }

  String _money(int amount) {
    final s = amount.toString();
    final chars = s.split('').reversed.toList();
    final parts = <String>[];
    for (int i = 0; i < chars.length; i += 3) {
      parts.add(chars.sublist(i, (i + 3).clamp(0, chars.length)).join());
    }
    return parts.join(',').split('').reversed.join();
  }

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

class SuccessFlightItem {
  const SuccessFlightItem({required this.postId, required this.bookingId, required this.serviceType, required this.date, required this.customerName, required this.passportNo, required this.packagePrice, required this.paidAmount, required this.statusLabel});

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
