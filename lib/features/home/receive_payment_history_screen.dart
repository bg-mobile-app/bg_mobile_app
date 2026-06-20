import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../common/theme/app_palette.dart';
import '../../common/theme/app_text_styles.dart';
import '../../common/widgets/app_search_bar.dart';
import '../../common/widgets/styled_data_table_card.dart';
import '../../common/widgets/view_toggle_button.dart';
import 'dashboard_screen.dart';
import 'services/payment_history_service.dart';

const List<String> paymentHistoryStatuses = [
  'DRAFT',
  'PAID',
  'CONFIRMED',
  'CANCELLED',
];

class ReceivePaymentHistoryScreen extends StatefulWidget {
  const ReceivePaymentHistoryScreen({
    super.key,
    required this.currentHref,
  });

  final String currentHref;

  @override
  State<ReceivePaymentHistoryScreen> createState() => _ReceivePaymentHistoryScreenState();
}

class _ReceivePaymentHistoryScreenState extends State<ReceivePaymentHistoryScreen> {
  final _searchController = TextEditingController();
  final _service = PaymentHistoryService();
  Timer? _debounce;

  bool _cardView = true;
  bool _loading = true;
  String _search = '';
  String _status = '';
  List<PaymentHistoryItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChange);
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final next = _searchController.text.trim();
      if (_search != next) {
        setState(() => _search = next);
        _load();
      }
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final page = await _service.getHistory(
        status: _status,
        search: _search,
        page: 1,
      );
      if (!mounted) return;
      setState(() => _items = page.results);
    } catch (_) {
      if (!mounted) return;
      setState(() => _items = const []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatPaymentDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '-';

    final isoMatch = RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(trimmed);
    if (isoMatch != null) {
      try {
        final date = DateTime.parse(trimmed);
        return _formatDateOnly(date.toLocal());
      } catch (_) {
        try {
          final date = DateTime.parse(isoMatch.group(0)!);
          return _formatDateOnly(date);
        } catch (_) {
          return isoMatch.group(0)!;
        }
      }
    }

    final readableMatch = RegExp(r'[A-Za-z]+ \d{1,2}, \d{4}').firstMatch(trimmed);
    if (readableMatch != null) return readableMatch.group(0)!;

    return trimmed.split(' ').first;
  }

  String _formatDateOnly(DateTime date) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: widget.currentHref,
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _breadcrumb(),
                const SizedBox(height: 10),
                Text(
                  'Receive Payment',
                  style: AppTextStyles.headline2.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ViewToggleButton(
                      isCardView: _cardView,
                      onChanged: (v) => setState(() => _cardView = v),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _statusFilter()),
                  ],
                ),
                const SizedBox(height: 12),
                AppSearchBar(
                  controller: _searchController,
                  hintText: 'Search by passport...',
                ),
                const SizedBox(height: 16),
                Skeletonizer(
                  enabled: _loading,
                  child: _cardView ? _cardViewList() : _tableView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumb() => BreadCrumb(
    items: [
      BreadCrumbItem(
        content: Text(
          'Dashboard',
          style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted),
        ),
      ),
      BreadCrumbItem(
        content: Text(
          'Receive Payment',
          style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted),
        ),
      ),
      BreadCrumbItem(
        content: Text(
          'Receive Payment',
          style: AppTextStyles.caption.copyWith(
            color: AppPalette.textStrongBlue,
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

  Widget _statusFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _status.isEmpty ? null : _status,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Status')),
        ...paymentHistoryStatuses.map(
          (s) => DropdownMenuItem(value: s, child: Text(s)),
        ),
      ],
      onChanged: (value) {
        setState(() => _status = value ?? '');
        _load();
      },
    );
  }

  Widget _tableView() {
    if (_items.isEmpty && !_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No payment history found'),
        ),
      );
    }
    return StyledDataTableCard(
      columns: const [
        DataColumn(label: Text('Payment Invoice')),
        DataColumn(label: Text('Payment Date')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Action')),
      ],
      rows: _items
          .map(
            (e) => DataRow(
              cells: [
                DataCell(Text('${e.id}')),
                DataCell(Text(_formatPaymentDate(e.paidAt))),
                DataCell(Text('৳ ${e.totalAmount}')),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: e.status.toUpperCase() == 'CANCELLED' ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        e.status,
                        style: TextStyle(
                          color: e.status.toUpperCase() == 'CANCELLED' ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  TextButton(
                    onPressed: () => context.go('/dashboard/receive-payment/view/${e.id}'),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _cardViewList() {
    if (_items.isEmpty && !_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No payment history found'),
        ),
      );
    }
    return Column(children: _items.map((e) => _card(e)).toList());
  }

  Widget _card(PaymentHistoryItem e) {
    final status = e.status.toUpperCase();
    final bool isCancelled = status == 'CANCELLED';
    final badgeColor = isCancelled ? const Color(0xFFFEE2E2) : const Color(0xFFECFDF5);
    final badgeTextColor = isCancelled ? const Color(0xFF991B1B) : const Color(0xFF065F46);
    final badgeIcon = isCancelled ? Icons.cancel : Icons.check_circle;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.cardShadow,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppPalette.borderSoftBlue.withValues(alpha: 0.35)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice Number',
                        style: AppTextStyles.caption.copyWith(
                          color: AppPalette.textMuted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '#${e.id}',
                        style: AppTextStyles.headline2.copyWith(
                          color: AppPalette.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 16, color: badgeTextColor),
                      const SizedBox(width: 6),
                      Text(
                        e.status.isNotEmpty ? e.status : 'PENDING',
                        style: AppTextStyles.caption.copyWith(
                          color: badgeTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppPalette.pageBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Amount Paid',
                        style: AppTextStyles.caption.copyWith(
                          color: AppPalette.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '৳',
                            style: AppTextStyles.headline2.copyWith(
                              color: AppPalette.brandBlue.withValues(alpha: 0.75),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            e.totalAmount,
                            style: AppTextStyles.headline2.copyWith(
                              color: AppPalette.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppPalette.pageBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppPalette.brandBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: AppPalette.brandBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Date',
                            style: AppTextStyles.caption.copyWith(
                              color: AppPalette.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatPaymentDate(e.paidAt),
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppPalette.textPrimary,
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
          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/dashboard/receive-payment/view/${e.id}'),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.brandBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
