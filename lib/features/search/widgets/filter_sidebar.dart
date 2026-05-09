import 'package:flutter/material.dart';

class FilterValue {
  const FilterValue({
    required this.query,
    this.country,
    this.workType,
    this.selectionType,
  });

  final String query;
  final String? country;
  final String? workType;
  final String? selectionType;
}

class FilterSidebar extends StatefulWidget {
  const FilterSidebar({super.key, required this.onApply});

  final ValueChanged<FilterValue> onApply;

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  final _queryController = TextEditingController();

  String? _country;
  String? _workType;
  String? _selectionType;

  static const _countries = ['Malaysia', 'Romania', 'Japan', 'Poland'];
  static const _workTypes = ['Factory', 'Construction', 'Hospitality', 'Agriculture'];
  static const _selectionTypes = ['DIRECT', 'LOTTERY', 'DELEGATE'];

  void _clearAll() {
    setState(() {
      _queryController.clear();
      _country = null;
      _workType = null;
      _selectionType = null;
    });
    _apply();
  }

  void _apply() {
    widget.onApply(
      FilterValue(
        query: _queryController.text.trim(),
        country: _country,
        workType: _workType,
        selectionType: _selectionType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            TextButton(onPressed: _clearAll, child: const Text('Clear all')),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _queryController,
          decoration: const InputDecoration(hintText: 'Search work permits...', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _country,
          decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
          items: _countries.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _country = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _workType,
          decoration: const InputDecoration(labelText: 'Work type', border: OutlineInputBorder()),
          items: _workTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _workType = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _selectionType,
          decoration: const InputDecoration(labelText: 'Selection type', border: OutlineInputBorder()),
          items: _selectionTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectionType = v),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: _apply, child: const Text('Apply filters')),
        ),
      ]),
    );
  }
}
