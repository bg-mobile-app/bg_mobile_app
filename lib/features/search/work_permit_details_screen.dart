import 'package:flutter/material.dart';

import '../home/models/home_models.dart';

class WorkPermitDetailsScreen extends StatelessWidget {
  const WorkPermitDetailsScreen({super.key, required this.item});

  final WorkPermitItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(item.slug.replaceAll('-', ' ').toUpperCase()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDCE3F3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(item.image, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Slug: ${item.slug}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    _detailRow('Country', item.countryName),
                    _detailRow('Work Type', item.workType),
                    _detailRow('Selection Type', item.selectionType),
                    _detailRow('Customer Price', 'BDT ${item.customerPrice}'),
                    _detailRow('Agent Price', 'BDT ${item.agentPrice}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is a dummy work permit details screen. You can now open each specific card by slug and show all relevant information for that permit.',
                      style: TextStyle(height: 1.5, color: Color(0xFF374151)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
