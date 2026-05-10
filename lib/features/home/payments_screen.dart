import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/theme/app_colors.dart';
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
  bool _cardView = false;

  final List<PaymentHistoryItem> _allPayments = const [
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

    final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999);
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, filtered.length);
    final pageItems = filtered.sublist(start, end);

    return DashboardPageScaffold(
      currentHref: '/dashboard/my-payments',
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payments History (${filtered.length})', style: AppTextStyles.headline1.copyWith(fontSize: 50, height: 1.05, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('See history of your payment plan invoice', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 14),
              _topControls(),
              const SizedBox(height: 14),
              _searchBox(),
              const SizedBox(height: 16),
              _cardView ? _cardContent(pageItems) : _tableContent(pageItems),
              const SizedBox(height: 16),
              _statsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topControls() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFC8CCE0)), color: const Color(0xFFF7F8FD)),
          child: Row(
            children: [
              _viewButton(icon: Icons.grid_view_rounded, active: _cardView, onTap: () => setState(() => _cardView = true)),
              _viewButton(icon: Icons.view_list_rounded, active: !_cardView, onTap: () => setState(() => _cardView = false)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _statusDropdown()),
      ],
    );
  }

  Widget _viewButton({required IconData icon, required bool active, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: active ? const [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4))] : null),
        child: Icon(icon, size: 17, color: active ? AppColors.primary : AppColors.textSecondary),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFC8CCE0)), borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search by Passport No...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: AppColors.textSecondary),
          hintStyle: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFC8CCE0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFC8CCE0))),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFC8CCE0))),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF2F3FB)),
              columns: const [
                DataColumn(label: Text('PAYMENT INVOICE\n(#ID)', style: TextStyle(fontSize: 12))),
                DataColumn(label: Text('BOOKING\nID', style: TextStyle(fontSize: 12))),
                DataColumn(label: Text('POST\nID', style: TextStyle(fontSize: 12))),
                DataColumn(label: Text('PAYMENT\nDATE', style: TextStyle(fontSize: 12))),
                DataColumn(label: Text('PASSPORT\nNO', style: TextStyle(fontSize: 12))),
                DataColumn(label: Text('AMOUNT', style: TextStyle(fontSize: 12))),
                DataColumn(label: Text('STATUS', style: TextStyle(fontSize: 12))),
              ],
              rows: items.map((item) => DataRow(cells: [
                DataCell(Text('#INV-${item.id}', style: const TextStyle(fontWeight: FontWeight.w700))),
                DataCell(Text(item.bookingId)),
                DataCell(Text(item.postId)),
                DataCell(Text(_formatListDate(item.collectedAt))),
                DataCell(Text(item.passportNo)),
                DataCell(Text(_formatAmount(item.amount), style: const TextStyle(fontWeight: FontWeight.w700))),
                DataCell(_statusChip(item.step)),
              ])).toList(),
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
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 1.35, mainAxisSpacing: 12),
          itemBuilder: (context, index) => _paymentCard(items[index]),
        ),
        const SizedBox(height: 12),
        _pagination(items.length),
      ],
    );
  }

  Widget _paymentCard(PaymentHistoryItem item) {
    final isReturn = item.step == 'RETURN';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFC8CCE0))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('INVOICE ID', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text('#${item.id}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
          ]),
          _statusChip(item.step),
        ]),
        const SizedBox(height: 10),
        Text('Booking: ${item.bookingId}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text('Post ID: ${item.postId}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text('Passport: ${item.passportNo}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Divider(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('DATE', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text(_formatDateTime(item.collectedAt), style: const TextStyle(fontSize: 12)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('AMOUNT', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text(_formatAmount(item.amount), style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: isReturn ? const Color(0xFFC11212) : AppColors.primary)),
          ]),
        ]),
      ]),
    );
  }

  Widget _statsSection() => Column(children: [
    Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('TOTAL PROCESSED', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)), SizedBox(height: 6), Text('৳ 4,120,500', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w800))])),
    const SizedBox(height: 12),
    Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFC8CCE0))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PENDING CLAIMS', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 8), const Text('12', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700)), const SizedBox(height: 12), ClipRRect(borderRadius: BorderRadius.circular(999), child: const LinearProgressIndicator(value: 0.40, minHeight: 5, color: AppColors.primary, backgroundColor: Color(0xFFE7EAF3)))])),
  ]);

  Widget _pagination(int countOnPage) {
    final filteredCount = _allPayments.where((i) => (_status.isEmpty || i.step == _status) && (_debouncedSearch.isEmpty || i.passportNo.toLowerCase().contains(_debouncedSearch.toLowerCase()))).length;
    final totalPages = (filteredCount / _pageSize).ceil().clamp(1, 999);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Showing ${countOnPage == 0 ? 0 : ((_currentPage - 1) * _pageSize) + 1} to ${((_currentPage - 1) * _pageSize) + countOnPage} of $filteredCount entries', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Row(children: [
          IconButton(onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null, icon: const Icon(Icons.chevron_left_rounded)),
          Text('Page $_currentPage of $totalPages', style: const TextStyle(fontSize: 13)),
          IconButton(onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null, icon: const Icon(Icons.chevron_right_rounded)),
        ]),
      ]),
    );
  }

  Widget _statusChip(String status) {
    final isReturn = status == 'RETURN';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isReturn ? const Color(0xFFF8D8D7) : const Color(0xFFD8F3DE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isReturn ? const Color(0xFFB3261E) : const Color(0xFF1C7A3B))),
    );
  }

  String _formatDateTime(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$m-$d $h:$min';
  }

  String _formatListDate(DateTime date) {
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${monthNames[date.month - 1]}, ${date.year}';
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final chars = str.split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < chars.length; i += 3) {
      chunks.add(chars.sublist(i, (i + 3).clamp(0, chars.length)).join());
    }
    return '৳ ${chunks.join(',').split('').reversed.join()}';
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
