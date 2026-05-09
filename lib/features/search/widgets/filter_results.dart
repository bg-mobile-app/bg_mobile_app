import 'package:flutter/material.dart';

import '../../home/models/home_models.dart';
import '../../home/widgets/work_permit_card.dart';

class FilterResults extends StatefulWidget {
  const FilterResults({super.key, required this.items, required this.brandBlue, required this.onViewDetails});

  final List<WorkPermitItem> items;
  final Color brandBlue;
  final ValueChanged<WorkPermitItem> onViewDetails;

  @override
  State<FilterResults> createState() => _FilterResultsState();
}

class _FilterResultsState extends State<FilterResults> {
  static const int _pageSize = 4;
  int _visibleCount = _pageSize;

  @override
  void didUpdateWidget(covariant FilterResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _visibleCount = _pageSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = widget.items.take(_visibleCount).toList();
    final hasMore = widget.items.length > _visibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (visibleItems.isEmpty)
          const Center(child: Text('No work permits found.', style: TextStyle(color: Colors.grey)))
        else
          ListView.separated(
            itemCount: visibleItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 280 + (i * 80)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(offset: Offset(0, (1 - value) * 14), child: child),
                  );
                },
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0x0D111827),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD1D5DB), width: 0.5),
                        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, 8))],
                      ),
                      child: AspectRatio(
                        aspectRatio: 0.66,
                        child: WorkPermitCard(
                          item: visibleItems[i],
                          brandBlue: widget.brandBlue,
                          onViewDetails: () => widget.onViewDetails(visibleItems[i]),
                          formatBdt: (v) => v.toString(),
                          timeAgo: (_) => 'recently',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        if (hasMore)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () => setState(() => _visibleCount += _pageSize),
                child: const Text('Load More'),
              ),
            ),
          )
        else if (widget.items.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(child: Text('No more results', style: TextStyle(color: Colors.grey))),
          ),
      ],
    );
  }
}
