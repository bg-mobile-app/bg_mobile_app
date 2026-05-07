import 'package:flutter/material.dart';

import 'filter_sidebar.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key, required this.onApply});

  final ValueChanged<FilterValue> onApply;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (context) => FractionallySizedBox(
            heightFactor: 0.85,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilterSidebar(onApply: (value) {
                onApply(value);
                Navigator.pop(context);
              }),
            ),
          ),
        );
      },
      icon: const Icon(Icons.tune),
      label: const Text('Filters'),
    );
  }
}
