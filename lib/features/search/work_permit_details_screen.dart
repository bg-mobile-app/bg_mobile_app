import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home/models/home_models.dart';

class WorkPermitDetailsScreen extends StatelessWidget {
  const WorkPermitDetailsScreen({super.key, required this.item});

  final WorkPermitItem item;

  static const Color _brandBlue = Color(0xFF2563EB);
  static const Color _primary = Color(0xFF004AC6);
  static const Color _background = Color(0xFFF8F9FF);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _surfaceLow = Color(0xFFEFF4FF);
  static const Color _surfaceHigh = Color(0xFFDCE9FF);
  static const Color _outline = Color(0xFFC3C6D7);
  static const Color _text = Color(0xFF0B1C30);
  static const Color _mutedText = Color(0xFF434655);
  static const Color _error = Color(0xFFBA1A1A);
  static const Color _errorContainer = Color(0xFFFFDAD6);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 980;
    final horizontalPadding = isDesktop ? 48.0 : 16.0;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: _surface,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _brandBlue),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Urgent Recruitment in Jordan',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _brandBlue,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMessage(context, 'Share option coming soon'),
            icon: const FaIcon(
              FontAwesomeIcons.shareNodes,
              color: _mutedText,
              size: 18,
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _heroImage(isDesktop)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1344),
                    child: _headlineSection(),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                24,
                horizontalPadding,
                128,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1344),
                    child: isDesktop ? _desktopBody() : _mobileBody(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomActions(context),
    );
  }

  Widget _desktopBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: _primaryDetails()),
        const SizedBox(width: 24),
        Expanded(flex: 4, child: _sideDetails()),
      ],
    );
  }

  Widget _mobileBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_primaryDetails(), const SizedBox(height: 16), _sideDetails()],
    );
  }

  Widget _heroImage(bool isDesktop) {
    return SizedBox(
      height: isDesktop ? 420 : 210,
      width: double.infinity,
      child: Image.asset(item.image, fit: BoxFit.cover),
    );
  }

  Widget _headlineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            _Pill(label: 'Recruitment Open'),
            _IconText(
              icon: FontAwesomeIcons.circleCheck,
              label: 'Agency Verified',
              color: _brandBlue,
              bold: true,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _jobTitle,
          style: const TextStyle(
            color: _text,
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        const Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            _IconText(icon: FontAwesomeIcons.calendarDays, label: 'Posted: May 04, 2026'),
            _IconText(icon: FontAwesomeIcons.fingerprint, label: 'Post ID: 6'),
          ],
        ),
      ],
    );
  }

  Widget _primaryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 620 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: columns == 4 ? 1.05 : 1.0,
              children: const [
                _StatCard(icon: FontAwesomeIcons.users, label: 'Quota', value: '150\nPositions'),
                _StatCard(icon: FontAwesomeIcons.clock, label: 'Work Hours', value: '8h / Day'),
                _StatCard(icon: FontAwesomeIcons.briefcase, label: 'Experience', value: '2 Years'),
                _StatCard(icon: FontAwesomeIcons.locationDot, label: 'Age Range', value: '18-45 Years'),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _specificationsCard(),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 650;
            final cards = const [
              _InfoCard(icon: FontAwesomeIcons.hourglassHalf, label: 'Processing Time', value: '45 Days', color: _primary),
              _InfoCard(icon: FontAwesomeIcons.calendarXmark, label: 'Deadline', value: 'June 10, 2026', color: _error),
              _InfoCard(icon: FontAwesomeIcons.idBadge, label: 'Selection', value: 'Pushing Process', color: _mutedText),
            ];
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cards
                    .map((card) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: card,
                        ))
                    .toList(),
              );
            }
            return Row(
              children: cards
                  .map((card) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: card,
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 24),
        _packageInclusions(),
        const SizedBox(height: 24),
        _safetyGuidelines(),
      ],
    );
  }

  Widget _sideDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _priceCard(),
        const SizedBox(height: 16),
        _paymentBreakdown(),
        const SizedBox(height: 16),
        _agencyInfo(),
      ],
    );
  }

  Widget _specificationsCard() {
    final rows = [
      _SpecItem('Country', item.countryName, FontAwesomeIcons.flag),
      _SpecItem('Work Type', _jobWorkType),
      _SpecItem('Company Name', 'Port Cleaner Co.'),
      _SpecItem('Accommodation', 'Company Provided'),
      _SpecItem('Food Allowance', 'Company Provided'),
      _SpecItem('Contract Period', '2 Years (Renewable)'),
    ];

    return _CardShell(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: _surfaceLow,
              border: Border(bottom: BorderSide(color: _outline)),
            ),
            child: const Text(
              'Contract Specifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth > 620;
              return Wrap(
                children: rows
                    .map(
                      (row) => SizedBox(
                        width: twoColumns ? constraints.maxWidth / 2 : constraints.maxWidth,
                        child: _SpecRow(item: row),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _packageInclusions() {
    const inclusions = [
      _SpecItem('Visa', '', FontAwesomeIcons.fileLines),
      _SpecItem('Ticket', '', FontAwesomeIcons.ticket),
      _SpecItem('Manpower', '', FontAwesomeIcons.idCard),
      _SpecItem('Passport', '', FontAwesomeIcons.passport),
      _SpecItem('Photos', '', FontAwesomeIcons.camera),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Included in Package',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: inclusions
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAE2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(item.icon, size: 14, color: _mutedText),
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: const TextStyle(
                          color: Color(0xFF5C647A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _safetyGuidelines() {
    const tips = [
      'Do not quit your current job until the visa is stamped.',
      'Do not trust 100% guarantees; recruitment is subject to embassy approval.',
      'Always verify the agency\'s license number with the Ministry.',
      'Never pay full amounts in cash without a proper receipt.',
      'Verify your medical report status only through official GAMCA portal.',
      'Avoid brokers and agents; deal directly with the office.',
      'Keep a digital copy of all submitted documents.',
      'Ensure your passport has at least 1 year of validity.',
      'Do not sign blank papers or incomplete contracts.',
      'Report any suspicious demands to our support team immediately.',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _errorContainer.withAlpha(107),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _error.withAlpha(56)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: _error, shape: BoxShape.circle),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.gavel, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Critical Safety Guidelines',
                      style: TextStyle(color: Color(0xFF93000A), fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Read carefully before proceeding with any recruitment process',
                      style: TextStyle(color: Color(0xCC93000A), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth > 680;
              return Wrap(
                spacing: 18,
                runSpacing: 14,
                children: tips
                    .map(
                      (tip) => SizedBox(
                        width: twoColumns ? (constraints.maxWidth - 18) / 2 : constraints.maxWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: FaIcon(FontAwesomeIcons.circleCheck, size: 16, color: _error),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(color: _text, fontSize: 14, height: 1.42),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _priceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x332563EB), blurRadius: 24, offset: Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL CUSTOMER COST',
            style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'BDT ${_formatMoney(item.customerPrice)}',
            style: const TextStyle(color: Colors.white, fontSize: 40, height: 1.05, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 22),
          Container(height: 1, color: Colors.white24),
          const SizedBox(height: 18),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Monthly Salary', style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 14)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('280 JOD', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  SizedBox(height: 2),
                  Text('~ BDT 46,200', style: TextStyle(color: Color(0x99FFFFFF), fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
            child: const Row(
              children: [
                FaIcon(FontAwesomeIcons.moneyBillWave, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Standard Overseas Benefits Apply',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentBreakdown() {
    const steps = [
      _PaymentStep('Step 1: Booking Advance', 'BDT 78,000', 'Due at initial registration and file opening.', true),
      _PaymentStep('Step 2: After Visa', 'BDT 150,000', 'Payable once visa confirmation is verified.', false),
      _PaymentStep('Step 3: Before Flight', 'BDT 80,000', 'Final payment before receiving air ticket.', false),
    ];

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text),
          ),
          const SizedBox(height: 22),
          Column(
            children: [
              for (var index = 0; index < steps.length; index++)
                _TimelineStep(step: steps[index], isLast: index == steps.length - 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _agencyInfo() {
    return _CardShell(
      color: _surfaceLow,
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _outline),
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.buildingCircleCheck, color: _brandBlue, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Global Talent Hub', style: TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('RL-1452 • Licensed Agency', style: TextStyle(color: _mutedText, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: _surface.withAlpha(240),
          border: const Border(top: BorderSide(color: _outline)),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 18, offset: Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showMessage(context, 'Application process coming soon'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 16),
                label: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 12),
            _ActionIconButton(
              icon: FontAwesomeIcons.commentDots,
              semanticLabel: 'Chat',
              onPressed: () => _showMessage(context, 'Chat option coming soon'),
            ),
            const SizedBox(width: 12),
            _ActionIconButton(
              icon: FontAwesomeIcons.bookmark,
              semanticLabel: 'Bookmark',
              onPressed: () => _showMessage(context, 'Saved to bookmarks'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static String _formatMoney(int amount) {
    final text = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final remaining = text.length - i;
      buffer.write(text[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  static const String _jobTitle = 'Port/Border Cleaner';
  static const String _jobWorkType = 'Cleaner';
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({required this.icon, required this.semanticLabel, required this.onPressed});

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: WorkPermitDetailsScreen._mutedText,
          side: const BorderSide(color: WorkPermitDetailsScreen._outline),
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: FaIcon(icon, size: 18),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, this.padding = const EdgeInsets.all(18), this.color = WorkPermitDetailsScreen._surface});

  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WorkPermitDetailsScreen._outline),
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFDBE1FF), borderRadius: BorderRadius.circular(999)),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(color: Color(0xFF00174B), fontSize: 12, letterSpacing: 0.7, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.label, this.color = WorkPermitDetailsScreen._mutedText, this.bold = false});

  final IconData icon;
  final String label;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: WorkPermitDetailsScreen._brandBlue, size: 20),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: WorkPermitDetailsScreen._mutedText, fontSize: 12)),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: WorkPermitDetailsScreen._text, fontSize: 17, fontWeight: FontWeight.w800, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: WorkPermitDetailsScreen._surfaceHigh, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 15, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(color: color, fontSize: 11, letterSpacing: 0.7, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: WorkPermitDetailsScreen._text, fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _SpecItem {
  const _SpecItem(this.label, this.value, [this.icon]);

  final String label;
  final String value;
  final IconData? icon;
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.item});

  final _SpecItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: WorkPermitDetailsScreen._outline))),
      child: Row(
        children: [
          Expanded(
            child: Text(item.label, style: const TextStyle(color: WorkPermitDetailsScreen._mutedText, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  FaIcon(item.icon, color: WorkPermitDetailsScreen._error, size: 14),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    item.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: WorkPermitDetailsScreen._text, fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStep {
  const _PaymentStep(this.title, this.amount, this.description, this.active);

  final String title;
  final String amount;
  final String description;
  final bool active;
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.step, required this.isLast});

  final _PaymentStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = step.active ? WorkPermitDetailsScreen._brandBlue : const Color(0xFFDBE1FF);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: WorkPermitDetailsScreen._outline),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title.toUpperCase(),
                    style: TextStyle(
                      color: step.active ? WorkPermitDetailsScreen._brandBlue : WorkPermitDetailsScreen._mutedText,
                      fontSize: 11,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(step.amount, style: const TextStyle(color: WorkPermitDetailsScreen._text, fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(step.description, style: const TextStyle(color: WorkPermitDetailsScreen._mutedText, fontSize: 13, height: 1.35)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
