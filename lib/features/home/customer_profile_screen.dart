import 'package:flutter/material.dart';

import 'customer_profile_edit_screen.dart';
import 'dashboard_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/customer/profile',
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TopBar(),
              SizedBox(height: 18),
              _ProfileHeaderCard(),
              SizedBox(height: 24),
              _SectionTitle(
                title: 'Personal Details',
                subtitle: 'As mentioned on your passport or government approved IDs',
              ),
              SizedBox(height: 14),
              _BasicInfoCard(),
              SizedBox(height: 14),
              _ContactInfoCard(),
              SizedBox(height: 14),
              _PassportInfoCard(),
              SizedBox(height: 14),
              _PersonalizedInfoCard(),
              SizedBox(height: 22),
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.arrow_back, color: Color(0xFF0B1E6D)),
        SizedBox(width: 8),
        Text(
          'Candidate Profile',
          style: TextStyle(
            fontSize: 30 / 1.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0B1E6D),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 52,
                backgroundImage: AssetImage('assets/img/sign-in/login.jpg'),
              ),
              Positioned(
                right: 2,
                bottom: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1E6D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.verified, color: Colors.white, size: 14),
                ),
              ),
              Positioned(
                right: -12,
                bottom: -2,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 5)],
                  ),
                  child: const Icon(Icons.download_outlined, size: 18, color: Color(0xFF0B1E6D)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Demo User', style: TextStyle(fontSize: 39 / 1.5, fontWeight: FontWeight.w600, color: Color(0xFF0B1E6D))),
          const SizedBox(height: 4),
          const Text('demo.user@example.com', style: TextStyle(color: Color(0xFF334155), fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: const [
              _Pill(label: 'Verified Candidate', bg: Color(0xFFDDE8FF), fg: Color(0xFF1E3A8A)),
              _Pill(label: 'Active Now', bg: Color(0xFFE5E7EB), fg: Color(0xFF4B5563)),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CustomerProfileEditScreen()));
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0B1E6D),
              foregroundColor: Colors.white,
              minimumSize: const Size(170, 46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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
        Text(title, style: const TextStyle(fontSize: 35 / 1.5, fontWeight: FontWeight.w600, color: Color(0xFF0B1E6D))),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(fontSize: 16, color: Color(0xFF52525B), height: 1.35)),
      ],
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  const _BasicInfoCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.person_outline,
      title: 'Basic Info',
      rows: const [
        _InfoRow(label: 'FULL NAME', value: 'Demo User'),
        _InfoRow(label: 'DATE OF BIRTH', value: '1990-01-01'),
        _InfoRow(label: 'GENDER', value: 'Male', isLast: true),
      ],
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.contact_page_outlined,
      title: 'Contact Info',
      rows: const [
        _InfoRow(label: 'EMAIL', value: 'demo.user@example.com'),
        _InfoRow(label: 'PHONE', value: '+1 555 0102'),
        _InfoRow(label: 'ADDRESS', value: 'Dhaka, Bangladesh'),
        _InfoRow(label: 'POLICE STATION', value: 'Dhanmondi'),
        _InfoRow(label: 'DISTRICT', value: 'Dhaka', isLast: true),
      ],
    );
  }
}

class _PassportInfoCard extends StatelessWidget {
  const _PassportInfoCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.import_contacts_outlined,
      title: 'Passport Info',
      rows: const [
        _InfoRow(label: 'PASSPORT NUMBER', value: 'A12345678'),
        _InfoRow(label: 'ISSUE DATE', value: '2020-03-01'),
        _InfoRow(label: 'EXPIRE DATE', value: '2030-02-28', isLast: true),
      ],
    );
  }
}

class _PersonalizedInfoCard extends StatelessWidget {
  const _PersonalizedInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        _CardTitle(icon: Icons.accessibility_new_outlined, title: 'Personalized Info'),
        SizedBox(height: 16),
        _TagSection(
          label: 'LIKED SERVICES',
          tags: [
            _Pill(label: 'Work permit', bg: Color(0xFFDDE8FF), fg: Color(0xFF1E3A8A)),
            _Pill(label: 'Student visa', bg: Color(0xFFDDE8FF), fg: Color(0xFF1E3A8A)),
          ],
        ),
        SizedBox(height: 14),
        _TagSection(
          label: 'LIKED COUNTRIES',
          tags: [
            _Pill(label: '🌐 Japan', bg: Color(0xFFDBEAFE), fg: Color(0xFF1E3A8A)),
            _Pill(label: '🌐 Malaysia', bg: Color(0xFFDBEAFE), fg: Color(0xFF1E3A8A)),
          ],
        ),
        SizedBox(height: 14),
        _TagSection(
          label: 'LIKED JOB TYPE',
          tags: [
            _Pill(label: 'Factory', bg: Colors.white, fg: Color(0xFF374151), outlined: true),
            _Pill(label: 'Hospitality', bg: Colors.white, fg: Color(0xFF374151), outlined: true),
          ],
        ),
      ]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.rows});

  final IconData icon;
  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: icon, title: title),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0B1E6D)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 20 / 1.25, fontWeight: FontWeight.w600, color: Color(0xFF0B1E6D))),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isLast ? Colors.transparent : const Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF737373), letterSpacing: 0.7))),
          Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}

class _TagSection extends StatelessWidget {
  const _TagSection({required this.label, required this.tags});

  final String label;
  final List<Widget> tags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF737373), letterSpacing: 0.7)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: tags),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, required this.fg, this.outlined = false});

  final String label;
  final Color bg;
  final Color fg;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: outlined ? Border.all(color: const Color(0xFFD1D5DB)) : null,
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: fg)),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
        label: const Text(
          'Logout from Device',
          style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFFE5E7EB)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );
}
