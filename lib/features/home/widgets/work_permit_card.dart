import 'package:flutter/material.dart';

import '../models/home_models.dart';

class WorkPermitCard extends StatelessWidget {
  const WorkPermitCard({
    super.key,
    required this.item,
    required this.brandBlue,
    required this.onViewDetails,
    required this.formatBdt,
    required this.timeAgo,
  });

  final WorkPermitItem item;
  final Color brandBlue;
  final VoidCallback onViewDetails;
  final String Function(int) formatBdt;
  final String Function(DateTime) timeAgo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(alignment: Alignment.bottomCenter, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: AspectRatio(aspectRatio: 1, child: Image.asset(item.image, fit: BoxFit.cover)),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .7), borderRadius: BorderRadius.circular(999)),
              child: Text(item.selectionType.replaceAll('_', ' '), style: TextStyle(color: brandBlue, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text('${formatBdt(item.customerPrice)} BDT', style: TextStyle(color: brandBlue, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(children: [
                SizedBox(width: 20, height: 14, child: Image.asset(item.countryFlag, fit: BoxFit.contain)),
                const SizedBox(width: 4),
                Expanded(child: Text(item.countryName, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(child: Row(children: [const Icon(Icons.construction, size: 12), const SizedBox(width: 3), Expanded(child: Text(item.workType, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis))])),
                const SizedBox(width: 4),
                Text(timeAgo(item.createdAt), style: const TextStyle(fontSize: 10)),
              ]),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: onViewDetails,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [const Text('View Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)), const SizedBox(width: 4), Icon(Icons.arrow_right_alt, color: brandBlue)]),
                ),
              ),
              Container(height: 3, decoration: BoxDecoration(color: brandBlue, borderRadius: BorderRadius.circular(99))),
            ]),
          ),
        ),
      ]),
    );
  }
}
