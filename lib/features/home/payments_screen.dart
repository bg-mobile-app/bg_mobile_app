import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_palette.dart';
import '../../common/theme/app_text_styles.dart';
import 'dashboard_screen.dart';

const List<String> bookingStatus = [
  'ADVANCE',
  'AFTER_VISA',
  'BEFORE_FLIGHT',
  'RETURN',
  'COMPLETED',
];

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  static const int _pageSize = 20;

  final _searchController = TextEditingController();
  Timer? _debounce;

  String _status = '';
  String _debouncedSearch = '';
  int _currentPage = 1;
  bool _cardView = true;

  final List<PaymentHistoryItem> _allPayments = [
    PaymentHistoryItem(id: '1000', bookingId: 'B-99821', postId: 'P-5541', collectedAt: DateTime(2026, 1, 27, 10, 20), passportNo: 'A12345678', amount: 50000, step: 'ADVANCE'),
    PaymentHistoryItem(id: '0999', bookingId: 'B-99750', postId: 'P-5420', collectedAt: DateTime(2026, 1, 20, 14, 45), passportNo: 'A12345678', amount: 50000, step: 'RETURN'),
    PaymentHistoryItem(id: '0998', bookingId: 'B-99740', postId: 'P-5380', collectedAt: DateTime(2026, 1, 15, 9, 30), passportNo: 'B87654321', amount: 75000, step: 'COMPLETED'),
    PaymentHistoryItem(id: '0997', bookingId: 'B-99722', postId: 'P-5301', collectedAt: DateTime(2026, 1, 10, 11, 0), passportNo: 'C11223344', amount: 42000, step: 'ADVANCE'),
    PaymentHistoryItem(id: '0996', bookingId: 'B-99710', postId: 'P-5250', collectedAt: DateTime(2026, 1, 5, 16, 15), passportNo: 'D55667788', amount: 60000, step: 'ADVANCE'),
    PaymentHistoryItem(id: '0995', bookingId: 'B-99690', postId: 'P-5110', collectedAt: DateTime(2026, 1, 1, 10, 0), passportNo: 'E99887766', amount: 90000, step: 'COMPLETED'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _debouncedSearch = _searchController.text.trim();
        _currentPage = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allPayments.where((item) {
      final statusOk = _status.isEmpty || item.step == _status;
      final searchOk = _debouncedSearch.isEmpty || item.passportNo.toLowerCase().contains(_debouncedSearch.toLowerCase());
      return statusOk && searchOk;
    }).toList();

    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, filtered.length);
    final pageItems = filtered.sublist(start, end);

    return DashboardPageScaffold(
      currentHref: '/dashboard/my-payments',
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
                Text(
                  'Payments History',
                  style: AppTextStyles.headline2.copyWith(fontSize: 25, fontWeight: FontWeight.w800, color: AppPalette.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'See history of your payment plan invoice (${filtered.length})',
                  style: AppTextStyles.body2.copyWith(color: AppPalette.textMuted),
                ),
                const SizedBox(height: 14),
                _topControls(),
                const SizedBox(height: 12),
                _searchBox(),
                const SizedBox(height: 16),
                _cardView ? _cardContent(pageItems) : _tableContent(pageItems),
                const SizedBox(height: 16),
                _statsSection(),
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
          content: Text('Dashboard', style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted)),
        ),
        BreadCrumbItem(
          content: Text(
            'Payments',
            style: AppTextStyles.caption.copyWith(color: AppPalette.textStrongBlue, fontWeight: FontWeight.w700),
          ),
        ),
      ],
      divider: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
    );
  }

  Widget _topControls() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppPalette.borderSoftBlue),
            boxShadow: AppPalette.softShadow,
          ),
          child: Row(
            children: [
              _viewButton(label: 'Card View', icon: Icons.grid_view_rounded, active: _cardView, onTap: () => setState(() => _cardView = true)),
              _viewButton(label: 'List View', icon: Icons.view_list_rounded, active: !_cardView, onTap: () => setState(() => _cardView = false)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _statusDropdown()),
      ],
    );
  }

  Widget _viewButton({required String label, required IconData icon, required bool active, required VoidCallback onTap}) {
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

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        border: Border.all(color: AppPalette.borderSoftBlue),
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppPalette.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppPalette.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search by Passport No...',
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

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _status,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPalette.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppPalette.borderSoftBlue)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppPalette.borderSoftBlue)),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Status')),
        ...bookingStatus.map((e) => DropdownMenuItem(value: e, child: Text(e))),
      ],
      onChanged: (value) => setState(() {
        _status = value ?? '';
        _currentPage = 1;
      }),
    );
  }

  Widget _tableContent(List<PaymentHistoryItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.cardShadow,
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF6FF)),
              headingTextStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppPalette.textStrongBlue, fontSize: 12.5),
              dataTextStyle: const TextStyle(color: AppPalette.textPrimary, fontSize: 13),
              columns: const [
                DataColumn(label: Text('Payment Invoice')),
                DataColumn(label: Text('Booking ID')),
                DataColumn(label: Text('Post ID')),
                DataColumn(label: Text('Payment Date')),
                DataColumn(label: Text('Passport No')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Status')),
              ],
              rows: items
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text('#INV-${item.id}', style: const TextStyle(fontWeight: FontWeight.w700))),
                        DataCell(Text(item.bookingId)),
                        DataCell(Text(item.postId)),
                        DataCell(Text(_formatListDate(item.collectedAt))),
                        DataCell(Text(item.passportNo)),
                        DataCell(Text('৳ ${_money(item.amount)}', style: const TextStyle(fontWeight: FontWeight.w700))),
                        DataCell(_statusChip(item.step)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          _pagination(items.length),
        ],
      ),
    );
  }

  Widget _cardContent(List<PaymentHistoryItem> items) {
    return Column(
      children: [
        ...items.map(_paymentCard),
        _pagination(items.length),
      ],
    );
  }

  Widget _paymentCard(PaymentHistoryItem item) {
    final isReturn = item.step == 'RETURN';
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
                    color: isReturn ? const Color(0xFFFAD6D6) : const Color(0xFFD8E6FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    isReturn ? Icons.keyboard_return_rounded : Icons.payments_outlined,
                    color: isReturn ? const Color(0xFF9F0E0E) : AppPalette.brandBlue,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#INV-${item.id}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF191B24)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFD8E6FF), borderRadius: BorderRadius.circular(8)),
                            child: Text(item.postId, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF38485D))),
                          ),
                          const SizedBox(width: 8),
                          const Text('•', style: TextStyle(color: Color(0xFF737687), fontSize: 12)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item.bookingId, style: const TextStyle(fontSize: 15, color: Color(0xFF434655))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _statusChip(item.step),
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
                    Expanded(child: _detailTile('PAYMENT DATE', _formatListDate(item.collectedAt), Icons.calendar_today_outlined)),
                    const SizedBox(width: 14),
                    Expanded(child: _detailTile('PAYMENT TIME', _formatTime(item.collectedAt), Icons.schedule)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _detailTile('PASSPORT NO', item.passportNo, Icons.badge_outlined)),
                    const SizedBox(width: 14),
                    Expanded(child: _detailTile('PAYMENT TYPE', item.step, Icons.article_outlined)),
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
                      const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF434655), size: 30),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AMOUNT', style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700, color: Color(0xFF737687))),
                            Text('৳ ${_money(item.amount)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: isReturn ? const Color(0xFF9F0E0E) : AppPalette.textPrimary)),
                          ],
                        ),
                      ),
                      Icon(isReturn ? Icons.trending_down_rounded : Icons.trending_up_rounded, color: isReturn ? const Color(0xFF9F0E0E) : const Color(0xFF166534), size: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppPalette.brandBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppPalette.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TOTAL PROCESSED', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('৳ ${_money(_allPayments.fold<int>(0, (sum, i) => sum + i.amount))}', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.borderSoftBlue),
            boxShadow: AppPalette.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PENDING CLAIMS', style: TextStyle(color: AppPalette.textMuted, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                '${_allPayments.where((i) => i.step != 'COMPLETED').length}',
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: AppPalette.textPrimary),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: _allPayments.where((i) => i.step == 'COMPLETED').length / _allPayments.length,
                  minHeight: 5,
                  color: AppPalette.brandBlue,
                  backgroundColor: const Color(0xFFE7EAF3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pagination(int countOnPage) {
    final filteredCount = _allPayments.where((i) => (_status.isEmpty || i.step == _status) && (_debouncedSearch.isEmpty || i.passportNo.toLowerCase().contains(_debouncedSearch.toLowerCase()))).length;
    final totalPages = (filteredCount / _pageSize).ceil().clamp(1, 999);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Showing ${countOnPage == 0 ? 0 : ((_currentPage - 1) * _pageSize) + 1} to ${((_currentPage - 1) * _pageSize) + countOnPage} of $filteredCount entries',
              style: const TextStyle(fontSize: 12, color: AppPalette.textMuted),
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null, icon: const Icon(Icons.chevron_left_rounded)),
              Text('Page $_currentPage of $totalPages', style: const TextStyle(fontSize: 13)),
              IconButton(onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null, icon: const Icon(Icons.chevron_right_rounded)),
            ],
          ),
        ],
      ),
    );
  }

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

  Widget _statusChip(String status) {
    final isReturn = status == 'RETURN';
    final isCompleted = status == 'COMPLETED';

    Color bg = const Color(0xFFD8F3DE);
    Color fg = const Color(0xFF1C7A3B);

    if (isReturn) {
      bg = const Color(0xFFF8D8D7);
      fg = const Color(0xFFB3261E);
    } else if (!isCompleted && status != 'ADVANCE') {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final min = date.minute.toString().padLeft(2, '0');
    final meridiem = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $meridiem';
  }

  String _formatListDate(DateTime date) {
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${monthNames[date.month - 1]}, ${date.year}';
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
}

class PaymentHistoryItem {
  const PaymentHistoryItem({
    required this.id,
    required this.bookingId,
    required this.postId,
    required this.collectedAt,
    required this.passportNo,
    required this.amount,
    required this.step,
  });

  final String id;
  final String bookingId;
  final String postId;
  final DateTime collectedAt;
  final String passportNo;
  final int amount;
  final String step;
}
