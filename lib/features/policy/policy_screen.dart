import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'services/policy_service.dart';

/// Screen for displaying policy content (Terms & Conditions, Privacy Policy, etc.)
///
/// Usage:
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => const PolicyScreen(policyType: 'TERMS'),
///   ));
class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key, required this.policyType});

  /// One of: TERMS | PRIVACY | REFUND | ABOUT_US
  final String policyType;

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  final PolicyService _service = PolicyService();

  PolicyContent? _policy;
  bool _isLoading = true;
  bool _isBangla = false;

  static const _brandBlue = Color(0xFF2563EB);
  static const _background = Color(0xFFF8F9FF);
  static const _surface = Color(0xFFFFFFFF);
  static const _text = Color(0xFF0B1C30);
  static const _muted = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _service.getPolicyByType(widget.policyType);
    if (mounted) {
      setState(() {
        _policy = result;
        _isLoading = false;
      });
    }
  }

  String get _title {
    if (_policy == null) return _defaultTitle;
    if (_isBangla && (_policy!.titleBn?.isNotEmpty ?? false)) {
      return _policy!.titleBn!;
    }
    return _policy!.title.isNotEmpty ? _policy!.title : _defaultTitle;
  }

  String get _defaultTitle {
    switch (widget.policyType) {
      case 'TERMS':
        return 'Terms & Conditions';
      case 'PRIVACY':
        return 'Privacy Policy';
      case 'REFUND':
        return 'Refund Policy';
      case 'ABOUT_US':
        return 'About Us';
      default:
        return 'Policy';
    }
  }

  String get _htmlContent {
    if (_policy == null) return '';
    if (_isBangla && (_policy!.contentBn?.isNotEmpty ?? false)) {
      return _policy!.contentBn!;
    }
    return _policy!.content;
  }

  bool get _hasBangla =>
      (_policy?.titleBn?.isNotEmpty ?? false) ||
      (_policy?.contentBn?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: _surface,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _brandBlue),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Text(
          _defaultTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _brandBlue,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          // Language toggle — only shown when Bangla content exists
          if (!_isLoading && _hasBangla)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.language, size: 14),
                    label: Text('EN'),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.translate, size: 14),
                    label: Text('বাং'),
                  ),
                ],
                selected: {_isBangla},
                showSelectedIcon: false,
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected)
                        ? Colors.white
                        : _brandBlue,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected)
                        ? _brandBlue
                        : _surface,
                  ),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: _brandBlue),
                  ),
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 6),
                  ),
                ),
                onSelectionChanged: (v) =>
                    setState(() => _isBangla = v.first),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _policy == null
              ? const SizedBox.shrink()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Could not load content.\nPlease try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _isLoading = true);
                _load();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        // Header card
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: _brandBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                if (_policy!.updatedAt.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Last updated: ${_formatDate(_policy!.updatedAt)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // HTML content
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _htmlContent.isNotEmpty
                  ? Html(
                      data: _htmlContent,
                      style: {
                        'body': Style(
                          fontSize: FontSize(15),
                          color: _text,
                          lineHeight: LineHeight.number(1.7),
                          padding: HtmlPaddings.all(20),
                          margin: Margins.zero,
                        ),
                        'h1': Style(
                          fontSize: FontSize(20),
                          fontWeight: FontWeight.w800,
                          color: _text,
                          margin: Margins.only(bottom: 12, top: 8),
                        ),
                        'h2': Style(
                          fontSize: FontSize(17),
                          fontWeight: FontWeight.w700,
                          color: _text,
                          margin: Margins.only(bottom: 10, top: 16),
                        ),
                        'h3': Style(
                          fontSize: FontSize(15),
                          fontWeight: FontWeight.w700,
                          color: _text,
                          margin: Margins.only(bottom: 8, top: 14),
                        ),
                        'p': Style(
                          margin: Margins.only(bottom: 12),
                          color: const Color(0xFF374151),
                        ),
                        'li': Style(
                          color: const Color(0xFF374151),
                          margin: Margins.only(bottom: 6),
                        ),
                        'a': Style(
                          color: _brandBlue,
                          textDecoration: TextDecoration.underline,
                        ),
                        'strong': Style(
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No content available.',
                        style: TextStyle(color: Color(0xFF9CA3AF)),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
