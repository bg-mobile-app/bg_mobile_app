import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/services/api_exception.dart';
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

  int _currentStep = 0;

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
  final _otpController = TextEditingController();

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
      _otpController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadDistricts() async {
    setState(() => _locationsLoading = true);
    try {
      final districts = await _locationService.getDistricts();
      if (!mounted) return;
      setState(() {
        _districts = districts;
        _locationsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationsLoading = false);
    }
  }

  Future<void> _loadPoliceStations(int districtId) async {
    setState(() {
      _policeStations = [];
      _selectedPoliceStation = null;
      _locationsLoading = true;
    });

    try {
      final stations = await _locationService.getPoliceStations(districtId);
      if (!mounted) return;
      setState(() {
        _policeStations = stations;
        _locationsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationsLoading = false);
    }
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

  bool _validateCurrentStep() {
    // Step 0: Agency Info
    if (_currentStep == 0) {
      if (_fullNameController.text.isEmpty ||
          _gender == null ||
          _agencyNameController.text.isEmpty ||
          _rlNoController.text.isEmpty ||
          _selectedDistrict == null ||
          _selectedPoliceStation == null ||
          _agencyAddressController.text.isEmpty) {
        _showError('Please fill all required fields in this step.');
        return false;
      }
    }
    // Step 1: Contact Info
    else if (_currentStep == 1) {
      if (_agencyPhoneController.text.isEmpty ||
          _ownerContactNumberController.text.isEmpty ||
          _designationController.text.isEmpty) {
        _showError('Please fill all required fields in this step.');
        return false;
      }
    }
    // Step 2: Login Info
    else if (_currentStep == 2) {
      if (_phoneController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        _showError('Please fill all required fields in this step.');
        return false;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError('Password and confirm password do not match.');
        return false;
      }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 4) {
      _verifyOtp();
      return;
    }

    if (_validateCurrentStep()) {
      if (_currentStep < 3) {
        setState(() => _currentStep += 1);
      } else if (_currentStep == 3) {
        _submit();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      _showError('Please agree to Privacy Policy and Terms.');
      return;
    }

    if (_ownerImage == null ||
        _nidImage == null ||
        _tradeLicenseImage == null ||
        _rlLicenseImage == null) {
      _showError('Please upload all required files.');
      return;
    }

    final rlNo = int.tryParse(_rlNoController.text.trim());
    if (rlNo == null) {
      _showError('Please enter a valid agency RL no.');
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
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _currentStep = 4;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } on DioException catch (e) {
      debugPrint('--- DIO EXCEPTION DURING SIGN UP ---');
      debugPrint('Status Code: ${e.response?.statusCode}');
      debugPrint('Response Data: ${e.response?.data}');
      debugPrint('------------------------------------');

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
      _showError(message);
    } catch (e, stackTrace) {
      debugPrint('--- UNKNOWN EXCEPTION DURING SIGN UP ---');
      debugPrint('Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      debugPrint('----------------------------------------');

      if (!mounted) return;
      _showError('Registration failed. Please try again.');
    } finally {
      if (mounted && _currentStep != 4) setState(() => _loading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _showError('Please enter the OTP.');
      return;
    }
    setState(() => _loading = true);
    try {
      await _authService.verifyOtp(
        username: _emailController.text.trim(),
        otp: otp,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Verified Successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go(AppRoutes.agentSignUpThankYou);
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('Invalid OTP. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _loading = true);
    try {
      await _authService.resendOtp(username: _emailController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Resent Successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to resend OTP.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? const Color(0xFF2563EB)
                      : Colors.grey.shade300,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (index < 4)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: index < _currentStep
                        ? const Color(0xFF2563EB)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agency Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Provide basic details about your agency and its location.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        AuthFormGrid(
          children: [
            LabeledTextField(
              label: 'Enter Full Name (Agency Owner) *',
              controller: _fullNameController,
              hint: 'John Doe',
            ),
            LabeledDropdownField(
              label: 'Select Gender (Agency Owner) *',
              value: _gender,
              items: _genderOptions,
              onChanged: (v) => setState(() => _gender = v),
            ),
            LabeledTextField(
              label: 'Enter Agency Name *',
              controller: _agencyNameController,
              hint: 'xyz Company',
            ),
            LabeledTextField(
              label: 'Enter Agency RL No *',
              controller: _rlNoController,
              hint: 'RL Number',
              keyboardType: TextInputType.number,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Agency District *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Agency Police Station *',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<PoliceStationOption>(
                  initialValue: _selectedPoliceStation,
                  isExpanded: true,
                  items: _policeStations
                      .map(
                        (p) => DropdownMenuItem<PoliceStationOption>(
                          value: p,
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                  onChanged: (_selectedDistrict == null || _locationsLoading)
                      ? null
                      : (p) => setState(() => _selectedPoliceStation = p),
                  decoration: InputDecoration(
                    hintText: _selectedDistrict == null
                        ? 'Select district first'
                        : 'Select police station',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
            LabeledTextField(
              label: 'Enter Agency Full Address *',
              controller: _agencyAddressController,
              hint: 'Type agency address here...',
              maxLines: 3,
              spanTwoColumns: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'How can we reach the agency and the owner?',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        AuthFormGrid(
          children: [
            LabeledTextField(
              label: 'Enter Contact Number (Agency) *',
              controller: _agencyPhoneController,
              hint: '01*********',
              keyboardType: TextInputType.phone,
            ),
            LabeledTextField(
              label: 'Enter Contact Number (Owner) *',
              controller: _ownerContactNumberController,
              hint: '018********',
              keyboardType: TextInputType.phone,
            ),
            LabeledTextField(
              label: 'Enter Your Designation *',
              controller: _designationController,
              hint: 'Proprietor',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Login Credentials',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Set up your account login details.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        AuthFormGrid(
          children: [
            LabeledTextField(
              label: 'Enter Your Phone Number *',
              controller: _phoneController,
              hint: '017XXXXXXXX',
              keyboardType: TextInputType.phone,
            ),
            LabeledTextField(
              label: 'Enter Your E-mail *',
              controller: _emailController,
              hint: 'example@mail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            LabeledTextField(
              label: 'Enter Your Password *',
              controller: _passwordController,
              hint: 'Demo@123',
              obscure: true,
            ),
            LabeledTextField(
              label: 'Confirm Password *',
              controller: _confirmPasswordController,
              hint: 'Demo@123',
              obscure: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Documents & Verification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload required documents to verify your agency.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        AuthFormGrid(
          columnsOverride: 2,
          children: [
            _PremiumUploadField(
              label: 'Upload Photo (Owner) *',
              file: _ownerImage,
              onPick: () => _pickFile((f) => _ownerImage = f),
            ),
            _PremiumUploadField(
              label: 'Upload NID (Both Side) *',
              file: _nidImage,
              onPick: () => _pickFile((f) => _nidImage = f),
            ),
            _PremiumUploadField(
              label: 'Upload Trade License *',
              file: _tradeLicenseImage,
              onPick: () => _pickFile((f) => _tradeLicenseImage = f),
            ),
            _PremiumUploadField(
              label: 'Upload RL License *',
              file: _rlLicenseImage,
              onPick: () => _pickFile((f) => _rlLicenseImage = f),
            ),
            _PremiumUploadField(
              label: 'Civil Aviation License (Optional)',
              file: _civilAviationLicenseImage,
              onPick: () => _pickFile((f) => _civilAviationLicenseImage = f),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: CheckboxListTile(
            value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: const Color(0xFF2563EB),
            title: const Text(
              'I agree to the Privacy Policy and Terms & Conditions.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OTP Verification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please enter the OTP sent to ${_emailController.text.trim()}',
          style: const TextStyle(color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        AuthFormGrid(
          children: [
            LabeledTextField(
              label: 'Enter OTP *',
              controller: _otpController,
              hint: '123456',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _loading ? null : _resendOtp,
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentStepContent;
    switch (_currentStep) {
      case 0:
        currentStepContent = _buildStep0();
        break;
      case 1:
        currentStepContent = _buildStep1();
        break;
      case 2:
        currentStepContent = _buildStep2();
        break;
      case 3:
        currentStepContent = _buildStep3();
        break;
      case 4:
        currentStepContent = _buildStep4();
        break;
      default:
        currentStepContent = _buildStep0();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_agencyTitle Sign Up',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.05, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                          child: KeyedSubtree(
                            key: ValueKey<int>(_currentStep),
                            child: currentStepContent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        ElevatedButton(
                          onPressed: (_loading || _locationsLoading)
                              ? null
                              : _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _currentStep >= 3
                                      ? (_currentStep == 4
                                            ? 'Verify OTP'
                                            : 'Create Account')
                                      : 'Next Step',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumUploadField extends StatelessWidget {
  const _PremiumUploadField({
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
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: file == null
                  ? const Color(0xFFF8FAFC)
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: file == null
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFFBFDBFE),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  file == null
                      ? Icons.cloud_upload_outlined
                      : Icons.check_circle,
                  color: file == null
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF3B82F6),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  file == null ? 'Tap to upload file' : file!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: file == null
                        ? const Color(0xFF64748B)
                        : const Color(0xFF1D4ED8),
                    fontWeight: file == null
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (file != null) ...[
          const SizedBox(height: 12),
          _PremiumSelectedImagePreview(file: file!),
        ],
      ],
    );
  }
}

class _PremiumSelectedImagePreview extends StatelessWidget {
  const _PremiumSelectedImagePreview({required this.file});

  final XFile file;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final bytes = snapshot.data;
        if (bytes == null || bytes.isEmpty) {
          return const SizedBox.shrink();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
              ],
            ),
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
