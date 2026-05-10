import 'package:flutter/material.dart';

class AgentSignUpScreen extends StatefulWidget {
  const AgentSignUpScreen({super.key});

  @override
  State<AgentSignUpScreen> createState() => _AgentSignUpScreenState();
}

class _AgentSignUpScreenState extends State<AgentSignUpScreen> {
  static const Color _brandBlue = Color(0xFF2563EB);

  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _agencyAddressController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  String? _district;
  String? _policeStation;
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
      _policeStationByDistrict[_district] ?? const [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _agencyNameController.dispose();
    _agencyAddressController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Privacy Policy and Terms.')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agent sign up UI is ready.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Agent Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 4)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Become A Bideshgami Agent',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          'Fill out the basic info. and get a chance to grow your business with us.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _sectionTitle('Basic Information'),
                      const SizedBox(height: 12),
                      _grid(children: [
                        _textField('Full Name', _fullNameController, hint: 'John Doe'),
                        _dropdownField(
                          label: 'Select Your Gender',
                          value: _gender,
                          items: _genderOptions,
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                        _textField('Agency Name', _agencyNameController,
                            hint: 'Enter Your Agency Name'),
                        _textField('Agency Address', _agencyAddressController,
                            hint: 'Enter Your Agency Address'),
                      ]),
                      const SizedBox(height: 16),
                      _sectionTitle('Permanent Address'),
                      const SizedBox(height: 12),
                      _grid(children: [
                        _dropdownField(
                          label: 'District',
                          value: _district,
                          items: _districtOptions,
                          onChanged: (v) {
                            setState(() {
                              _district = v;
                              _policeStation = null;
                            });
                          },
                        ),
                        _dropdownField(
                          label: 'Police Station',
                          value: _policeStation,
                          items: _policeStations,
                          hint: _policeStations.isEmpty
                              ? 'Select District first'
                              : 'Select Police Station',
                          enabled: _policeStations.isNotEmpty,
                          onChanged: (v) => setState(() => _policeStation = v),
                        ),
                        _textField('Enter Your Full Address', _addressController,
                            hint: 'type agency address here...', maxLines: 5,
                            helperText: 'Max 500 characters', spanTwoColumns: true),
                      ]),
                      const SizedBox(height: 16),
                      _sectionTitle('Login Information'),
                      const SizedBox(height: 12),
                      _grid(children: [
                        _textField('Email Address', _emailController, hint: 'you@example.com'),
                        _textField('Phone Number', _phoneController, hint: '01XXXXXXXXX'),
                        _textField('Password', _passwordController,
                            hint: 'Enter password', obscure: true),
                        _textField('Confirm Password', _confirmPasswordController,
                            hint: 'Confirm password', obscure: true),
                      ]),
                      const SizedBox(height: 16),
                      _grid(children: const [
                        _UploadBox(label: 'Upload Your Photo'),
                        _UploadBox(label: 'Upload NID (With Both Side)'),
                        _UploadBox(label: 'Upload Trade License'),
                      ], columnsOverride: 3),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        value: _agreeTerms,
                        onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'By continue, I agree to the website Privacy Policy and Terms & Conditions.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                        ),
                      ),
                      const SizedBox(height: 12),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Color(0xCC2563EB),
        ),
      );

  Widget _grid({required List<Widget> children, int? columnsOverride}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsOverride ?? (constraints.maxWidth >= 700 ? 2 : 1);
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: children.map((w) {
            final spanTwo = w is _SpanTwoColumn;
            if (spanTwo && columns > 1) {
              return SizedBox(width: constraints.maxWidth, child: w.child);
            }
            final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
            return SizedBox(width: width, child: w);
          }).toList(),
        );
      },
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool obscure = false,
    int maxLines = 1,
    String? helperText,
    bool spanTwoColumns = false,
  }) {
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label *', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
        ),
      ],
    );
    return spanTwoColumns ? _SpanTwoColumn(field) : field;
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String hint = 'Select an option',
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label *', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFF8FAFC),
          ),
          child: const Text('Choose file'),
        ),
      ],
    );
  }
}

class _SpanTwoColumn extends StatelessWidget {
  const _SpanTwoColumn(this.child);
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}
