import 'package:flutter/material.dart';

class CustomerProfileEditScreen extends StatefulWidget {
  const CustomerProfileEditScreen({super.key});

  @override
  State<CustomerProfileEditScreen> createState() => _CustomerProfileEditScreenState();
}

class _CustomerProfileEditScreenState extends State<CustomerProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Demo User');
  final _genderController = TextEditingController(text: 'Male');
  final _dobController = TextEditingController(text: '1990-01-01');
  final _phoneController = TextEditingController(text: '+1 555 0102');
  final _emailController = TextEditingController(text: 'demo.user@example.com');
  final _addressController = TextEditingController(text: 'Dhaka, Bangladesh');
  final _districtController = TextEditingController(text: 'Dhaka');
  final _policeStationController = TextEditingController(text: 'Dhanmondi');
  final _passportNoController = TextEditingController(text: 'A12345678');
  final _passportExpiryController = TextEditingController(text: '2030-02-28');
  final _passportIssueController = TextEditingController(text: '2020-03-01');
  final _servicesController = TextEditingController(text: 'Work permit, Student visa');
  final _countriesController = TextEditingController(text: 'Japan, Malaysia');
  final _workTypesController = TextEditingController(text: 'Factory, Hospitality');

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _policeStationController.dispose();
    _passportNoController.dispose();
    _passportExpiryController.dispose();
    _passportIssueController.dispose();
    _servicesController.dispose();
    _countriesController.dispose();
    _workTypesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Personal Details'),
                _field('Full Name', _nameController),
                _field('Gender', _genderController),
                _field('Birth Date', _dobController),
                const SizedBox(height: 12),
                _sectionTitle('Login Details'),
                _field('Phone', _phoneController),
                _field('Email', _emailController),
                const SizedBox(height: 12),
                _sectionTitle('Contact Details'),
                _field('Address', _addressController),
                _field('District', _districtController),
                _field('Police Station', _policeStationController),
                const SizedBox(height: 12),
                _sectionTitle('Passport Information'),
                _field('Passport Number', _passportNoController),
                _field('Passport Expiry', _passportExpiryController),
                _field('Passport Issue', _passportIssueController),
                const SizedBox(height: 12),
                _sectionTitle('Personalized Information'),
                _field('Services', _servicesController),
                _field('Countries', _countriesController),
                _field('Job Types', _workTypesController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated successfully')),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
