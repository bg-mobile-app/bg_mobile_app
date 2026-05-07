import 'package:flutter/material.dart';

import '../home/models/home_models.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/filter_results.dart';
import 'widgets/filter_sidebar.dart';

class WorkPermitListScreen extends StatefulWidget {
  const WorkPermitListScreen({super.key});

  @override
  State<WorkPermitListScreen> createState() => _WorkPermitListScreenState();
}

class _WorkPermitListScreenState extends State<WorkPermitListScreen> {
  static const Color _ink = Color(0xFF1F2937);
  static const Color _mutedBlue = Color(0xFF4B5563);
  static const Color _surfaceTint = Color(0x0D111827);
  final _searchController = TextEditingController();

  final List<WorkPermitItem> _allItems = [
    // existing demo data
    WorkPermitItem(title: 'Factory Worker Visa - Malaysia', slug: 'factory-worker-malaysia', image: 'assets/img/work-permit/1.jpg', customerPrice: 420000, agentPrice: 390000, countryName: 'Malaysia', countryFlag: 'assets/img/customer/appointment/world.png', workType: 'Factory', selectionType: 'DIRECT', createdAt: DateTime.now().subtract(const Duration(hours: 10))),
    WorkPermitItem(title: 'Construction Helper - Romania', slug: 'construction-helper-romania', image: 'assets/img/work-permit/1.jpg', customerPrice: 560000, agentPrice: 520000, countryName: 'Romania', countryFlag: 'assets/img/customer/appointment/world.png', workType: 'Construction', selectionType: 'LOTTERY', createdAt: DateTime.now().subtract(const Duration(days: 1))),
    WorkPermitItem(title: 'Hotel Staff - Japan', slug: 'hotel-staff-japan', image: 'assets/img/work-permit/1.jpg', customerPrice: 680000, agentPrice: 640000, countryName: 'Japan', countryFlag: 'assets/img/customer/appointment/world.png', workType: 'Hospitality', selectionType: 'DIRECT', createdAt: DateTime.now().subtract(const Duration(days: 2))),
    WorkPermitItem(title: 'Agriculture Worker - Poland', slug: 'agriculture-worker-poland', image: 'assets/img/work-permit/1.jpg', customerPrice: 470000, agentPrice: 435000, countryName: 'Poland', countryFlag: 'assets/img/customer/appointment/world.png', workType: 'Agriculture', selectionType: 'DELEGATE', createdAt: DateTime.now().subtract(const Duration(days: 4))),
  ];

  List<WorkPermitItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.of(_allItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters(FilterValue value) {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final queryOk = value.query.isEmpty || item.title.toLowerCase().contains(value.query.toLowerCase());
        final countryOk = value.country == null || item.countryName == value.country;
        final workTypeOk = value.workType == null || item.workType == value.workType;
        final selectionOk = value.selectionType == null || item.selectionType == value.selectionType;
        return queryOk && countryOk && workTypeOk && selectionOk;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(title: const Text('Work Permit Search')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Discover Work Permits', style: theme.textTheme.displayMedium?.copyWith(letterSpacing: -0.5, color: _ink, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Find the right destination and opportunity with curated listings.', style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, color: const Color(0xFF6B7280))),
              const SizedBox(height: 24),
              _searchBar(theme),
              const SizedBox(height: 24),
              _buildServices(theme),
              const SizedBox(height: 32),
              SizedBox(
                height: isDesktop ? 920 : 860,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop) ...[
                      SizedBox(width: 320, child: FilterSidebar(onApply: _applyFilters)),
                      const SizedBox(width: 24),
                    ],
                    Expanded(child: FilterResults(items: _filteredItems, brandBlue: _mutedBlue)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isDesktop ? null : FilterBottomSheet(onApply: _applyFilters),
    );
  }

  Widget _searchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Row(children: [
        const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _searchController,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, color: _ink),
            decoration: const InputDecoration(hintText: 'Search in bideshgami', border: InputBorder.none),
            onSubmitted: (query) => _applyFilters(FilterValue(query: query.trim().toLowerCase())),
          ),
        ),
      ]),
    );
  }

  Widget _buildServices(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDFE3E8), width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Build Service', style: theme.textTheme.titleLarge?.copyWith(color: _ink, letterSpacing: -0.2)),
        const SizedBox(height: 24),
        GridView.builder(
          itemCount: navLinkData.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: .82),
          itemBuilder: (context, index) {
            final item = navLinkData[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _surfaceTint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD1D5DB), width: 0.5),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 46, height: 46, decoration: const BoxDecoration(color: Color(0xFF374151), shape: BoxShape.circle), child: Icon(item.icon, color: Colors.white, size: 24)),
                const SizedBox(height: 12),
                Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(height: 1.5, color: _ink, fontWeight: FontWeight.w600)),
              ]),
            );
          },
        ),
      ]),
    );
  }
}
