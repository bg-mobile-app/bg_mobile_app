import 'dart:async';

import 'package:flutter/material.dart';

import 'models/home_models.dart';
import 'widgets/home_common_widgets.dart';
import 'widgets/work_permit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _brandBlue = Color(0xFF2563EB);

  final _searchController = TextEditingController();
  final _companyController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();

  String? _country;
  String? _workType;
  String _serviceType = 'WORK_PERMIT';
  String _selectionType = 'All';
  DateTime? _fromDate;
  DateTime? _toDate;

  final _leftController = PageController(viewportFraction: 1);
  final _rightController = PageController(viewportFraction: 1);
  Timer? _leftTimer;
  Timer? _rightTimer;
  int _leftIndex = 0;
  int _rightIndex = 0;

  bool _isLoggedIn = false;

  final List<String> _countries = const [
    'Bangladesh',
    'Malaysia',
    'Japan',
    'Romania',
  ];
  final List<String> _workTypes = const [
    'Factory',
    'Construction',
    'Hospitality',
    'Agriculture',
  ];
  final List<String> _bannerLeft = const [
    'assets/img/ads/1.png',
    'assets/img/ads/2.png',
    'assets/img/ads/3.png',
  ];
  final List<String> _bannerRight = const [
    'assets/img/ads/4.png',
    'assets/img/ads/create/ads_bn.png',
    'assets/img/ads/create/ads_en.png',
  ];
  final List<WorkPermitItem> _workPermits = [
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
      selectionType: 'DIRECT',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _leftTimer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (!_leftController.hasClients) return;
      _leftIndex = (_leftIndex + 1) % _bannerLeft.length;
      _leftController.animateToPage(
        _leftIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });

    _rightTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (!_rightController.hasClients) return;
      _rightIndex = (_rightIndex + 1) % _bannerRight.length;
      _rightController.animateToPage(
        _rightIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _companyController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    _leftTimer?.cancel();
    _rightTimer?.cancel();
    super.dispose();
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Working on this page')));
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 3),
      initialDate: now,
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = picked;
      } else {
        _toDate = picked;
      }
    });
  }

  Future<void> _showAdvancedFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dropdown(
                    value: _serviceType,
                    hint: 'Service Type',
                    items: const ['WORK_PERMIT'],
                    onChanged: (v) =>
                        setState(() => _serviceType = v ?? 'WORK_PERMIT'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _textField(_minAgeController, 'Min Age')),
                      const SizedBox(width: 8),
                      Expanded(child: _textField(_maxAgeController, 'Max Age')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _textField(_companyController, 'Company Name'),
                  const SizedBox(height: 10),
                  _dropdown(
                    value: _selectionType,
                    hint: 'Selection Type',
                    items: const ['All', 'Direct', 'Lottery'],
                    onChanged: (v) =>
                        setState(() => _selectionType = v ?? 'All'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _dateButton(
                          label: _fromDate == null
                              ? 'From Date'
                              : '${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}',
                          onTap: () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _dateButton(
                          label: _toDate == null
                              ? 'To Date'
                              : '${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}',
                          onTap: () => _pickDate(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showComingSoon();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBrandHeader(
        brandBlue: _brandBlue,
        isLoggedIn: _isLoggedIn,
        onSignIn: () async {
          final result = await Navigator.pushNamed(context, '/login');
          if (result == true && mounted) {
            setState(() => _isLoggedIn = true);
          }
        },
        onSignUp: () => Navigator.pushNamed(context, '/sign-up/customer'),
        onNotifications: _showComingSoon,
        onProfile: _showComingSoon,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeroSection()),
            SliverToBoxAdapter(child: _buildOfferBanner()),
            SliverToBoxAdapter(child: _buildServices()),
            SliverToBoxAdapter(child: _buildWorkPermitSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: _buildSearchFilters(),
    );
  }

  Widget _buildSearchFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _dropdown(
                value: _country,
                hint: 'Country Name',
                items: _countries,
                onChanged: (v) => setState(() => _country = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dropdown(
                value: _workType,
                hint: 'Type of Work',
                items: _workTypes,
                onChanged: (v) => setState(() => _workType = v),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _showAdvancedFilterSheet,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: _brandBlue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x332563EB),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF),
            border: Border.all(color: const Color(0xFFD6E3FF)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    fillColor: Color(0xFFEFF4FF),
                    hintText: 'Search in bideshgami',
                    hintStyle: TextStyle(color: Color(0xFF64748B)),
                    border: InputBorder.none,

                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              InkWell(
                onTap: _showComingSoon,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: _brandBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServices() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: navLinkData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: .78,
        ),
        itemBuilder: (context, index) {
          final item = navLinkData[index];
          return InkWell(
            onTap: item.href.isEmpty ? _showComingSoon : _showComingSoon,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 40),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        children: [
          _carousel(_leftController, _bannerLeft),
          const SizedBox(height: 10),
          _carousel(_rightController, _bannerRight),
        ],
      ),
    );
  }

  Widget _buildWorkPermitSection() {
    if (_workPermits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          _sectionHeader('Work Permit', actionLabel: 'See More'),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _workPermits.length,
            itemBuilder: (context, index) {
              return WorkPermitCard(
                item: _workPermits[index],
                brandBlue: _brandBlue,
                onViewDetails: _showComingSoon,
                formatBdt: _formatBdt,
                timeAgo: _timeAgo,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 14),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {required String actionLabel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        TextButton.icon(
          onPressed: _showComingSoon,
          style: TextButton.styleFrom(
            foregroundColor: _brandBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text(actionLabel),
        ),
      ],
    );
  }

  String _formatBdt(int value) {
    final raw = value.toString();
    final chars = raw.split('').reversed.toList();
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join();
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${(diff.inDays / 7).floor()}w ago';
  }

  Widget _carousel(PageController controller, List<String> images) {
    return SizedBox(
      height: 124,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PageView.builder(
          controller: controller,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.asset(images[index], fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      isExpanded: true,
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.black87,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        filled: true,
        fillColor: const Color(0xFFEFF4FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E3FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E3FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _brandBlue),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  Widget _dateButton({required String label, required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}
