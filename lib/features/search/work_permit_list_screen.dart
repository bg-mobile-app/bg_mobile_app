import 'package:flutter/material.dart';

import '../home/models/home_models.dart';
import 'work_permit_details_screen.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/filter_results.dart';
import 'widgets/filter_sidebar.dart';

class WorkPermitListScreen extends StatefulWidget {
  const WorkPermitListScreen({super.key});

  @override
  State<WorkPermitListScreen> createState() => _WorkPermitListScreenState();
}

class _WorkPermitListScreenState extends State<WorkPermitListScreen> {
  static const Color _brandBlue = Color(0xFF2563EB);
  static const Color _ink = Color(0xFF111827);
  static const Color _surfaceTint = Color(0x0D2563EB);

  final _searchController = TextEditingController();

  final List<WorkPermitItem> _allItems = [
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


  void _openDetailsBySlug(WorkPermitItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WorkPermitDetailsScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Work Permit Search'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroSection(theme),
                const SizedBox(height: 20),
                _searchBar(theme),
                const SizedBox(height: 20),
                _buildServices(theme),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop) ...[
                      SizedBox(width: 320, child: FilterSidebar(onApply: _applyFilters)),
                      const SizedBox(width: 24),
                    ],
                    Expanded(
                      child: FilterResults(
                        items: _filteredItems,
                        brandBlue: _brandBlue,
                        onViewDetails: _openDetailsBySlug,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isDesktop ? null : FilterBottomSheet(onApply: _applyFilters),
    );
  }

  Widget _heroSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x292563EB), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Discover Work Permits', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Find the right destination and opportunity with curated listings.',
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFE0EAFF), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDCE3F3)),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 3;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDCE3F3)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Build Service', style: theme.textTheme.titleLarge?.copyWith(color: _ink, letterSpacing: -0.2, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            GridView.builder(
              itemCount: navLinkData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: constraints.maxWidth < 420 ? 0.92 : 1,
              ),
              itemBuilder: (context, index) {
                final item = navLinkData[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _surfaceTint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD6E2FF), width: 0.8),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(width: 46, height: 46, decoration: const BoxDecoration(color: _brandBlue, shape: BoxShape.circle), child: Icon(item.icon, color: Colors.white, size: 24)),
                    const SizedBox(height: 10),
                    Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(height: 1.4, color: _ink, fontWeight: FontWeight.w600)),
                  ]),
                );
              },
            ),
          ]),
        );
      },
    );
  }
}
