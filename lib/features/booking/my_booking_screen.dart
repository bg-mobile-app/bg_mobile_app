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
    BookingItem(postId: 'WP-1201', bookingId: 4571, serviceType: 'Work Permit', date: '2026-04-12', customerName: 'Rakib Hasan', passportNo: 'B12345678', packagePrice: 85000, paidAmount: 40000, statusLabel: 'Applied File'),
    BookingItem(postId: 'ST-2003', bookingId: 4572, serviceType: 'Student Visa', date: '2026-04-18', customerName: 'Nusrat Jahan', passportNo: 'A98765432', packagePrice: 120000, paidAmount: 120000, statusLabel: 'Success Flight'),
    BookingItem(postId: 'HJ-3098', bookingId: 4573, serviceType: 'Hajj Package', date: '2026-04-22', customerName: 'Abdul Karim', passportNo: 'E44112233', packagePrice: 230000, paidAmount: 80000, statusLabel: 'Under Processing'),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/booking/my',
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 18),
              const Text('Recruitment Portal  ›  ', style: TextStyle(color: Color(0xFF52525B), fontSize: 12)),
              const SizedBox(height: 2),
              const Text('My Booking', style: TextStyle(fontSize: 53 / 1.5, fontWeight: FontWeight.w700, color: Color(0xFF0B1E6D))),
              const SizedBox(height: 6),
              const Text(
                'Management and tracking for all your\ninternational talent placement files.',
                style: TextStyle(color: Color(0xFF374151), fontSize: 17),
              ),
              const SizedBox(height: 14),
              _viewToggle(),
              const SizedBox(height: 18),
              if (!_isCardView) ...[
                _statsGrid(),
                const SizedBox(height: 16),
                _listViewSection(),
              ] else
                _buildCardList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.menu, color: Color(0xFF0B1E6D)),
            SizedBox(width: 10),
            Text('Expert Connector', style: TextStyle(fontSize: 37 / 1.5, fontWeight: FontWeight.w700, color: Color(0xFF0B1E6D))),
          ],
        ),
        const CircleAvatar(radius: 17, backgroundImage: AssetImage('assets/img/sign-in/login.jpg')),
      ],
    );
  }

  Widget _viewToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(12)),
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
        backgroundColor: active ? Colors.white : Colors.transparent,
        foregroundColor: active ? const Color(0xFF0B1E6D) : const Color(0xFF4B5563),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _statsGrid() {
    return Column(
      children: const [
        _StatCard(title: 'TOTAL BOOKINGS', value: '12', highlighted: true),
        SizedBox(height: 12),
        _StatCard(title: 'ACTIVE FILES', value: '08'),
        SizedBox(height: 12),
        _StatCard(title: 'SUCCESS RATE', value: '94%'),
        SizedBox(height: 12),
        _StatCard(title: 'PENDING DUES', value: '৳ 235k', error: true),
      ],
    );
  }

  Widget _listViewSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.folder_open_outlined, color: Color(0xFF0B1E6D)),
                    SizedBox(width: 8),
                    Text('All Booking File', style: TextStyle(fontSize: 38 / 2, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search ID or Customer...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.filter_list, color: Color(0xFF111827)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFEFF6FF),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: const [
                Expanded(child: Text('POST\nID', style: _headerStyle)),
                Expanded(child: Text('BOOKING\nID', style: _headerStyle)),
                Expanded(child: Text('SERVICE\nTYPE', style: _headerStyle)),
              ],
            ),
          ),
          ..._bookings.map((item) => _SimpleBookingRow(item: item)),
          const SizedBox(height: 8),
          const Text('Showing 1 to 3 of 12 files', style: TextStyle(fontSize: 14, color: Color(0xFF374151))),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [_pageBtn(icon: Icons.chevron_left), _pageBtn(label: '1', active: true), _pageBtn(label: '2'), _pageBtn(label: '3'), _pageBtn(icon: Icons.chevron_right)]),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  static Widget _pageBtn({String? label, IconData? icon, bool active = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: active ? const Color(0xFF0B1E6D) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: icon != null ? Icon(icon, size: 18) : Text(label!, style: TextStyle(color: active ? Colors.white : Colors.black87)),
        ),
      ),
    );
  }

  Widget _buildCardList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Booking File • 3 total entries', style: TextStyle(color: Color(0xFF4B5563), fontSize: 14)),
          const SizedBox(height: 10),
          ..._bookings.map((item) {
            final style = _styleFor(item.statusLabel);
            final progress = ((item.paidAmount / item.packagePrice) * 100).round();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(color: style.iconBg, borderRadius: BorderRadius.circular(10)),
                    child: Icon(style.icon, color: style.iconColor),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: style.badgeBg, borderRadius: BorderRadius.circular(14)),
                    child: Text(item.statusLabel, style: TextStyle(color: style.badgeText, fontSize: 12)),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(item.serviceType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  Text(item.postId, style: const TextStyle(color: Color(0xFF6B7280))),
                ]),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF6B7280)), const SizedBox(width: 5), Text(_displayDate(item.date), style: const TextStyle(color: Color(0xFF4B5563)))]),
                const SizedBox(height: 12),
                _row('Customer', item.customerName),
                _row('Passport', item.passportNo),
                _row('Total Price', '৳ ${_money(item.packagePrice)}', valueStyle: const TextStyle(color: Color(0xFF0B1E6D), fontSize: 24, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: style.progressBg, borderRadius: BorderRadius.circular(8)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(style.progressLabel, style: TextStyle(color: style.progressText)), Text('$progress%', style: const TextStyle(fontWeight: FontWeight.w600))]),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(value: progress / 100, minHeight: 4, backgroundColor: style.progressTrack, valueColor: AlwaysStoppedAnimation<Color>(style.progressColor)),
                    ),
                    const SizedBox(height: 6),
                    Text('Paid: ৳ ${_money(item.paidAmount)}', style: TextStyle(color: style.progressText, fontWeight: FontWeight.w600)),
                  ]),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {},
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44), backgroundColor: const Color(0xFF0B2A83)),
                  icon: Icon(style.ctaIcon, size: 18),
                  label: Text(style.ctaLabel),
                ),
              ]),
            );
          }),
        ],
      );

  Widget _row(String label, String value, {TextStyle? valueStyle}) => Container(
    padding: const EdgeInsets.only(bottom: 8, top: 2),
    margin: const EdgeInsets.only(bottom: 2),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
    child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF4B5563), letterSpacing: 0.8))), Text(value, style: valueStyle ?? const TextStyle(fontSize: 16))]),
  );

  String _displayDate(String iso) {
    final parts = iso.split('-');
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[int.parse(parts[1]) - 1]} ${parts[2]}, ${parts[0]}';
  }

  String _money(int amount) {
    final s = amount.toString();
    final chars = s.split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < chars.length; i += 3) {
      chunks.add(chars.skip(i).take(3).join());
    }
    return chunks.map((c) => c.split('').reversed.join()).toList().reversed.join(',');
  }

  _CardStyle _styleFor(String status) {
    switch (status) {
      case 'Success Flight':
        return const _CardStyle(icon: Icons.school_outlined, iconBg: Color(0xFFCCF3D9), iconColor: Color(0xFF166534), badgeBg: Color(0xFFD1FAE5), badgeText: Color(0xFF166534), progressBg: Color(0xFFEAF8EE), progressTrack: Color(0xFFBBF7D0), progressColor: Color(0xFF16A34A), progressText: Color(0xFF166534), progressLabel: 'Payment Completed', ctaLabel: 'View Receipt', ctaIcon: Icons.receipt_long);
      case 'Under Processing':
        return const _CardStyle(icon: Icons.mosque_outlined, iconBg: Color(0xFFFEF3C7), iconColor: Color(0xFF92400E), badgeBg: Color(0xFFFEF3C7), badgeText: Color(0xFF92400E), progressBg: Color(0xFFF3F4F6), progressTrack: Color(0xFFE5E7EB), progressColor: Color(0xFFF59E0B), progressText: Color(0xFF111827), progressLabel: 'Payment Progress', ctaLabel: 'View Details', ctaIcon: Icons.arrow_forward);
      default:
        return const _CardStyle(icon: Icons.work_outline, iconBg: Color(0xFFDBEAFE), iconColor: Color(0xFF1D4ED8), badgeBg: Color(0xFFDBEAFE), badgeText: Color(0xFF1D4ED8), progressBg: Color(0xFFF3F4F6), progressTrack: Color(0xFFE5E7EB), progressColor: Color(0xFF1E3A8A), progressText: Color(0xFF111827), progressLabel: 'Payment Progress', ctaLabel: 'View Details', ctaIcon: Icons.arrow_forward);
    }
  }
}

