import 'package:flutter/material.dart';

import '../../home/models/home_models.dart';
import '../../home/widgets/work_permit_card.dart';

class FilterResults extends StatefulWidget {
  const FilterResults({super.key, required this.items, required this.brandBlue});

  final List<WorkPermitItem> items;
  final Color brandBlue;

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

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: visibleItems.isEmpty
            ? const Center(child: Text('No work permits found.', style: TextStyle(color: Colors.grey)))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.66,
                ),
                itemCount: visibleItems.length,
                itemBuilder: (_, i) => WorkPermitCard(
                  item: visibleItems[i],
                  brandBlue: widget.brandBlue,
                  onViewDetails: () {},
                  formatBdt: (v) => v.toString(),
                  timeAgo: (_) => 'recently',
                ),
              ),
      ),
      if (hasMore)
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ElevatedButton(
              onPressed: () => setState(() => _visibleCount += _pageSize),
              child: const Text('Load More'),
            ),
          ),
        )
      else if (widget.items.isNotEmpty)
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Center(child: Text('No more results', style: TextStyle(color: Colors.grey))),
        ),
    ]);
  }
}
