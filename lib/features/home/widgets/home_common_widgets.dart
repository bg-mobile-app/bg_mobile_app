import 'package:flutter/material.dart';

class HeaderActionButton extends StatelessWidget {
  const HeaderActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.brandBlue,
  });

  final String label;
  final VoidCallback onTap;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: brandBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}
