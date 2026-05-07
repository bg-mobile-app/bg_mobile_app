import 'package:flutter/material.dart';

import '../home/models/home_models.dart';
import '../home/widgets/work_permit_card.dart';
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

  final List<WorkPermitItem> _allItems = [
    WorkPermitItem(
      title: 'Factory Worker Visa - Malaysia',
      slug: 'factory-worker-malaysia',
      image: 'assets/img/work-permit/1.jpg',
      customerPrice: 420000,
      agentPrice: 390000,
      countryName: 'Malaysia',
      countryFlag: 'assets/img/customer/appointment/world.png',
      workType: 'Factory',
      selectionType: 'DIRECT',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    WorkPermitItem(
      title: 'Construction Helper - Romania',
      slug: 'construction-helper-romania',
      image: 'assets/img/work-permit/1.jpg',
      customerPrice: 560000,
      agentPrice: 520000,
      countryName: 'Romania',
      countryFlag: 'assets/img/customer/appointment/world.png',
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
      countryFlag: 'assets/img/customer/appointment/world.png',
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: const Text('Work Permit Search')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              SizedBox(
                width: 320,
                child: FilterSidebar(onApply: _applyFilters),
              ),
              const SizedBox(width: 24),
            ],
            Expanded(
              child: FilterResults(items: _filteredItems, brandBlue: _brandBlue),
            ),
          ],
        ),
      ),
      floatingActionButton: isDesktop
          ? null
          : FilterBottomSheet(
              onApply: _applyFilters,
            ),
    );
  }
}
