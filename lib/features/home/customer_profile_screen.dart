import 'package:flutter/material.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileHeader(),
              SizedBox(height: 16),
              _SectionTitle(
                title: 'Personal Details',
                subtitle: 'As mentioned on your passport or government approved IDs',
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Basic Info',
                items: [
                  _InfoItem(label: 'Name', value: 'Demo User'),
                  _InfoItem(label: 'Date of Birth', value: '1990-01-01'),
                  _InfoItem(label: 'Gender', value: 'Male'),
                ],
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Contact Info',
                items: [
                  _InfoItem(label: 'Email Address', value: 'demo.user@example.com'),
                  _InfoItem(label: 'Phone Number', value: '+1 555 0102'),
                  _InfoItem(label: 'Address', value: 'Dhaka, Bangladesh'),
                  _InfoItem(label: 'Police Station', value: 'Dhanmondi'),
                  _InfoItem(label: 'District', value: 'Dhaka'),
                ],
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Passport Info',
                items: [
                  _InfoItem(label: 'Passport Number', value: 'A12345678'),
                  _InfoItem(label: 'Passport Expire Date', value: '2030-02-28'),
                  _InfoItem(label: 'Passport Issue Date', value: '2020-03-01'),
                ],
              ),
              SizedBox(height: 12),
              _InfoGroup(
                title: 'Personalized Info',
                items: [
                  _InfoItem(label: 'Liked Services', value: 'Work permit, Student visa'),
                  _InfoItem(label: 'Liked Countries', value: 'Japan, Malaysia'),
                  _InfoItem(label: 'Liked Job Type', value: 'Factory, Hospitality'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/img/logo/logo_black.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Demo User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('demo.user@example.com', style: TextStyle(color: Color(0xFF475569))),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
      ],
    );
  }
}

class _InfoGroup extends StatelessWidget {
  const _InfoGroup({required this.title, required this.items});

  final String title;
  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
