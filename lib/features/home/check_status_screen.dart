import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class CheckStatusScreen extends StatefulWidget {
  const CheckStatusScreen({super.key});

  @override
  State<CheckStatusScreen> createState() => _CheckStatusScreenState();
}

class _CheckStatusScreenState extends State<CheckStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passportController = TextEditingController();
  final _bookingIdController = TextEditingController();

  List<BookingStatusItem> _data = [];
  bool _submitted = false;

  final List<BookingStatusItem> _allMockData = const [
    BookingStatusItem(
      id: '1001',
      name: 'Demo User',
      passportNo: 'A12345678',
      toCountry: 'Japan',
      serviceType: 'WORK_PERMIT',
      branch: 'Dhaka Branch',
      statusLabel: 'Under Processing',
      appointmentDate: '2026-05-18',
      visaExpiryDate: '2027-05-18',
    ),
    BookingStatusItem(
      id: '1002',
      name: 'John Smith',
      passportNo: 'B98765432',
      toCountry: 'Malaysia',
      serviceType: 'WORK_PERMIT',
      branch: 'Chattogram Branch',
      statusLabel: 'Medical Required',
      appointmentDate: '2026-06-03',
      medicalExpiryDate: '2026-08-03',
      policeClearanceExpiryDate: '2026-11-03',
    ),
  ];

  @override
  void dispose() {
    _passportController.dispose();
    _bookingIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final passport = _passportController.text.trim().toLowerCase();
    final bookingId = _bookingIdController.text.trim();

    final result = _allMockData.where((item) {
      return item.passportNo.toLowerCase() == passport && item.id == bookingId;
    }).toList();

    setState(() {
      _data = result;
      _submitted = true;
    });
  }

  void _clear() {
    _formKey.currentState?.reset();
    _passportController.clear();
    _bookingIdController.clear();
    setState(() {
      _data = [];
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/customer/check-status',
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(text: 'Check Your '),
                      TextSpan(text: 'Application', style: TextStyle(color: Color(0xFF2563EB))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 700;
                          if (isNarrow) {
                            return Column(
                              children: [
                                _inputField(
                                  label: 'Passport Number',
                                  controller: _passportController,
                                  autofocus: true,
                                ),
                                const SizedBox(height: 12),
                                _inputField(
                                  label: 'Booking ID',
                                  controller: _bookingIdController,
                                ),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: _inputField(
                                  label: 'Passport Number',
                                  controller: _passportController,
                                  autofocus: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _inputField(
                                  label: 'Booking ID',
                                  controller: _bookingIdController,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Submit'),
                          ),
                          ElevatedButton(
                            onPressed: _clear,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1D5DB),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_submitted) ...[
                  const SizedBox(height: 24),
                  if (_data.isEmpty)
                    const Text(
                      'No application found for given Passport Number and Booking ID.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    )
                  else
                    Column(
                      children: _data
                          .map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _statusCard(item: item),
                              ))
                          .toList(),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({required String label, required TextEditingController controller, bool autofocus = false}) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _statusCard({required BookingStatusItem item}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0x1A2563EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text('Booking ID #${item.id}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          _tableRow('Full Name', item.name),
          _tableRow('Passport Number', item.passportNo),
          _tableRow('Country', item.toCountry),
          _tableRow('Visa Category', item.serviceType),
          _tableRow('Meeting Type', 'Physical'),
          _tableRow('File Process Branch', item.branch),
          _tableRow('Status', item.statusLabel),
          if (item.medicalExpiryDate != null) _tableRow('Medical Expiry Date', item.medicalExpiryDate!),
          if (item.policeClearanceExpiryDate != null) _tableRow('Police Clearance Expiry Date', item.policeClearanceExpiryDate!),
          if (item.visaExpiryDate != null) _tableRow('Visa Expiry Date', item.visaExpiryDate!),
          _tableRow('Appointment Date', item.appointmentDate, isLast: true),
        ],
      ),
    );
  }

  Widget _tableRow(String label, String value, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            ),
            Expanded(
              flex: 7,
              child: Text(value, style: const TextStyle(color: Color(0xFF1F2937))),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingStatusItem {
  const BookingStatusItem({
    required this.id,
    required this.name,
    required this.passportNo,
    required this.toCountry,
    required this.serviceType,
    required this.branch,
    required this.statusLabel,
    required this.appointmentDate,
    this.medicalExpiryDate,
    this.policeClearanceExpiryDate,
    this.visaExpiryDate,
  });

  final String id;
  final String name;
  final String passportNo;
  final String toCountry;
  final String serviceType;
  final String branch;
  final String statusLabel;
  final String appointmentDate;
  final String? medicalExpiryDate;
  final String? policeClearanceExpiryDate;
  final String? visaExpiryDate;
}
