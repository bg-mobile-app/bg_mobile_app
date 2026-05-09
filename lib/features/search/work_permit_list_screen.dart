import 'package:flutter/material.dart';

import '../home/models/home_models.dart';
import '../home/widgets/home_common_widgets.dart';
import '../home/widgets/work_permit_card.dart';
import 'work_permit_details_screen.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/filter_sidebar.dart';

class WorkPermitListScreen extends StatefulWidget {
  const WorkPermitListScreen({super.key});

  @override
  State<WorkPermitListScreen> createState() => _WorkPermitListScreenState();
}

class _WorkPermitListScreenState extends State<WorkPermitListScreen> {
  static const Color _brandBlue = Color(0xFF2563EB);
  final _searchController = TextEditingController();
  bool _isLoggedIn = false;

  final List<WorkPermitItem> _allItems = [
    WorkPermitItem(
      title: 'Factory Worker Visa - Malaysia',
      slug: 'factory-worker-malaysia',
      image: 'assets/img/work-permit/3.png',
      customerPrice: 420000,
      agentPrice: 390000,
      countryName: 'Malaysia',
      countryFlag: 'assets/img/customer/appointment/Malaysia.webp',
      workType: 'Factory',
      selectionType: 'DIRECT',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    WorkPermitItem(
      title: 'Construction Helper - Romania',
      slug: 'construction-helper-romania',
      image: 'assets/img/work-permit/2.png',
      customerPrice: 560000,
      agentPrice: 520000,
      countryName: 'Romania',
      countryFlag: 'assets/img/customer/appointment/Romania.png',
      workType: 'Construction',
      selectionType: 'LOTTERY',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    WorkPermitItem(
      title: 'Hotel Staff - Japan',
      slug: 'hotel-staff-japan',
      image: 'assets/img/work-permit/1.jpg',
      customerPrice: 680000,
      agentPrice: 640000,
      countryName: 'Japan',
      countryFlag: 'assets/img/customer/appointment/Japan.png',
      workType: 'Hospitality',
      selectionType: 'DIRECT',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    WorkPermitItem(
      title: 'Agriculture Worker - Poland',
      slug: 'agriculture-worker-poland',
      image: 'assets/img/work-permit/1.jpg',
      customerPrice: 470000,
      agentPrice: 435000,
      countryName: 'Poland',
      countryFlag: 'assets/img/customer/appointment/world.png',
      workType: 'Agriculture',
      selectionType: 'DELEGATE',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
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

  void _showComingSoon() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Working on this page')));
  }

  void _applyFilters(FilterValue value) {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final queryOk =
            value.query.isEmpty ||
            item.title.toLowerCase().contains(value.query.toLowerCase());
        final countryOk =
            value.country == null || item.countryName == value.country;
        final workTypeOk =
            value.workType == null || item.workType == value.workType;
        final selectionOk =
            value.selectionType == null ||
            item.selectionType == value.selectionType;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBrandHeader(
        brandBlue: _brandBlue,
        isLoggedIn: _isLoggedIn,
        onSignIn: () async {
          final result = await Navigator.pushNamed(context, '/login');
          if (result == true && mounted) setState(() => _isLoggedIn = true);
        },
        onSignUp: () => Navigator.pushNamed(context, '/sign-up/customer'),
        onNotifications: _showComingSoon,
        onProfile: _showComingSoon,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 16,
              vertical: 12,
            ),
            child: Column(
              children: [
                _searchBar(),
                const SizedBox(height: 20),
                _buildWorkPermitSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isDesktop
          ? null
          : FilterBottomSheet(onApply: _applyFilters),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDBEAFE)),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D2563EB),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: 'Search in bideshgami',
                hintStyle: TextStyle(color: Color(0xFF64748B)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (query) =>
                  _applyFilters(FilterValue(query: query.trim())),
            ),
          ),
          InkWell(
            onTap: _showComingSoon,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _brandBlue,
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

  Widget _buildWorkPermitSection() {
    if (_filteredItems.isEmpty)
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Text('No work permits found.'),
      );
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = 1;
    final childAspectRatio = width >= 768 ? 1.25 : 0.95;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Work Permit',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            TextButton.icon(
              onPressed: _showComingSoon,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('See More'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (width >= 1024) ...[
                  SizedBox(
                    width: 320,
                    child: FilterSidebar(onApply: _applyFilters),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) => WorkPermitCard(
                      item: _filteredItems[index],
                      brandBlue: _brandBlue,
                      onViewDetails: () =>
                          _openDetailsBySlug(_filteredItems[index]),
                      formatBdt: _formatBdt,
                      timeAgo: _timeAgo,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _formatBdt(int value) {
    final raw = value.toString();
    final chars = raw.split('').reversed.toList();
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write(',');
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join();
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
