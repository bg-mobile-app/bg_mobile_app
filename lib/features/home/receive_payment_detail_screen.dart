import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/theme/app_palette.dart';
import '../../common/theme/app_text_styles.dart';
import '../../common/widgets/styled_data_table_card.dart';
import 'dashboard_screen.dart';
import 'services/payment_history_service.dart';

class ReceivePaymentDetailScreen extends StatefulWidget {
  const ReceivePaymentDetailScreen({
    super.key,
    required this.billId,
    required this.currentHref,
  });

  final String billId;
  final String currentHref;

  @override
  State<ReceivePaymentDetailScreen> createState() => _ReceivePaymentDetailScreenState();
}

class _ReceivePaymentDetailScreenState extends State<ReceivePaymentDetailScreen> {
  final _service = PaymentHistoryService();
  bool _loading = true;
  bool _confirming = false;
  BillDetails? _bill;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final details = await _service.getBillDetails(widget.billId);
      if (!mounted) return;
      setState(() => _bill = details);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bill details: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmReceived() async {
    if (_bill == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Receipt'),
        content: const Text('Are you sure you have received this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _confirming = true);
    try {
      await _service.confirmBill(_bill!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment receipt confirmed successfully')),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm receipt: $e')),
      );
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Future<void> _openReceipt(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open receipt URL')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open receipt link')),
      );
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final min = dt.minute.toString().padLeft(2, '0');
      final meridiem = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day.toString().padLeft(2, '0')} ${monthNames[dt.month - 1]}, ${dt.year} $hour:$min $meridiem';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatStep(String step) {
    return step.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: widget.currentHref,
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: Skeletonizer(
            enabled: _loading || _confirming,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _breadcrumb(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bill Details',
                        style: AppTextStyles.headline2.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                      if (_bill?.status == 'PAID')
                        ElevatedButton.icon(
                          onPressed: _confirming ? null : _confirmReceived,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Confirm Received'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_bill != null) ...[
                    _billInfoCard(),
                    const SizedBox(height: 20),
                    Text(
                      'Payment Items',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _itemsTable(),
                    const SizedBox(height: 20),
                    _summarySection(),
                  ] else if (!_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('Bill details not found'),
                      ),
                    ),
                ],
              ),
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
          'View Detail',
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

  Widget _billInfoCard() {
    final b = _bill!;
    final isCancelled = b.status.toUpperCase() == 'CANCELLED';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bill #${b.id}',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppPalette.brandBlue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCancelled ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  b.status,
                  style: TextStyle(
                    color: isCancelled ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _infoRow('Created', _formatDate(b.createdAt)),
          _infoRow('Agency Name', b.agencyName),
          _infoRow('Payment Method', b.paymentMethod),
          _infoRow('Account Name', b.accountName),
          _infoRow('Account No', b.accountNo),
          _infoRow('Payment Reference', b.paymentReference),
          _infoRow('Paid By', b.paidByName),
          _infoRow('Paid At', _formatDate(b.paidAt)),
          _infoRow('Total Requests', '${b.totalRequests}'),
          if (b.receiptFile.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Receipt',
                  style: AppTextStyles.body2.copyWith(color: AppPalette.textMuted),
                ),
                TextButton.icon(
                  onPressed: () => _openReceipt(b.receiptFile),
                  icon: const Icon(Icons.download_outlined, size: 16),
                  label: const Text('View Receipt'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppPalette.brandBlue,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppPalette.textMuted),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              textAlign: TextAlign.end,
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: AppPalette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemsTable() {
    final items = _bill?.items ?? [];
    if (items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(child: Text('No payment items found')),
        ),
      );
    }

    return StyledDataTableCard(
      columns: const [
        DataColumn(label: Text('#')),
        DataColumn(label: Text('Customer Name')),
        DataColumn(label: Text('Passport No')),
        DataColumn(label: Text('Step')),
        DataColumn(label: Text('Request Type')),
        DataColumn(label: Text('Amount')),
      ],
      rows: items.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final item = entry.value;
        return DataRow(
          cells: [
            DataCell(Text('$idx')),
            DataCell(Text(item.customerName)),
            DataCell(Text(item.passportNo)),
            DataCell(Text(_formatStep(item.step))),
            DataCell(Text(item.requestType)),
            DataCell(Text('৳ ${item.amount}')),
          ],
        );
      }).toList(),
    );
  }

  Widget _summarySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.borderSoftBlue),
        boxShadow: AppPalette.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Bill Amount',
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '৳ ${_bill?.totalAmount ?? '0'}',
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.w800,
              color: AppPalette.brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}
