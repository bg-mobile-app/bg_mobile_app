import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../common/services/api_client.dart';
import '../../common/theme/app_palette.dart';
import '../../common/widgets/styled_data_table_card.dart';
import '../../common/widgets/view_toggle_button.dart';
import '../home/dashboard_screen.dart';

enum ReminderExpiryType { medical, police, visa }

class MedicalExpiryScreen extends StatelessWidget {
  const MedicalExpiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReminderExpiryScreen(type: ReminderExpiryType.medical);
  }
}

class PoliceClearanceExpiryScreen extends StatelessWidget {
  const PoliceClearanceExpiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReminderExpiryScreen(type: ReminderExpiryType.police);
  }
}

class VisaExpiryScreen extends StatelessWidget {
  const VisaExpiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReminderExpiryScreen(type: ReminderExpiryType.visa);
  }
}

class ReminderExpiryScreen extends StatefulWidget {
  const ReminderExpiryScreen({super.key, required this.type});

  final ReminderExpiryType type;

  @override
  State<ReminderExpiryScreen> createState() => _ReminderExpiryScreenState();
}

class _ReminderExpiryScreenState extends State<ReminderExpiryScreen> {
  final ReminderService _reminderService = ReminderService();
  bool _isCardView = false;
  String _selectedFilter = '3_Days';
  bool _loading = true;
  String? _error;
  List<ReminderBookingItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _reminderService.fetchReminderBookings(
        _statusValue,
        _selectedFilter,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load reminders. Please try again.';
        _loading = false;
      });
    }
  }

  String get _statusValue {
    switch (widget.type) {
      case ReminderExpiryType.medical:
        return 'Medical';
      case ReminderExpiryType.police:
        return 'Police';
      case ReminderExpiryType.visa:
        return 'Visa';
    }
  }

  String get _title {
    switch (widget.type) {
      case ReminderExpiryType.medical:
        return 'Medical Expiry Reminders';
      case ReminderExpiryType.police:
        return 'Police Clearance Expiry Reminders';
      case ReminderExpiryType.visa:
        return 'Visa Expiry Reminders';
    }
  }

  String get _crumbLabel {
    switch (widget.type) {
      case ReminderExpiryType.medical:
        return 'Medical Expiry';
      case ReminderExpiryType.police:
        return 'Police Clearance Expiry';
      case ReminderExpiryType.visa:
        return 'Visa Expiry';
    }
  }

  String get _currentHref {
    switch (widget.type) {
      case ReminderExpiryType.medical:
        return '/dashboard/reminder/medical-expiry';
      case ReminderExpiryType.police:
        return '/dashboard/reminder/police-clearance-expiry';
      case ReminderExpiryType.visa:
        return '/dashboard/reminder/visa-expiry';
    }
  }

  String _expiryLabel(ReminderBookingItem item) {
    switch (widget.type) {
      case ReminderExpiryType.medical:
        return item.medicalExpiryDate ?? '—';
      case ReminderExpiryType.police:
        return item.policeClearanceExpiryDate ?? '—';
      case ReminderExpiryType.visa:
        return item.visaExpiryDate ?? '—';
    }
  }

  String get _expiryColumnTitle {
    switch (widget.type) {
      case ReminderExpiryType.medical:
        return 'Medical Expiry';
      case ReminderExpiryType.police:
        return 'Police Expiry';
      case ReminderExpiryType.visa:
        return 'Visa Expiry';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: _currentHref,
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
                  _title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _viewToggle(),
                    const SizedBox(width: 10),
                    Expanded(child: _filterDropdown()),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null)
      return Center(
        child: Text(_error!, style: const TextStyle(color: AppPalette.danger)),
      );
    if (!_loading && _items.isEmpty)
      return const Center(child: Text('No reminders found.'));

    final data = _loading ? _skeletonItems : _items;
    return Skeletonizer(
      enabled: _loading,
      child: _isCardView ? _buildCardList(data) : _buildTableList(data),
    );
  }

  Widget _breadcrumb() => BreadCrumb(
    items: <BreadCrumbItem>[
      BreadCrumbItem(
        content: Text(
          'Dashboard',
          style: TextStyle(color: AppPalette.textMuted, fontSize: 12),
        ),
      ),
      BreadCrumbItem(
        content: Text(
          'Reminder List',
          style: TextStyle(color: AppPalette.textMuted, fontSize: 12),
        ),
      ),
      BreadCrumbItem(
        content: Text(
          _crumbLabel,
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

  Widget _viewToggle() => ViewToggleButton(
    isCardView: _isCardView,
    onChanged: (isCardView) => setState(() => _isCardView = isCardView),
  );

  Widget _filterDropdown() => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFD8E3FA)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedFilter,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppPalette.textMuted,
        ),
        items: const [
          DropdownMenuItem(value: '3_Days', child: Text('Expiring in: 3 days')),
          DropdownMenuItem(
            value: '10_Days',
            child: Text('Expiring in: 10 days'),
          ),
        ],
        onChanged: (val) {
          if (val == null) return;
          setState(() => _selectedFilter = val);
          _loadReminders();
        },
      ),
    ),
  );

  Widget _buildTableList(List<ReminderBookingItem> items) =>
      StyledDataTableCard(
        columns: [
          const DataColumn(label: Text('#')),
          const DataColumn(label: Text('Name')),
          const DataColumn(label: Text('Passport No')),
          const DataColumn(label: Text('From & To Country')),
          const DataColumn(label: Text('Branch')),
          const DataColumn(label: Text('Status')),
          DataColumn(label: Text(_expiryColumnTitle)),
        ],
        rows: items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return DataRow(
            cells: [
              DataCell(Text('$index')),
              DataCell(
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(Text(item.passportNo ?? '—')),
              DataCell(
                Text('${item.fromCountry ?? '—'} → ${item.toCountry ?? '—'}'),
              ),
              DataCell(Text(item.branch ?? '—')),
              DataCell(Text(item.statusLabel ?? item.status ?? '—')),
              DataCell(
                Text(
                  _expiryLabel(item),
                  style: const TextStyle(
                    color: AppPalette.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );

  Widget _buildCardList(List<ReminderBookingItem> items) => Column(
    children: items
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF6FAFF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppPalette.borderSoftBlue),
              boxShadow: AppPalette.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_pin_circle_rounded,
                          color: AppPalette.brandBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.brandBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.statusLabel ?? item.status ?? '—',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppPalette.brandBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _cardRow(
                  Icons.badge_rounded,
                  'Passport',
                  item.passportNo ?? '—',
                ),
                _cardRow(
                  Icons.route_rounded,
                  'Route',
                  '${item.fromCountry ?? '—'} → ${item.toCountry ?? '—'}',
                ),
                _cardRow(Icons.apartment_rounded, 'Branch', item.branch ?? '—'),
                _cardRow(
                  Icons.warning_amber_rounded,
                  _expiryColumnTitle,
                  _expiryLabel(item),
                  isAlert: true,
                ),
              ],
            ),
          ),
        )
        .toList(),
  );

  Widget _cardRow(
    IconData icon,
    String label,
    String value, {
    bool isAlert = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isAlert ? AppPalette.danger : AppPalette.textMuted,
        ),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isAlert ? AppPalette.danger : AppPalette.textPrimary,
              fontWeight: isAlert ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  List<ReminderBookingItem> get _skeletonItems => List.generate(
    6,
    (index) => ReminderBookingItem(
      name: 'Loading Name $index',
      passportNo: 'P000000$index',
      fromCountry: 'From Country',
      toCountry: 'To Country',
      branch: 'Branch',
      status: 'UNDER_PROCESSING',
      statusLabel: 'Under Processing',
      medicalExpiryDate: '2026-01-01',
      policeClearanceExpiryDate: '2026-01-01',
      visaExpiryDate: '2026-01-01',
    ),
  );
}

class ReminderService {
  ReminderService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<ReminderBookingItem>> fetchReminderBookings(
    String status,
    String? date,
  ) async {
    final response = await _apiClient.get(
      '/booking/wp/reminders/list/',
      queryParameters: {'status': status, if (date != null) 'date': date},
    );
    final data = response.data;
    final results =
        (data is Map<String, dynamic> ? data['results'] : null)
            as List<dynamic>? ??
        const [];
    return results
        .map(
          (e) =>
              ReminderBookingItem.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }
}

class ReminderBookingItem {
  const ReminderBookingItem({
    required this.name,
    this.passportNo,
    this.fromCountry,
    this.toCountry,
    this.branch,
    this.status,
    this.statusLabel,
    this.medicalExpiryDate,
    this.policeClearanceExpiryDate,
    this.visaExpiryDate,
  });

  factory ReminderBookingItem.fromJson(Map<String, dynamic> json) =>
      ReminderBookingItem(
        name: json['name']?.toString() ?? '—',
        passportNo: json['passportNo']?.toString(),
        fromCountry: json['fromCountry']?.toString(),
        toCountry: json['toCountry']?.toString(),
        branch: json['branch']?.toString(),
        status: json['status']?.toString(),
        statusLabel: json['statusLabel']?.toString(),
        medicalExpiryDate: json['medicalExpiryDate']?.toString(),
        policeClearanceExpiryDate: json['policeClearanceExpiryDate']
            ?.toString(),
        visaExpiryDate: json['visaExpiryDate']?.toString(),
      );

  final String name;
  final String? passportNo;
  final String? fromCountry;
  final String? toCountry;
  final String? branch;
  final String? status;
  final String? statusLabel;
  final String? medicalExpiryDate;
  final String? policeClearanceExpiryDate;
  final String? visaExpiryDate;
}
