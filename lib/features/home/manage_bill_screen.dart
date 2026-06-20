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
import 'services/bill_service.dart';

class ManageBillScreen extends StatefulWidget {
  const ManageBillScreen({super.key, required this.currentHref});

  final String currentHref;

  @override
  State<ManageBillScreen> createState() => _ManageBillScreenState();
}

class _ManageBillScreenState extends State<ManageBillScreen> {
  final _searchController = TextEditingController();
  final _service = BillService();
  Timer? _debounce;

  bool _cardView = false;
  bool _loading = true;
  String _search = '';
  int _currentPage = 1;
  int _totalPages = 1;
  List<BillItem> _items = const [];

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
        _currentPage = 1;
        _load();
      }
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final page = await _service.getBills(search: _search, page: _currentPage);
      if (!mounted) return;
      setState(() {
        _items = page.results;
        _totalPages = (page.count / (page.pageSize <= 0 ? 20 : page.pageSize)).ceil();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _items = const []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDateOnly(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '-';
    final iso = RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(trimmed);
    if (iso != null) return iso.group(0)!;
    final readable = RegExp(r'[A-Za-z]+ \d{1,2}, \d{4}').firstMatch(trimmed);
    if (readable != null) return readable.group(0)!;
    return trimmed.split(' ').first;
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
                Text('Manage Bill', style: AppTextStyles.headline2.copyWith(fontWeight: FontWeight.w800, fontSize: 24)),
                const SizedBox(height: 12),
                Row(children: [
                  ViewToggleButton(isCardView: _cardView, onChanged: (v) => setState(() => _cardView = v)),
                  const SizedBox(width: 12),
                  Expanded(child: AppSearchBar(controller: _searchController, hintText: 'Search by agency name...')),
                ]),
                const SizedBox(height: 16),
                Skeletonizer(enabled: _loading, child: _cardView ? _cardViewList() : _tableView()),
                const SizedBox(height: 12),
                _pagination(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumb() => BreadCrumb(
    items: [
      BreadCrumbItem(content: Text('Dashboard', style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted))),
      BreadCrumbItem(content: Text('Refund Payment', style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted))),
      BreadCrumbItem(content: Text('Manage Bill', style: AppTextStyles.caption.copyWith(color: AppPalette.textStrongBlue, fontWeight: FontWeight.w700))),
    ],
    divider: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
  );

  Widget _tableView() {
    if (_items.isEmpty && !_loading) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No bills found')));
    return StyledDataTableCard(
      columns: const [
        DataColumn(label: Text('Invoice Id')),
        DataColumn(label: Text('Agency Name')),
        DataColumn(label: Text('Bill Date')),
        DataColumn(label: Text('Total Amount')),
        DataColumn(label: Text('Total Requests')),
        DataColumn(label: Text('Payment Method')),
        DataColumn(label: Text('Paid By')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Actions')),
      ],
      rows: _items.map((e) => DataRow(cells: [
        DataCell(Text('#${e.id}')),
        DataCell(Text(e.agencyName)),
        DataCell(Text(_formatDateOnly(e.paidAt))),
        DataCell(Text('৳ ${e.totalAmount}')),
        DataCell(Text('${e.totalRequests}')),
        DataCell(Text(e.paymentMethod)),
        DataCell(Text(e.paidByName)),
        DataCell(_statusBadge(e.status)),
        DataCell(_actions(e)),
      ])).toList(),
    );
  }

  Widget _statusBadge(String status) {
    final s = status.toUpperCase();
    Color bg;
    Color text;
    if (s == 'PAID') {
      bg = AppPalette.success.withValues(alpha: 0.12);
      text = AppPalette.success;
    } else if (s == 'DRAFT') {
      bg = AppPalette.borderNeutral.withValues(alpha: 0.06);
      text = AppPalette.textMuted;
    } else {
      bg = AppPalette.brandBlue.withValues(alpha: 0.12);
      text = AppPalette.brandBlue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status.isNotEmpty ? status : '—', style: AppTextStyles.caption.copyWith(color: text, fontWeight: FontWeight.w700)),
    );
  }

  Widget _actions(BillItem item) {
    final s = item.status.toUpperCase();
    return Row(mainAxisSize: MainAxisSize.min, children: [
      TextButton(onPressed: () => context.go('/dashboard/refund-payment/manage-bill/view/${item.id}'), child: const Text('View')),
      const SizedBox(width: 6),
      TextButton(onPressed: () => context.go('/dashboard/refund-payment/manage-bill/edit/${item.id}'), child: const Text('Edit')),
      const SizedBox(width: 6),
      if (s != 'PAID') ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Send bill ${item.id}'))); }, child: const Text('Send')),
    ]);
  }

  Widget _cardViewList() {
    if (_items.isEmpty && !_loading) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No bills found')));
    return Column(children: _items.map((e) => _billCard(e)).toList());
  }

  Widget _billCard(BillItem e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppPalette.borderSoftBlue)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('#${e.id}', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w800)),
          _statusBadge(e.status),
        ]),
        const SizedBox(height: 8),
        Text(e.agencyName, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Bill Date: ${_formatDateOnly(e.paidAt)}', style: AppTextStyles.body2),
        const SizedBox(height: 8),
        Text('Total Amount: ৳ ${e.totalAmount}', style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: _actions(e)),
      ]),
    );
  }

  Widget _pagination() {
    if (_totalPages <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(onPressed: _currentPage > 1 ? () { setState(() => _currentPage--); _load(); } : null, icon: const Icon(Icons.chevron_left_rounded)),
        Text('Page $_currentPage of $_totalPages', style: const TextStyle(fontWeight: FontWeight.w600, color: AppPalette.textPrimary)),
        IconButton(onPressed: _currentPage < _totalPages ? () { setState(() => _currentPage++); _load(); } : null, icon: const Icon(Icons.chevron_right_rounded)),
      ]),
    );
  }
}
