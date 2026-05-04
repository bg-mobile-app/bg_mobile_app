import 'package:flutter/material.dart';

import 'widgets/auth_form_widgets.dart';

class RecruitingSignUpScreen extends StatefulWidget {
  const RecruitingSignUpScreen({super.key});

  @override
  State<RecruitingSignUpScreen> createState() => _RecruitingSignUpScreenState();
}

class _RecruitingSignUpScreenState extends State<RecruitingSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _rlNoController = TextEditingController();
  final _agencyAddressController = TextEditingController();
  final _agencyPhoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  String? _district;
  String? _policeStation;
  bool _agreeTerms = false;
  bool _loading = false;

  final List<String> _genderOptions = const ['Male', 'Female', 'Other'];
  final List<String> _districtOptions = const ['Dhaka', 'Chattogram', 'Rajshahi', 'Khulna'];
  final Map<String, List<String>> _policeStationByDistrict = const {
    'Dhaka': ['Dhanmondi', 'Uttara', 'Gulshan'],
    'Chattogram': ['Panchlaish', 'Kotwali', 'Patenga'],
    'Rajshahi': ['Boalia', 'Motihar', 'Rajpara'],
    'Khulna': ['Sonadanga', 'Khalishpur', 'Daulatpur'],
  };

  List<String> get _policeStations => _policeStationByDistrict[_district] ?? const [];

  @override
  void dispose() { for (final c in [_fullNameController,_agencyNameController,_rlNoController,_agencyAddressController,_agencyPhoneController,_designationController,_phoneController,_emailController,_passwordController,_confirmPasswordController]) { c.dispose(); } super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to Privacy Policy and Terms.'))); return; }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recruiting agency sign up UI is ready.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recruiting Agency Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Become A Bideshgami Recruiting Agency',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Center(
                          child: Text(
                            'Fill out the basic info. and get a chance to grow your business with us.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const FormSectionTitle('Agency Information'),
                        AuthFormGrid(
                          children: [
                            LabeledTextField(label: 'Enter Full Name (Agency Owner)', controller: _fullNameController, hint: 'John Doe'),
                            LabeledDropdownField(label: 'Select Gender (Agency Owner)', value: _gender, items: _genderOptions, onChanged: (v) => setState(() => _gender = v)),
                            LabeledTextField(label: 'Enter Agency Name', controller: _agencyNameController, hint: 'xyz Company'),
                            LabeledTextField(label: 'Enter Agency RL No', controller: _rlNoController, hint: 'RL Number', keyboardType: TextInputType.number),
                            LabeledDropdownField(
                              label: 'Select Agency District',
                              value: _district,
                              items: _districtOptions,
                              onChanged: (v) {
                                setState(() {
                                  _district = v;
                                  _policeStation = null;
                                });
                              },
                            ),
                            LabeledDropdownField(
                              label: 'Select Agency Police Station',
                              value: _policeStation,
                              items: _policeStations,
                              enabled: _policeStations.isNotEmpty,
                              hint: _policeStations.isEmpty ? 'Select District first' : 'Select Police Station',
                              onChanged: (v) => setState(() => _policeStation = v),
                            ),
                            LabeledTextField(
                              label: 'Enter Agency Full Address',
                              controller: _agencyAddressController,
                              hint: 'type agency address here...',
                              maxLines: 5,
                              helperText: 'Max 500 characters',
                              spanTwoColumns: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const FormSectionTitle('Contact Information'),
                        AuthFormGrid(
                          children: [
                            LabeledTextField(label: 'Enter Contact Number (Agency)', controller: _agencyPhoneController, hint: '01*********'),
                            LabeledTextField(label: 'Enter Your Designation', controller: _designationController, hint: 'Your Designation'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const FormSectionTitle('Login Information'),
                        AuthFormGrid(
                          children: [
                            LabeledTextField(label: 'Enter Your Phone Number', controller: _phoneController, hint: '017XXXXXXXX'),
                            LabeledTextField(label: 'Enter Your E-mail', controller: _emailController, hint: 'example@mail.com'),
                            LabeledTextField(label: 'Enter Your Password', controller: _passwordController, hint: 'Demo@123', obscure: true),
                            LabeledTextField(label: 'Confirm Password', controller: _confirmPasswordController, hint: 'Demo@123', obscure: true),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const AuthFormGrid(
                          columnsOverride: 3,
                          children: [
                            UploadInputBox(label: 'Upload Photo (Agency Owner)'),
                            UploadInputBox(label: 'Upload NID (With Both Side)'),
                            UploadInputBox(label: 'Upload Trade License'),
                            UploadInputBox(label: 'Upload Recruiting License (RL)'),
                            UploadInputBox(label: 'Upload Civil Aviation License'),
                          ],
                        ),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
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
      ),
    );
  }
}
