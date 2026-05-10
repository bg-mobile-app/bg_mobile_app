import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_palette.dart';
import 'customer_profile_edit_screen.dart';
import 'dashboard_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/customer/profile',
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Breadcrumb(),
                SizedBox(height: 8),
                _PageHeading(),
                SizedBox(height: 16),
                _ProfileHeaderCard(),
                SizedBox(height: 18),
                _SectionTitle(
                  title: 'Personal Details',
                  subtitle:
                      'As mentioned on your passport or government approved IDs',
                ),
                SizedBox(height: 12),
                _BasicInfoCard(),
                SizedBox(height: 12),
                _ContactInfoCard(),
                SizedBox(height: 12),
                _PassportInfoCard(),
                SizedBox(height: 12),
                _PersonalizedInfoCard(),
                SizedBox(height: 16),
                _LogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb();

  @override
  Widget build(BuildContext context) {
    return BreadCrumb(
      items: <BreadCrumbItem>[
        BreadCrumbItem(
          content: const Text(
            'Dashboard',
            style: TextStyle(color: AppPalette.textMuted, fontSize: 12),
          ),
        ),
        BreadCrumbItem(
          content: const Text(
            'My Profile',
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
  }
}

class _PageHeading extends StatelessWidget {
  const _PageHeading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Candidate Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        SizedBox(height: 4),
       
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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPalette.borderSoftBlue, width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/img/sign-in/login.jpg'),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppPalette.brandBlue,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.verified, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Demo User',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'demo.user@example.com',
            style: TextStyle(color: AppPalette.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Pill(
                label: 'Verified Candidate',
                bg: Color(0xFFE8F0FF),
                fg: Color(0xFF1E3A8A),
              ),
              _Pill(
                label: 'Active Now',
                bg: Color(0xFFEFF6FF),
                fg: AppPalette.textStrongBlue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 170,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CustomerProfileEditScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Profile'),
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.brandBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppPalette.textMuted,
            height: 1.35,
          ),
        ),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.accessibility_new_outlined,
            title: 'Personalized Info',
          ),
          SizedBox(height: 14),
          _TagSection(
            label: 'LIKED SERVICES',
            tags: [
              _Pill(label: 'Work permit', bg: Color(0xFFE8F0FF), fg: Color(0xFF1E3A8A)),
              _Pill(label: 'Student visa', bg: Color(0xFFE8F0FF), fg: Color(0xFF1E3A8A)),
            ],
          ),
          SizedBox(height: 12),
          _TagSection(
            label: 'LIKED COUNTRIES',
            tags: [
              _Pill(label: 'Japan', bg: Color(0xFFDBEAFE), fg: Color(0xFF1E3A8A)),
              _Pill(label: 'Malaysia', bg: Color(0xFFDBEAFE), fg: Color(0xFF1E3A8A)),
            ],
          ),
          SizedBox(height: 12),
          _TagSection(
            label: 'LIKED JOB TYPE',
            tags: [
              _Pill(label: 'Factory', bg: Colors.white, fg: AppPalette.textPrimary, outlined: true),
              _Pill(label: 'Hospitality', bg: Colors.white, fg: AppPalette.textPrimary, outlined: true),
            ],
          ),
        ],
      ),
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
          const SizedBox(height: 10),
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
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppPalette.brandBlue, size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimary,
          ),
        ),
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
          bottom: BorderSide(
            color: isLast ? Colors.transparent : AppPalette.borderNeutral,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppPalette.textMuted,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: AppPalette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppPalette.textMuted,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: tags),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.bg,
    required this.fg,
    this.outlined = false,
  });

  final String label;
  final Color bg;
  final Color fg;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: outlined ? Border.all(color: AppPalette.borderNeutral) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
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
        icon: const Icon(Icons.logout, color: AppPalette.danger),
        label: const Text(
          'Logout from Device',
          style: TextStyle(color: AppPalette.danger, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppPalette.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppPalette.borderSoftBlue),
    boxShadow: AppPalette.cardShadow,
  );
}
