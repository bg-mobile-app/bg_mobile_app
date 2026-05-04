import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color _brandBlue = Color(0xFF2563EB);

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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black87),
            tooltip: 'Sidebar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DASHBOARD OVERVIEW',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF94A3B8)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'This Month',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: const [
                  DashboardSmallCard(
                    label: 'Total Applied Job',
                    icon: Icons.menu_book,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Under Processing',
                    icon: Icons.hourglass_top,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Success Flight',
                    icon: Icons.flight_takeoff,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Reject Flight',
                    icon: Icons.flight_land,
                    value: '৳0',
                    red: true,
                  ),
                  DashboardSmallCard(
                    label: 'Return Passport',
                    icon: Icons.badge_outlined,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Total Appointment',
                    icon: Icons.event_note,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Total Amount',
                    icon: Icons.payments_outlined,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Paid Amount',
                    icon: Icons.account_balance_wallet_outlined,
                    value: '৳0',
                  ),
                  DashboardSmallCard(
                    label: 'Due Amount',
                    icon: Icons.money_off_csred_outlined,
                    value: '৳0',
                    red: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardSmallCard extends StatelessWidget {
  const DashboardSmallCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.red = false,
  });

  final String label;
  final IconData icon;
  final String value;
  final bool red;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Icon(
                  icon,
                  color: red ? Colors.orange : Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
