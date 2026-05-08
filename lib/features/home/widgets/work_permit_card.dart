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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCE8FF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content section
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0xFFDCE8FF),
                              ),
                            ),
                            child: Image.asset(
                              item.countryFlag,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.countryName.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                letterSpacing: 1,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoItem(
                            item.workType.toUpperCase(),
                            'Work Type',
                          ),
                          const SizedBox(width: 12),
                          // Created time as a badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF4FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              timeAgo(item.createdAt),
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Image + selectionType (no border radius)
                Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      child: Image.asset(
                        item.image,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: brandBlue.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.selectionType.replaceAll('_', ' '),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Price and button full width, keep original style
          _buildPriceSection(),
        ],
      ),
    );
  }

  Widget _buildCountryHeader() {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFDCE8FF)),
          ),
          child: Image.asset(item.countryFlag, fit: BoxFit.contain),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.countryName.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              letterSpacing: 1,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: brandBlue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            item.selectionType.replaceAll('_', ' '),
            style: TextStyle(
              color: brandBlue,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // _buildInfoGrid is no longer used

  Widget _buildInfoItem(String value, String label) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(item.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: brandBlue.withValues(alpha: 0.07),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: brandBlue.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BDT ${formatBdt(item.customerPrice)}',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Customer Price',
                style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onViewDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(96, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'View Details',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
