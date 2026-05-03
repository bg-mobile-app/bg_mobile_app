import 'dart:async';

import 'package:flutter/material.dart';

class NavLinkItem {
  const NavLinkItem({
    required this.name,
    required this.href,
    required this.icon,
  });

  final String name;
  final String href;
  final IconData icon;
}

class WorkPermitItem {
  const WorkPermitItem({
    required this.title,
    required this.slug,
    required this.image,
    required this.customerPrice,
    required this.agentPrice,
    required this.countryName,
    required this.countryFlag,
    required this.workType,
    required this.selectionType,
    required this.createdAt,
  });

  final String title;
  final String slug;
  final String image;
  final int customerPrice;
  final int agentPrice;
  final String countryName;
  final String countryFlag;
  final String workType;
  final String selectionType;
  final DateTime createdAt;
}

const List<NavLinkItem> navLinkData = [
  NavLinkItem(name: 'Home', href: '/', icon: Icons.home),
  NavLinkItem(name: 'Flight Booking', href: '', icon: Icons.flight_takeoff),
  NavLinkItem(name: 'Work Abroad', href: '/filter?service_type=WORK_PERMIT', icon: Icons.handshake_outlined),
  NavLinkItem(name: 'Study Abroad', href: '', icon: Icons.school_outlined),
  NavLinkItem(name: 'Hajj & Umrah', href: '', icon: Icons.mosque_outlined),
  NavLinkItem(name: 'Visa Services', href: '', icon: Icons.volunteer_activism_outlined),
  NavLinkItem(name: 'Tour Packages', href: '', icon: Icons.public_outlined),
  NavLinkItem(name: 'Hotel Booking', href: '', icon: Icons.hotel_outlined),
];

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

  final List<String> _countries = const ['Bangladesh', 'Malaysia', 'Japan', 'Romania'];
  final List<String> _workTypes = const ['Factory', 'Construction', 'Hospitality', 'Agriculture'];
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
      selectionType: 'DIRECT',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _leftTimer = Timer.periodic(const Duration(milliseconds: 1300), (_) {
      if (!_leftController.hasClients) return;
      _leftIndex = (_leftIndex + 1) % _bannerLeft.length;
      _leftController.animateToPage(
        _leftIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });

    _rightTimer = Timer.periodic(const Duration(milliseconds: 1600), (_) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Working on this page')),
    );
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
              borderRadius: BorderRadius.circular(12),
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
                    onChanged: (v) => setState(() => _serviceType = v ?? 'WORK_PERMIT'),
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
                    onChanged: (v) => setState(() => _selectionType = v ?? 'All'),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Image.asset(
          'assets/img/logo/logo_black.png',
          height: 34,
          fit: BoxFit.contain,
        ),
        actions: [
          _headerButton(
            label: 'Sign In',
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
          const SizedBox(width: 8),
          _headerButton(
            label: 'Sign Up',
            onTap: () => Navigator.pushNamed(context, '/sign-up/customer'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchBox(),
              _buildServices(),
              _buildOfferBanner(),
              _buildWorkPermitSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return AspectRatio(
      aspectRatio: 5 / 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/hero.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: -100,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
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
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _brandBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.tune, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  hintText: 'search in bideshgami',
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  filled: false,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: _showComingSoon,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: _brandBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.search, size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServices() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 150),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: GridView.builder(
          itemCount: navLinkData.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            childAspectRatio: .85,
          ),
          itemBuilder: (context, index) {
            final item = navLinkData[index];
            return InkWell(
              onTap: item.href.isEmpty ? _showComingSoon : _showComingSoon,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: _brandBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOfferBanner() {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: isWide
            ? Row(
                children: [
                  Expanded(child: _carousel(_leftController, _bannerLeft)),
                  const SizedBox(width: 16),
                  Expanded(child: _carousel(_rightController, _bannerRight)),
                ],
              )
            : Column(
                children: [
                  _carousel(_leftController, _bannerLeft),
                  const SizedBox(height: 14),
                  _carousel(_rightController, _bannerRight),
                ],
              ),
      ),
    );
  }

  Widget _buildWorkPermitSection() {
    if (_workPermits.isEmpty) {
      return const SizedBox.shrink();
    }

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1024 ? 4 : (width >= 768 ? 3 : 2);
    final childAspectRatio = width >= 1024
        ? 0.66
        : (width >= 768 ? 0.62 : (width >= 420 ? 0.56 : 0.5));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Work Permit',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
              ElevatedButton(
                onPressed: _showComingSoon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('See More'),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_double_arrow_right, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _workPermits.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return _buildWorkPermitCard(_workPermits[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkPermitCard(WorkPermitItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(item.image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.selectionType.replaceAll('_', ' '),
                    style: const TextStyle(
                      color: _brandBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_formatBdt(item.customerPrice)} BDT',
                    style: const TextStyle(
                      color: _brandBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 14,
                        child: Image.asset(item.countryFlag, fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.countryName,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.construction, size: 12),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                item.workType,
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _timeAgo(item.createdAt),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: _showComingSoon,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_right_alt, color: _brandBlue),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: _brandBlue,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PageView.builder(
          controller: controller,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.asset(
              images[index],
              fit: BoxFit.cover,
            );
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
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xE2E8F0FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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

  Widget _headerButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
