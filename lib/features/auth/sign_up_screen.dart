import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const Color _brandBlue = Color(0xFF2563EB);

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  String? _selectedDistrict;
  String? _selectedPoliceStation;
  bool _agreeTerms = false;
  bool _loading = false;

  final List<String> _genderOptions = const ['Male', 'Female', 'Other'];
  final List<String> _districtOptions = const [
    'Dhaka',
    'Chattogram',
    'Rajshahi',
    'Khulna',
  ];

  final Map<String, List<String>> _policeStationByDistrict = const {
    'Dhaka': ['Dhanmondi', 'Uttara', 'Gulshan'],
    'Chattogram': ['Panchlaish', 'Kotwali', 'Patenga'],
    'Rajshahi': ['Boalia', 'Motihar', 'Rajpara'],
    'Khulna': ['Sonadanga', 'Khalishpur', 'Daulatpur'],
  };

  List<String> get _policeStations =>
      _policeStationByDistrict[_selectedDistrict] ?? const [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked != null) {
      _birthDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Privacy Policy and Terms.')),
      );
      return;
    }

    setState(() => _loading = true);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) {
        return;
      }
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account creation UI is ready.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Customer Sign Up')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth >= 1024 ? constraints.maxWidth * 0.6 : 860,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Create a New Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              'Welcome to Bideshgami be our wonderful customer.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Basic Information',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(0xCC2563EB),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildResponsiveGrid(
                            children: [
                              _buildTextField(
                                label: 'Full Name',
                                controller: _fullNameController,
                                hint: 'John Doe',
                              ),
                              _buildDropdownField(
                                label: 'Select Your Gender',
                                value: _selectedGender,
                                items: _genderOptions,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value);
                                },
                              ),
                              _buildDateField(),
                              _buildDropdownField(
                                label: 'District',
                                value: _selectedDistrict,
                                items: _districtOptions,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDistrict = value;
                                    _selectedPoliceStation = null;
                                  });
                                },
                              ),
                              _buildDropdownField(
                                label: 'Police Station',
                                value: _selectedPoliceStation,
                                items: _policeStations,
                                disabled: _policeStations.isEmpty,
                                hintText: _policeStations.isEmpty
                                    ? 'Select District first'
                                    : 'Select Police Station',
                                onChanged: (value) {
                                  setState(() => _selectedPoliceStation = value);
                                },
                              ),
                              _buildAddressField(),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Login Information',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(0xCC2563EB),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildResponsiveGrid(
                            children: [
                              _buildTextField(
                                label: 'Email Address',
                                controller: _emailController,
                                hint: 'you@example.com',
                              ),
                              _buildTextField(
                                label: 'Phone Number',
                                controller: _phoneController,
                                hint: '01XXXXXXXXX',
                              ),
                              _buildTextField(
                                label: 'Password',
                                controller: _passwordController,
                                hint: 'Enter password',
                                obscure: true,
                              ),
                              _buildTextField(
                                label: 'Confirm Password',
                                controller: _confirmPasswordController,
                                hint: 'Confirm password',
                                obscure: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _agreeTerms,
                                        onChanged: (value) {
                                          setState(() => _agreeTerms = value ?? false);
                                        },
                                      ),
                                      const Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'I agree with Bideshgami ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF475569),
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: TextStyle(color: _brandBlue),
                                                ),
                                                TextSpan(text: ' and '),
                                                TextSpan(
                                                  text: 'Terms & Conditions.',
                                                  style: TextStyle(color: _brandBlue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _loading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _brandBlue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Text(_loading ? 'Creating...' : 'Create Account'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTwoColumn = constraints.maxWidth >= 720;
        if (!isTwoColumn) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += 2) {
          final left = children[i];
          final right = i + 1 < children.length ? children[i + 1] : const SizedBox();
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 16),
                Expanded(child: right),
              ],
            ),
          );
          if (i + 2 < children.length) {
            rows.add(const SizedBox(height: 14));
          }
        }

        return Column(children: rows);
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool disabled = false,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: disabled ? null : onChanged,
          validator: (selected) {
            if (selected == null || selected.isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Birth Date', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _birthDateController,
          readOnly: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select birth date',
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
          onTap: _pickBirthDate,
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Your Full Address', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _addressController,
          maxLines: 5,
          maxLength: 500,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'type agency address here...',
            helperText: 'Max 500 characters',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),
      ],
    );
  }
}
