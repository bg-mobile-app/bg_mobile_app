import 'package:flutter/material.dart';

class FormSectionTitle extends StatelessWidget {
  const FormSectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xCC2563EB)));
}

class AuthFormGrid extends StatelessWidget {
  const AuthFormGrid({super.key, required this.children, this.columnsOverride});
  final List<Widget> children;
  final int? columnsOverride;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columns = columnsOverride ?? (constraints.maxWidth >= 700 ? 2 : 1);
      return Wrap(spacing: 14, runSpacing: 14, children: children.map((w) {
        final spanTwo = w is _SpanTwoColumn;
        if (spanTwo && columns > 1) return SizedBox(width: constraints.maxWidth, child: (w as _SpanTwoColumn).child);
        final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
        return SizedBox(width: width, child: w);
      }).toList());
    });
  }
}

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({super.key, required this.label, required this.controller, this.hint, this.obscure = false, this.maxLines = 1, this.helperText, this.spanTwoColumns = false, this.keyboardType});
  final String label; final TextEditingController controller; final String? hint; final bool obscure; final int maxLines; final String? helperText; final bool spanTwoColumns; final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    final field = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$label *', style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), TextFormField(controller: controller, obscureText: obscure, maxLines: maxLines, keyboardType: keyboardType, decoration: InputDecoration(hintText: hint, helperText: helperText, border: const OutlineInputBorder(), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)), validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null)]);
    return spanTwoColumns ? _SpanTwoColumn(field) : field;
  }
}

class LabeledDropdownField extends StatelessWidget {
  const LabeledDropdownField({super.key, required this.label, required this.value, required this.items, required this.onChanged, this.hint = 'Select an option', this.enabled = true});
  final String label; final String? value; final List<String> items; final ValueChanged<String?> onChanged; final String hint; final bool enabled;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$label *', style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), DropdownButtonFormField<String>(initialValue: value, items: items.map((e)=>DropdownMenuItem<String>(value:e, child:Text(e))).toList(), onChanged: enabled ? onChanged : null, decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder(), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null)]);
}

class UploadInputBox extends StatelessWidget {
  const UploadInputBox({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), Container(height: 46, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4), color: const Color(0xFFF8FAFC)), child: const Text('Choose file'))]);
}

class _SpanTwoColumn extends StatelessWidget { const _SpanTwoColumn(this.child); final Widget child; @override Widget build(BuildContext context)=>child; }
