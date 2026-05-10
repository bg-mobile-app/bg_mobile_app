import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_colors.dart';
import '../home/dashboard_screen.dart';
import 'appointment_ticket_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
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
      packagePrice: 95000,
      paidAmount: 45000,
      avatarText: 'SH',
      avatarColor: Color(0xFF2563EB),
      actionLabel: 'Download Ticket',
      packagePrice: 85000,
      paidAmount: 45000,
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
      packagePrice: 125000,
      paidAmount: 125000,
      avatarText: 'AL',
      avatarColor: Color(0xFFC7D2FE),
      avatarTextColor: Color(0xFF475569),
      actionLabel: 'Join Meeting',
      packagePrice: 78000,
      paidAmount: 38000,
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
      packagePrice: 110000,
      paidAmount: 60000,
      avatarText: 'DK',
      avatarColor: Color(0xFF6B7280),
      actionLabel: 'Download Ticket',
      packagePrice: 85000,
      paidAmount: 45000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/appointment',
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _breadcrumb(),
                const SizedBox(height: 8),
                const Text(
                  'Appointment Booking',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _viewSwitcher(),
                const SizedBox(height: 12),
                _searchBar(),
                const SizedBox(height: 10),
                _filterButton(),
                const SizedBox(height: 12),
                Expanded(child: _isCardView ? _buildCardView() : _buildListView()),
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
            'Dashboard',
            style: TextStyle(color: AppPalette.textMuted, fontSize: 12),
          ),
        ),
        BreadCrumbItem(
          content: const Text(
            'Appointment Booking',
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

  Widget _viewSwitcher() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        border: Border.all(color: AppPalette.borderSoftBlue),
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppPalette.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _switchButton(
            label: 'Card View',
            icon: Icons.grid_view_rounded,
            isActive: _isCardView,
            onTap: () => setState(() => _isCardView = true),
          ),
          _switchButton(
            label: 'List View',
            icon: Icons.view_list_rounded,
            isActive: !_isCardView,
            onTap: () => setState(() => _isCardView = false),
          ),
        ],
      ),
    );
  }

  Widget _switchButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.white : AppPalette.textMuted,
        backgroundColor: isActive ? AppPalette.brandBlue : Colors.transparent,
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

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppPalette.borderSoftBlue),
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppPalette.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Search in Appointment Booking',
                hintStyle: TextStyle(color: AppPalette.textMuted),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppPalette.brandBlue,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x402563EB),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.search, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppPalette.textStrongBlue,
        side: const BorderSide(color: AppPalette.borderSoftBlue),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.filter_list),
      label: const Text('Filters'),
    );
  }

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
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppPalette.textStrongBlue,
          fontSize: 12.5,
        ),
        dataTextStyle: const TextStyle(
          color: AppPalette.textPrimary,
          fontSize: 13,
        ),
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
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: AppPalette.brandBlue,
                      ),
                      onPressed: () => _openTicket(item),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    ),
  );

  Widget _buildCardView() => ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = _items[index];
          final dueAmount = item.packagePrice - item.paidAmount;

          return Container(
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(color: item.avatarColor, borderRadius: BorderRadius.circular(999)),
                        child: const Icon(Icons.person_outline, color: Colors.white, size: 36),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF191B24))),
                          const SizedBox(height: 4),
                          Row(children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFD8E6FF), borderRadius: BorderRadius.circular(8)), child: Text(item.postId, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF38485D)))),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: Color(0xFF737687), fontSize: 12)),
                            const SizedBox(width: 8),
                            Text(item.country, style: const TextStyle(fontSize: 16, color: Color(0xFF434655))),
                          ]),
                        ]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: _detailTile('VISA CATEGORY', item.visaCategory, Icons.article_outlined)),
                      const SizedBox(width: 14),
                      Expanded(child: _detailTile('MEETING TYPE', item.meeting, Icons.groups_outlined)),
                    ]),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(child: _detailTile('DATE', item.date, Icons.calendar_today_outlined)),
                      const SizedBox(width: 14),
                      Expanded(child: _detailTile('TIME', item.time, Icons.schedule)),
                    ]),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFF1F3FF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFBBC1D6))),
                      child: Row(children: [
                        const Icon(Icons.flight, color: Color(0xFF434655), size: 30),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('PASSPORT NUMBER', style: TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700, color: Color(0xFF737687))),
                          Text(item.passportNo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                        ])),
                        const Icon(Icons.verified, color: Color(0xFF737687), size: 28),
                      ]),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFFBBC1D6)),
                    const SizedBox(height: 12),
                    _amountRow('Package Price', '${_formatMoney(item.packagePrice)} BDT', const Color(0xFF191B24), false),
                    const SizedBox(height: 12),
                    _amountRow('Paid Amount', '${_formatMoney(item.paidAmount)} BDT', AppColors.primary, true),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFFFAD6D6), borderRadius: BorderRadius.circular(14)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('DUE AMOUNT', style: TextStyle(color: Color(0xFF9F0E0E), fontWeight: FontWeight.w700, fontSize: 16)),
                        Text('${_formatMoney(dueAmount)} BDT', style: const TextStyle(color: Color(0xFF9F0E0E), fontWeight: FontWeight.w800, fontSize: 24)),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _openTicket(item),
                        icon: const Icon(Icons.download, size: 22),
                        label: const Text('Download Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                  ]),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: const BoxDecoration(color: Color(0xFFF1F3FF), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.info_outline, color: Color(0xFF737687), size: 18),
                    SizedBox(width: 8),
                    Flexible(child: Text('PLEASE ARRIVE 15 MINUTES BEFORE YOUR SCHEDULED TIME.', style: TextStyle(fontSize: 11, color: Color(0xFF434655), fontWeight: FontWeight.w600))),
                  ]),
                ),
              ],
            ),
          );
        },
      );

  Widget _detailTile(String label, String value, IconData icon) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700, color: Color(0xFF737687))),
      const SizedBox(height: 6),
      Row(children: [Icon(icon, size: 22, color: AppColors.primary), const SizedBox(width: 8), Expanded(child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))]),
    ]);
  }

  Widget _amountRow(String label, String value, Color color, bool bold) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 18, color: Color(0xFF434655))),
      Text(value, style: TextStyle(fontSize: 24, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: color)),
    ]);
  }

  String _formatMoney(int amount) {
    final s = amount.toString();
    final chars = s.split('').reversed.toList();
    final parts = <String>[];
    for (int i = 0; i < chars.length; i += 3) {
      parts.add(chars.sublist(i, (i + 3).clamp(0, chars.length)).join());
    }
    return parts.join(',').split('').reversed.join();
  }

  Widget _metaCard(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppPalette.textMuted,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppPalette.brandBlue),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateTimeBlock(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppPalette.textPrimary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppPalette.textMuted, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppPalette.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumBanner() { // legacy

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage('assets/img/customer/appointment/Malaysia.webp'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xB3000000), BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PREMIUM ASSISTANCE',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.3,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Need help with your interview?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our consultants are available for mock interviews and document reviews to increase your success rate.',
            style: TextStyle(color: Color(0xFFE2E8F0), height: 1.4),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.brandBlue,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Connect with Consultant'),
          ),
        ],
      ),
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
  final int packagePrice;
  final int paidAmount;

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
    required this.packagePrice,
    required this.paidAmount,
    required this.avatarText,
    required this.avatarColor,
    this.avatarTextColor = Colors.white,
    required this.actionLabel,
    required this.packagePrice,
    required this.paidAmount,
  });
}
