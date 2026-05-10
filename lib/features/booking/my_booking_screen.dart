import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_palette.dart';
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
                  'My Booking',
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
                if (_isCardView) _buildCardList() else _buildTableList(),
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
            'My Booking',
            style: TextStyle(
              color: AppPalette.textStrongBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      divider: const Icon(
        Icons.chevron_right_rounded,
        size: 16,
        color: Color(0xFF94A3B8),
      ),
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
          _toggleButton(
            'List View',
            Icons.format_list_bulleted,
            !_isCardView,
            () => setState(() => _isCardView = false),
          ),
          _toggleButton(
            'Card View',
            Icons.grid_view_rounded,
            _isCardView,
            () => setState(() => _isCardView = true),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(
    String label,
    IconData icon,
    bool active,
    VoidCallback onTap,
  ) {
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
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _statsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.45,
      children: const [
        _StatCard(
          title: 'TOTAL BOOKINGS',
          value: '12',
          icon: Icons.inventory_2_outlined,
        ),
        _StatCard(
          title: 'ACTIVE FILES',
          value: '08',
          icon: Icons.work_history_outlined,
        ),
        _StatCard(
          title: 'SUCCESS RATE',
          value: '94%',
          icon: Icons.trending_up_rounded,
        ),
        _StatCard(
          title: 'PENDING DUES',
          value: '৳ 235k',
          icon: Icons.account_balance_wallet_outlined,
          error: true,
        ),
      ],
    );
  }

  Widget _buildTableList() => Container(
    decoration: BoxDecoration(
      color: AppPalette.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppPalette.borderSoftBlue),
      boxShadow: AppPalette.cardShadow,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.table_chart_outlined,
                  color: AppPalette.brandBlue,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'All Booking Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${_bookings.length} entries',
                style: const TextStyle(
                  color: AppPalette.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppPalette.borderNeutral),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF6FF)),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppPalette.textStrongBlue,
              fontSize: 12.5,
            ),
            dataTextStyle: const TextStyle(
              color: AppPalette.textPrimary,
              fontSize: 13,
            ),
            horizontalMargin: 14,
            columnSpacing: 20,
            dividerThickness: 0.6,
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
            rows: _bookings.map((item) {
              final style = _styleFor(item.statusLabel);
              return DataRow(
                cells: [
                  DataCell(Text(item.postId)),
                  DataCell(Text(item.bookingId.toString())),
                  DataCell(Text(item.serviceType)),
                  DataCell(Text(_displayDate(item.date))),
                  DataCell(
                    Text(
                      '${item.customerName}\n${item.passportNo}',
                      style: const TextStyle(height: 1.35),
                    ),
                  ),
                  DataCell(Text('৳ ${_money(item.packagePrice)}')),
                  DataCell(Text('৳ ${_money(item.paidAmount)}')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: style.badgeBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.statusLabel,
                        style: TextStyle(
                          color: style.badgeText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );

  Widget _buildCardList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Booking File • ${_bookings.length} total entries',
            style: const TextStyle(color: AppPalette.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ..._bookings.map((item) {
            final style = _styleFor(item.statusLabel);
            final dueAmount = item.packagePrice - item.paidAmount;
            return Container(
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
                            color: style.iconBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Icon(style.icon, color: style.iconColor, size: 34),
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
                                    style: TextStyle(
                                      color: Color(0xFF737687),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.serviceType,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF434655),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                            Expanded(
                              child: _detailTile(
                                'BOOKING ID',
                                item.bookingId.toString(),
                                Icons.confirmation_num_outlined,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _detailTile(
                                'STATUS',
                                item.statusLabel,
                                Icons.groups_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _detailTile(
                                'DATE',
                                _displayDate(item.date),
                                Icons.calendar_today_outlined,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _detailTile(
                                'SERVICE TYPE',
                                item.serviceType,
                                Icons.article_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFBBC1D6)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flight,
                                color: Color(0xFF434655),
                                size: 30,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'PASSPORT NUMBER',
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF737687),
                                      ),
                                    ),
                                    Text(
                                      item.passportNo,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: style.badgeBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.statusLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: style.badgeText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Color(0xFFBBC1D6)),
                        const SizedBox(height: 12),
                        _amountRow(
                          'Package Price',
                          '${_money(item.packagePrice)} BDT',
                          const Color(0xFF191B24),
                          false,
                        ),
                        const SizedBox(height: 12),
                        _amountRow(
                          'Paid Amount',
                          '${_money(item.paidAmount)} BDT',
                          AppPalette.brandBlue,
                          true,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAD6D6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'DUE AMOUNT',
                                style: TextStyle(
                                  color: Color(0xFF9F0E0E),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_money(dueAmount)} BDT',
                                style: const TextStyle(
                                  color: Color(0xFF9F0E0E),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {},
                            icon: Icon(style.ctaIcon, size: 18),
                            label: Text(
                              style.ctaLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              backgroundColor: AppPalette.borderSoftBlue,
                              foregroundColor: AppPalette.textMuted,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F3FF),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF737687),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'PLEASE ARRIVE 15 MINUTES BEFORE YOUR SCHEDULED TIME.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF434655),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );

  Widget _detailTile(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF737687),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, size: 22, color: AppPalette.brandBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
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
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  String _displayDate(String iso) {
    final parts = iso.split('-');
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[int.parse(parts[1]) - 1]} ${parts[2]}, ${parts[0]}';
  }

  String _money(int amount) {
    final s = amount.toString();
    final chars = s.split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < chars.length; i += 3) {
      chunks.add(chars.skip(i).take(3).join());
    }
    return chunks
        .map((c) => c.split('').reversed.join())
        .toList()
        .reversed
        .join(',');
  }

  _CardStyle _styleFor(String status) {
    switch (status) {
      case 'Success Flight':
        return const _CardStyle(
          icon: Icons.school_outlined,
          iconBg: Color(0xFFCCF3D9),
          iconColor: AppPalette.success,
          badgeBg: AppPalette.successBg,
          badgeText: AppPalette.success,
          progressBg: Color(0xFFEAF8EE),
          progressTrack: Color(0xFFBBF7D0),
          progressColor: Color(0xFF16A34A),
          progressText: AppPalette.success,
          progressLabel: 'Payment Completed',
          ctaLabel: 'View Receipt',
          ctaIcon: Icons.receipt_long,
        );
      case 'Under Processing':
        return const _CardStyle(
          icon: Icons.mosque_outlined,
          iconBg: AppPalette.warningBg,
          iconColor: AppPalette.warning,
          badgeBg: AppPalette.warningBg,
          badgeText: AppPalette.warning,
          progressBg: Color(0xFFF3F4F6),
          progressTrack: Color(0xFFE5E7EB),
          progressColor: Color(0xFFF59E0B),
          progressText: AppPalette.textPrimary,
          progressLabel: 'Payment Progress',
          ctaLabel: 'View Details',
          ctaIcon: Icons.arrow_forward,
        );
      default:
        return const _CardStyle(
          icon: Icons.work_outline,
          iconBg: Color(0xFFDBEAFE),
          iconColor: Color(0xFF1D4ED8),
          badgeBg: Color(0xFFDBEAFE),
          badgeText: Color(0xFF1D4ED8),
          progressBg: Color(0xFFF3F4F6),
          progressTrack: Color(0xFFE5E7EB),
          progressColor: AppPalette.textStrongBlue,
          progressText: AppPalette.textPrimary,
          progressLabel: 'Payment Progress',
          ctaLabel: 'View Details',
          ctaIcon: Icons.arrow_forward,
        );
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.error = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: AppPalette.brandBlue),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppPalette.textMuted,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              color: error ? AppPalette.danger : AppPalette.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardStyle {
  const _CardStyle({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeText,
    required this.progressBg,
    required this.progressTrack,
    required this.progressColor,
    required this.progressText,
    required this.progressLabel,
    required this.ctaLabel,
    required this.ctaIcon,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeText;
  final Color progressBg;
  final Color progressTrack;
  final Color progressColor;
  final Color progressText;
  final String progressLabel;
  final String ctaLabel;
  final IconData ctaIcon;
}

class BookingItem {
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
