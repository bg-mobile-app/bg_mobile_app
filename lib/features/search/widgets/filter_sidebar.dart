import 'package:flutter/material.dart';
import '../../home/models/home_models.dart';
import '../../home/services/home_service.dart';

class FilterValue {
  const FilterValue({
    required this.query,
    this.country,
    this.workType,
    this.selectionType,
    this.minAge,
    this.maxAge,
  });

  final String query;
  final String? country;
  final String? workType;
  final String? selectionType;
  final String? minAge;
  final String? maxAge;
}

class FilterSidebar extends StatefulWidget {
  const FilterSidebar({super.key, required this.onApply, this.initialValue});

  final ValueChanged<FilterValue> onApply;
  final FilterValue? initialValue;

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  final _queryController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();

  String? _country;
  String? _workType;
  String? _selectionType;

  List<CountryItem> _countries = [];
  List<WorkTypeItem> _workTypes = [];
  bool _isLoading = true;

  final HomeService _homeService = HomeService();

  static const _selectionTypes = [
    'DELEGATE',
    'PUSHING',
    'ZOOM INTERVIEW',
    'CV SELECTION',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _queryController.text = widget.initialValue!.query;
      _country = widget.initialValue!.country;
      _workType = widget.initialValue!.workType;
      _selectionType = widget.initialValue!.selectionType;
      _minAgeController.text = widget.initialValue!.minAge ?? '';
      _maxAgeController.text = widget.initialValue!.maxAge ?? '';
    }
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    try {
      final results = await Future.wait([
        _homeService.getCountries(),
        _homeService.getWorkTypes(),
      ]);
      if (mounted) {
        setState(() {
          _countries = results[0] as List<CountryItem>;
          _workTypes = results[1] as List<WorkTypeItem>;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading metadata: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _queryController.clear();
      _minAgeController.clear();
      _maxAgeController.clear();
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
        minAge: _minAgeController.text.trim().isEmpty ? null : _minAgeController.text.trim(),
        maxAge: _maxAgeController.text.trim().isEmpty ? null : _maxAgeController.text.trim(),
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
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextButton(onPressed: _clearAll, child: const Text('Clear all')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _queryController,
                    decoration: const InputDecoration(
                      hintText: 'Search work permits...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _apply(),
                  ),
                  const SizedBox(height: 12),
                  SearchableDropdown<CountryItem>(
                    value: _country != null && _countries.any((e) => e.code == _country)
                        ? _countries.firstWhere((e) => e.code == _country)
                        : null,
                    hintText: 'Country',
                    items: _countries,
                    searchMatcher: (item, query) =>
                        item.name.toLowerCase().contains(query.toLowerCase()),
                    itemBuilder: (context, item) => Row(
                      children: [
                        if (item.unicodeFlag.isNotEmpty)
                          Text(item.unicodeFlag, style: const TextStyle(fontSize: 16))
                        else if (item.flag.isNotEmpty)
                          Image.network(
                            item.flag,
                            width: 24,
                            height: 16,
                            errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 16),
                          )
                        else
                          const Icon(Icons.flag, size: 16),
                        const SizedBox(width: 8),
                        Text(item.name),
                      ],
                    ),
                    onChanged: (v) => setState(() => _country = v?.code),
                  ),
                  const SizedBox(height: 12),
                  SearchableDropdown<WorkTypeItem>(
                    value: _workType != null && _workTypes.any((e) => e.name == _workType)
                        ? _workTypes.firstWhere((e) => e.name == _workType)
                        : null,
                    hintText: 'Work type',
                    items: _workTypes,
                    searchMatcher: (item, query) =>
                        item.name.toLowerCase().contains(query.toLowerCase()),
                    itemBuilder: (context, item) => Text(item.name),
                    onChanged: (v) => setState(() => _workType = v?.name),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectionType,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Selection type',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _selectionTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectionType = v),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Age Range',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minAgeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Min',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _maxAgeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Max',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _apply,
                      child: const Text('Apply filters'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.value,
    required this.hintText,
    required this.searchMatcher,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String hintText;
  final bool Function(T item, String query) searchMatcher;

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showSearchDialog(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.hintText,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: widget.value == null
            ? Text('Select ${widget.hintText}', style: const TextStyle(color: Colors.grey))
            : widget.itemBuilder(context, widget.value as T),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(
            builder: (context, setState) {
              final filteredItems = widget.items.where((item) {
                return widget.searchMatcher(item, searchQuery);
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Search ${widget.hintText}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Type to search...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (v) {
                        setState(() => searchQuery = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: filteredItems.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                'No matches found',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return InkWell(
                                  onTap: () {
                                    widget.onChanged(item);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0xFFF3F4F6)),
                                      ),
                                    ),
                                    child: widget.itemBuilder(context, item),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        widget.onChanged(null);
                        Navigator.pop(context);
                      },
                      child: Text('Clear Selection', style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
