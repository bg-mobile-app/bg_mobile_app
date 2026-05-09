import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

const List<String> bookingStatus = [
  'ADVANCE',
  'AFTER_VISA',
  'BEFORE_FLIGHT',
  'RETURN',
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

  final List<PaymentHistoryItem> _allPayments = List.generate(36, (index) {
    final step = bookingStatus[index % bookingStatus.length];
    return PaymentHistoryItem(
      id: '${1000 + index}',
      bookingId: 'BK-${2000 + index}',
      postId: 'POST-${3000 + index}',
      collectedAt: DateTime(2026, 1 + (index % 4), 1 + (index % 27), 10, 20),
      passportNo: index.isEven ? 'A12345678' : 'B98765432',
      amount: 50000 + (index * 1200),
      step: step,
    );
  });

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
    _debounce = Timer(const Duration(milliseconds: 400), () {
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    const TextSpan(text: 'Payments '),
                    TextSpan(text: 'History(${filtered.length})', style: const TextStyle(color: Color(0xFF2563EB))),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text('See history of your payment plan invoice', style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 14),
              LayoutBuilder(builder: (context, c) {
                final narrow = c.maxWidth < 720;
                final search = _searchBox();
                final status = _statusDropdown();
                if (narrow) {
                  return Column(children: [search, const SizedBox(height: 10), status]);
                }
                return Row(children: [Expanded(child: search), const SizedBox(width: 12), SizedBox(width: 240, child: status)]);
              }),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(const Color(0x1A2563EB)),
                  columns: const [
                    DataColumn(label: Text('Payment Invoice')),
                    DataColumn(label: Text('Booking ID')),
                    DataColumn(label: Text('Post ID')),
                    DataColumn(label: Text('Payment Date')),
                    DataColumn(label: Text('Passport No')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: pageItems
                      .map((item) => DataRow(cells: [
                            DataCell(Text('#${item.id}')),
                            DataCell(Text(item.bookingId)),
                            DataCell(Text(item.postId)),
                            DataCell(Text(_formatDateTime(item.collectedAt))),
                            DataCell(Text(item.passportNo)),
                            DataCell(Text('৳ ${item.amount}')),
                            DataCell(Row(children: [
                              Icon(Icons.circle, size: 10, color: item.step == 'RETURN' ? Colors.red : Colors.green),
                              const SizedBox(width: 6),
                              Text(item.step.replaceAll('_', ' ')),
                            ])),
                          ]))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('Page $_currentPage of $totalPages'),
                  IconButton(
                    onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF94A3B8), width: 2), borderRadius: BorderRadius.circular(6)),
      child: Row(children: [Expanded(child: TextField(controller: _searchController, decoration: const InputDecoration(hintText: 'Search by Passport No', border: InputBorder.none))), const Icon(Icons.search, color: Color(0xFF64748B))]),
    );
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _status,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Payments')),
        ...bookingStatus.map((e) => DropdownMenuItem(value: e, child: Text(e.replaceAll('_', ' ')))),
      ],
      onChanged: (value) => setState(() {
        _status = value ?? '';
        _currentPage = 1;
      }),
    );
  }

  String _formatDateTime(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$m-$d $h:$min';
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
