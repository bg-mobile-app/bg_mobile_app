import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/services/auth_service.dart';
import '../../common/services/location_service.dart';
import '../../routes/app_routes.dart';
import 'widgets/auth_form_widgets.dart';

class RecruitingSignUpScreen extends StatefulWidget {
  const RecruitingSignUpScreen({super.key, this.agencyType = 'recruiting'});

  final String agencyType;

  @override
  State<RecruitingSignUpScreen> createState() => _RecruitingSignUpScreenState();
}

class _RecruitingSignUpScreenState extends State<RecruitingSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _locationService = LocationService();
  final _picker = ImagePicker();

  final _fullNameController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _rlNoController = TextEditingController();
  final _agencyAddressController = TextEditingController();
  final _agencyPhoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _ownerContactNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  DistrictOption? _selectedDistrict;
  PoliceStationOption? _selectedPoliceStation;

  List<DistrictOption> _districts = const [];
  List<PoliceStationOption> _policeStations = const [];

  XFile? _ownerImage;
  XFile? _nidImage;
  XFile? _tradeLicenseImage;
  XFile? _rlLicenseImage;
  XFile? _civilAviationLicenseImage;

  bool _agreeTerms = false;
  bool _loading = false;
  bool _locationsLoading = false;

  final List<String> _genderOptions = const ['MALE', 'FEMALE', 'OTHER'];

  String get _agencyTitle {
    switch (widget.agencyType) {
      case 'hajj_umrah':
        return 'Hajj & Umrah Agency';
      case 'student':
        return 'Student Consultancy';
      default:
        return 'Recruiting Agency';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

  @override
  void dispose() {
    for (final c in [
      _fullNameController,
      _agencyNameController,
      _rlNoController,
      _agencyAddressController,
      _agencyPhoneController,
      _designationController,
      _ownerContactNumberController,
      _phoneController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadDistricts() async {
    setState(() => _locationsLoading = true);
    final districts = await _locationService.getDistricts();
    if (!mounted) return;
    setState(() {
      _districts = districts;
      _locationsLoading = false;
    });
  }

  Future<void> _loadPoliceStations(int districtId) async {
    setState(() {
      _policeStations = [];
      _selectedPoliceStation = null;
      _locationsLoading = true;
    });

    final stations = await _locationService.getPoliceStations(districtId);
    if (!mounted) return;
    setState(() {
      _policeStations = stations;
      _locationsLoading = false;
    });
  }

  Future<void> _pickFile(ValueSetter<XFile?> setter) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => setter(picked));
  }

  Future<MultipartFile> _toMultipart(XFile file) async {
    return MultipartFile.fromFile(file.path, filename: file.name);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Privacy Policy and Terms.'),
        ),
      );
      return;
    }

    if (_selectedDistrict == null || _selectedPoliceStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select district and police station.'),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and confirm password do not match.'),
        ),
      );
      return;
    }

    final rlNo = int.tryParse(_rlNoController.text.trim());
    if (rlNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid agency RL no.')),
      );
      return;
    }

    if (_ownerImage == null ||
        _nidImage == null ||
        _tradeLicenseImage == null ||
        _rlLicenseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required files.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final formData = FormData.fromMap({
        'agency_name': _agencyNameController.text.trim(),
        'agency_phone': _agencyPhoneController.text.trim(),
        'rl_no': rlNo,
        'service_type': 'WORK_PERMIT',
        'agency_address': _agencyAddressController.text.trim(),
        'district': _selectedDistrict!.id,
        'police_station': _selectedPoliceStation!.id,
        'full_name': _fullNameController.text.trim(),
        'contact_number': _ownerContactNumberController.text.trim(),
        'gender': _gender,
        'designation': _designationController.text.trim(),
        'image': await _toMultipart(_ownerImage!),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'is_privacy_terms': true,
        'nid_image': await _toMultipart(_nidImage!),
        'trade_license_image': await _toMultipart(_tradeLicenseImage!),
        'rl_license_image': await _toMultipart(_rlLicenseImage!),
        if (_civilAviationLicenseImage != null)
          'civil_aviation_license_image': await _toMultipart(
            _civilAviationLicenseImage!,
          ),
      });

      await _authService.registerRecruitingAgency(formData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful. Please verify OTP.'),
        ),
      );
      context.go(
        '${AppRoutes.otpVerify}?username=${Uri.encodeComponent(_emailController.text.trim())}&next=${Uri.encodeComponent(AppRoutes.agentSignUpThankYou)}',
      );
    } on DioException catch (e) {
      if (!mounted) return;
      String message = 'Registration failed. Please try again.';
      final data = e.response?.data;
      if (data is Map) {
        if (data['detail'] != null) {
          message = data['detail'].toString();
        } else if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['errors'] != null) {
          message = data['errors'].toString();
        }
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$_agencyTitle Sign Up')),
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
                        Center(
                          child: Text(
                            'Become A Bideshgami $_agencyTitle',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
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
                            LabeledTextField(
                              label: 'Enter Full Name (Agency Owner)',
                              controller: _fullNameController,
                              hint: 'John Doe',
                            ),
                            LabeledDropdownField(
                              label: 'Select Gender (Agency Owner)',
                              value: _gender,
                              items: _genderOptions,
                              onChanged: (v) => setState(() => _gender = v),
                            ),
                            LabeledTextField(
                              label: 'Enter Agency Name',
                              controller: _agencyNameController,
                              hint: 'xyz Company',
                            ),
                            LabeledTextField(
                              label: 'Enter Agency RL No',
                              controller: _rlNoController,
                              hint: 'RL Number',
                              keyboardType: TextInputType.number,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Agency District *',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<DistrictOption>(
                                  initialValue: _selectedDistrict,
                                  isExpanded: true,
                                  items: _districts
                                      .map(
                                        (d) => DropdownMenuItem<DistrictOption>(
                                          value: d,
                                          child: Text(d.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _locationsLoading
                                      ? null
                                      : (d) {
                                          if (d == null) return;
                                          setState(() => _selectedDistrict = d);
                                          _loadPoliceStations(d.id);
                                        },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                  validator: (v) =>
                                      v == null ? 'Required' : null,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Agency Police Station *',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<PoliceStationOption>(
                                  initialValue: _selectedPoliceStation,
                                  isExpanded: true,
                                  items: _policeStations
                                      .map(
                                        (p) =>
                                            DropdownMenuItem<
                                              PoliceStationOption
                                            >(value: p, child: Text(p.name)),
                                      )
                                      .toList(),
                                  onChanged:
                                      (_selectedDistrict == null ||
                                          _locationsLoading)
                                      ? null
                                      : (p) => setState(
                                          () => _selectedPoliceStation = p,
                                        ),
                                  decoration: InputDecoration(
                                    hintText: _selectedDistrict == null
                                        ? 'Select district first'
                                        : 'Select police station',
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                  validator: (v) =>
                                      v == null ? 'Required' : null,
                                ),
                              ],
                            ),
                            LabeledTextField(
                              label: 'Enter Agency Full Address',
                              controller: _agencyAddressController,
                              hint: 'type agency address here...',
                              maxLines: 4,
                              helperText: 'Max 500 characters',
                              spanTwoColumns: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const FormSectionTitle('Contact Information'),
                        AuthFormGrid(
                          children: [
                            LabeledTextField(
                              label: 'Enter Contact Number (Agency)',
                              controller: _agencyPhoneController,
                              hint: '01*********',
                            ),
                            LabeledTextField(
                              label: 'Enter Contact Number (Owner)',
                              controller: _ownerContactNumberController,
                              hint: '018********',
                            ),
                            LabeledTextField(
                              label: 'Enter Your Designation',
                              controller: _designationController,
                              hint: 'Proprietor',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const FormSectionTitle('Login Information'),
                        AuthFormGrid(
                          children: [
                            LabeledTextField(
                              label: 'Enter Your Phone Number',
                              controller: _phoneController,
                              hint: '017XXXXXXXX',
                            ),
                            LabeledTextField(
                              label: 'Enter Your E-mail',
                              controller: _emailController,
                              hint: 'example@mail.com',
                            ),
                            LabeledTextField(
                              label: 'Enter Your Password',
                              controller: _passwordController,
                              hint: 'Demo@123',
                              obscure: true,
                            ),
                            LabeledTextField(
                              label: 'Confirm Password',
                              controller: _confirmPasswordController,
                              hint: 'Demo@123',
                              obscure: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AuthFormGrid(
                          columnsOverride: 3,
                          children: [
                            _UploadField(
                              label: 'Upload Photo (Agency Owner) *',
                              file: _ownerImage,
                              onPick: () => _pickFile((f) => _ownerImage = f),
                            ),
                            _UploadField(
                              label: 'Upload NID (With Both Side) *',
                              file: _nidImage,
                              onPick: () => _pickFile((f) => _nidImage = f),
                            ),
                            _UploadField(
                              label: 'Upload Trade License *',
                              file: _tradeLicenseImage,
                              onPick: () =>
                                  _pickFile((f) => _tradeLicenseImage = f),
                            ),
                            _UploadField(
                              label: 'Upload Recruiting License (RL) *',
                              file: _rlLicenseImage,
                              onPick: () =>
                                  _pickFile((f) => _rlLicenseImage = f),
                            ),
                            _UploadField(
                              label: 'Upload Civil Aviation License (Optional)',
                              file: _civilAviationLicenseImage,
                              onPick: () => _pickFile(
                                (f) => _civilAviationLicenseImage = f,
                              ),
                            ),
                          ],
                        ),
                        CheckboxListTile(
                          value: _agreeTerms,
                          onChanged: (v) =>
                              setState(() => _agreeTerms = v ?? false),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'By continue, I agree to the website Privacy Policy and Terms & Conditions.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_loading || _locationsLoading)
                                ? null
                                : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Create Account'),
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

class _UploadField extends StatelessWidget {
  const _UploadField({
    required this.label,
    required this.file,
    required this.onPick,
  });

  final String label;
  final XFile? file;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFF8FAFC),
            ),
            child: Text(
              file == null ? 'Choose file' : file!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: file == null
                    ? const Color(0xFF64748B)
                    : const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
        if (file != null) ...[
          const SizedBox(height: 8),
          _SelectedImagePreview(file: file!),
        ],
      ],
    );
  }
}

class _SelectedImagePreview extends StatelessWidget {
  const _SelectedImagePreview({required this.file});

  final XFile file;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 112,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final bytes = snapshot.data;
        if (bytes == null || bytes.isEmpty) {
          return Container(
            height: 112,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF8FAFC),
            ),
            child: const Text(
              'Preview unavailable',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: 112,
            color: const Color(0xFFE2E8F0),
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