class _SimpleBookingRow extends StatelessWidget {
  const _SimpleBookingRow({required this.item});
  final BookingItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
      child: Row(
        children: [
          Expanded(child: Text(item.postId, style: const TextStyle(fontSize: 32 / 2, fontWeight: FontWeight.w500))),
          Expanded(child: Text('#${item.bookingId}', style: const TextStyle(fontSize: 16))),
          Expanded(
            child: Wrap(
              runSpacing: 4,
              children: item.serviceType.split(' ').map((e) => Container(margin: const EdgeInsets.only(right: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(8)), child: Text(e))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, this.highlighted = false, this.error = false});
  final String title;
  final String value;
  final bool highlighted;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: highlighted ? const Color(0xFF0B1E6D) : Colors.transparent, width: 4)),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 24 / 2, color: Color(0xFF111827), letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 48 / 2, color: error ? const Color(0xFFB91C1C) : const Color(0xFF111827), fontWeight: FontWeight.w500)),
      ]),
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
  final String postId;
  final int bookingId;
  final String serviceType;
  final String date;
  final String customerName;
  final String passportNo;
  final int packagePrice;
  final int paidAmount;
  final String statusLabel;

  const BookingItem({required this.postId, required this.bookingId, required this.serviceType, required this.date, required this.customerName, required this.passportNo, required this.packagePrice, required this.paidAmount, required this.statusLabel});
}

const _headerStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0B1E6D), letterSpacing: 1);
