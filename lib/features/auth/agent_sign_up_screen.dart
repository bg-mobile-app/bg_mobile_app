import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/services/auth_service.dart';
import '../../common/services/location_service.dart';
import '../../routes/app_routes.dart';
import '../policy/policy_screen.dart';

class AgentSignUpScreen extends StatefulWidget {
  const AgentSignUpScreen({super.key});

  @override
  State<AgentSignUpScreen> createState() => _AgentSignUpScreenState();
}

class _AgentSignUpScreenState extends State<AgentSignUpScreen> {
  static const Color _brandBlue = Color(0xFF2563EB);
  static const Color _brandNavy = Color(0xFF0F172A);

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _locationService = LocationService();
  final _picker = ImagePicker();

  final _fullNameController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _agencyAddressController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _agencyNameFocus = FocusNode();
  final _agencyAddressFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  Map<String, String> _fieldErrors = {};

  String? _gender;
  DistrictOption? _selectedDistrict;
  PoliceStationOption? _selectedPoliceStation;

  List<DistrictOption> _districts = const [];
  List<PoliceStationOption> _policeStations = const [];

  XFile? _profileImage;
  XFile? _nidImage;
  XFile? _tradeLicenseImage;

  bool _agreeTerms = false;
  bool _loading = false;
  bool _locationsLoading = false;

  final List<String> _genderOptions = const ['MALE', 'FEMALE', 'OTHER'];

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

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
    _fullNameFocus.dispose();
    _agencyNameFocus.dispose();
    _agencyAddressFocus.dispose();
    _addressFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _refreshFormData() async {
    await _loadDistricts();
  }

  Future<void> _loadDistricts() async {
    setState(() => _locationsLoading = true);
    final districts = await _locationService.getDistricts();
    if (!mounted) return;
    setState(() {
      _districts = districts;
      if (_selectedDistrict != null) {
        final exists = _districts.any((d) => d.id == _selectedDistrict!.id);
        if (!exists) {
          _selectedDistrict = null;
          _selectedPoliceStation = null;
          _policeStations = [];
        }
      }
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
    debugPrint('╔══════════════════════════════════════════════════════');
    debugPrint('║ [SIGNUP] _submit() called');
    debugPrint('╠══════════════════════════════════════════════════════');
    debugPrint('║  fullName       = "${_fullNameController.text.trim()}"');
    debugPrint('║  email          = "${_emailController.text.trim()}"');
    debugPrint('║  phone          = "${_phoneController.text.trim()}"');
    debugPrint('║  gender         = "$_gender"');
    debugPrint('║  agencyName     = "${_agencyNameController.text.trim()}"');
    debugPrint('║  agencyAddress  = "${_agencyAddressController.text.trim()}"');
    debugPrint('║  address        = "${_addressController.text.trim()}"');
    debugPrint('║  district       = ${_selectedDistrict?.name} (id=${_selectedDistrict?.id})');
    debugPrint('║  policeStation  = ${_selectedPoliceStation?.name} (id=${_selectedPoliceStation?.id})');
    debugPrint('║  profileImage   = ${_profileImage?.name ?? "NULL ❌"}');
    debugPrint('║  nidImage       = ${_nidImage?.name ?? "NULL ❌"}');
    debugPrint('║  tradeLicense   = ${_tradeLicenseImage?.name ?? "not provided (optional)"}');
    debugPrint('║  agreeTerms     = $_agreeTerms');
    debugPrint('║  passwordMatch  = ${_passwordController.text == _confirmPasswordController.text}');
    debugPrint('╚══════════════════════════════════════════════════════');

    // ── Step 1: Form validation ─────────────────────────────────────────
    final formValid = _formKey.currentState!.validate();
    debugPrint('[SIGNUP] Step 1 — Form validation: ${formValid ? "✅ PASSED" : "❌ FAILED"}');
    if (!formValid) {
      debugPrint('[SIGNUP]   → form has invalid fields, aborting');
      return;
    }

    // ── Step 2: Terms check ─────────────────────────────────────────────
    debugPrint('[SIGNUP] Step 2 — Terms agreed: ${_agreeTerms ? "✅" : "❌"}');
    if (!_agreeTerms) {
      debugPrint('[SIGNUP]   → User has not agreed to terms, aborting');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Privacy Policy and Terms.'),
        ),
      );
      return;
    }

    // ── Step 3: District & Police Station check ─────────────────────────
    debugPrint('[SIGNUP] Step 3 — District: ${_selectedDistrict == null ? "❌ NULL" : "✅ ${_selectedDistrict!.name}"}');
    debugPrint('[SIGNUP]           Police Station: ${_selectedPoliceStation == null ? "❌ NULL" : "✅ ${_selectedPoliceStation!.name}"}');
    if (_selectedDistrict == null || _selectedPoliceStation == null) {
      debugPrint('[SIGNUP]   → Missing district or police station, aborting');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select district and police station.'),
        ),
      );
      return;
    }

    // ── Step 4: Password match check ────────────────────────────────────
    final passwordsMatch = _passwordController.text == _confirmPasswordController.text;
    debugPrint('[SIGNUP] Step 4 — Passwords match: ${passwordsMatch ? "✅" : "❌"}');
    if (!passwordsMatch) {
      debugPrint('[SIGNUP]   → Passwords do not match, aborting');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and confirm password do not match.'),
        ),
      );
      return;
    }

    // ── Step 5: Required file uploads check ─────────────────────────────
    debugPrint('[SIGNUP] Step 5 — profileImage: ${_profileImage == null ? "❌ NULL" : "✅ ${_profileImage!.name}"}');
    debugPrint('[SIGNUP]           nidImage:     ${_nidImage == null ? "❌ NULL" : "✅ ${_nidImage!.name}"}');
    debugPrint('[SIGNUP]           tradeLicense: ${_tradeLicenseImage == null ? "⚠️ not provided (optional)" : "✅ ${_tradeLicenseImage!.name}"}');
    if (_profileImage == null || _nidImage == null) {
      debugPrint('[SIGNUP]   → Missing required upload(s), aborting');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload photo and NID.'),
        ),
      );
      return;
    }

    debugPrint('[SIGNUP] ✅ All pre-flight checks passed — building payload...');
    setState(() {
      _loading = true;
      _fieldErrors.clear();
    });

    try {
      // ── Step 6: Build multipart payload ───────────────────────────────
      debugPrint('[SIGNUP] Step 6 — Converting images to multipart...');
      final profileMp = await _toMultipart(_profileImage!);
      final nidMp = await _toMultipart(_nidImage!);
      debugPrint('[SIGNUP]   profileImage multipart: ${profileMp.filename}');
      debugPrint('[SIGNUP]   nidImage multipart:     ${nidMp.filename}');

      final payload = <String, dynamic>{
        'fullName': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'isPrivacyTerms': _agreeTerms ? 'true' : 'false',
        'gender': _gender,
        'agencyName': _agencyNameController.text.trim(),
        'agencyAddress': _agencyAddressController.text.trim(),
        'address': _addressController.text.trim(),
        'district': _selectedDistrict!.id.toString(),
        'policeStation': _selectedPoliceStation!.id.toString(),
        'image': profileMp,
        'nid_image': nidMp,
      };

      if (_tradeLicenseImage != null) {
        final tradeMp = await _toMultipart(_tradeLicenseImage!);
        payload['trade_license_image'] = tradeMp;
        debugPrint('[SIGNUP]   tradeLicense multipart: ${tradeMp.filename}');
      } else {
        debugPrint('[SIGNUP]   tradeLicense: skipped (optional, not provided)');
      }

      debugPrint('╔══════════════════════════════════════════════════════');
      debugPrint('║ [SIGNUP] Step 7 — Payload summary (no passwords):');
      payload.forEach((key, value) {
        if (key != 'password') {
          debugPrint('║  $key = ${value is MultipartFile ? "[MultipartFile: ${value.filename}]" : value}');
        }
      });
      debugPrint('╚══════════════════════════════════════════════════════');

      final formData = FormData.fromMap(payload);
      debugPrint('[SIGNUP] Step 7 — Calling AuthService.registerAgent()...');

      final response = await _authService.registerAgent(formData);

      debugPrint('╔══════════════════════════════════════════════════════');
      debugPrint('║ [SIGNUP] ✅ registerAgent() succeeded!');
      debugPrint('║  statusCode = ${response.statusCode}');
      debugPrint('║  data       = ${response.data}');
      debugPrint('╚══════════════════════════════════════════════════════');

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
      debugPrint('╔══════════════════════════════════════════════════════');
      debugPrint('║ [SIGNUP] ❌ DioException caught');
      debugPrint('║  type           = ${e.type}');
      debugPrint('║  statusCode     = ${e.response?.statusCode}');
      debugPrint('║  message        = ${e.message}');
      debugPrint('║  requestPath    = ${e.requestOptions.path}');
      debugPrint('║  requestMethod  = ${e.requestOptions.method}');
      debugPrint('║  response.data  = ${e.response?.data}');
      debugPrint('║  response.headers = ${e.response?.headers}');
      debugPrint('╚══════════════════════════════════════════════════════');

      if (!mounted) return;
      String message = 'Registration failed. Please try again.';
      final data = e.response?.data;
      if (data is Map) {
        debugPrint('[SIGNUP]   response data is Map — checking for field errors...');
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          debugPrint('[SIGNUP]   field errors found: $errors');
          setState(() {
            errors.forEach((key, value) {
              if (value is List) {
                _fieldErrors[key.toString()] = value.join(', ');
              } else {
                _fieldErrors[key.toString()] = value.toString();
              }
            });
          });
          debugPrint('[SIGNUP]   _fieldErrors set: $_fieldErrors');

          if (_fieldErrors.containsKey('fullName')) {
            _fullNameFocus.requestFocus();
          } else if (_fieldErrors.containsKey('email')) {
            _emailFocus.requestFocus();
          } else if (_fieldErrors.containsKey('phone')) {
            _phoneFocus.requestFocus();
          } else if (_fieldErrors.containsKey('password')) {
            _passwordFocus.requestFocus();
          } else if (_fieldErrors.containsKey('agencyName')) {
            _agencyNameFocus.requestFocus();
          } else if (_fieldErrors.containsKey('agencyAddress')) {
            _agencyAddressFocus.requestFocus();
          } else if (_fieldErrors.containsKey('address')) {
            _addressFocus.requestFocus();
          } else {
            message = _fieldErrors.values.first;
            debugPrint('[SIGNUP]   showing snackbar with: $message');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          }
          setState(() => _loading = false);
          return;
        } else if (data['detail'] != null) {
          message = data['detail'].toString();
          debugPrint('[SIGNUP]   detail error: $message');
        } else if (data['message'] != null) {
          message = data['message'].toString();
          debugPrint('[SIGNUP]   message error: $message');
        } else {
          message = data.toString();
          debugPrint('[SIGNUP]   raw data error: $message');
        }
      } else if (data is String) {
        message = data;
        debugPrint('[SIGNUP]   string error: $message');
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e, stack) {
      debugPrint('╔══════════════════════════════════════════════════════');
      debugPrint('║ [SIGNUP] ❌ Unexpected exception caught');
      debugPrint('║  error = $e');
      debugPrint('║  stack = $stack');
      debugPrint('╚══════════════════════════════════════════════════════');
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FBFF), Color(0xFFEEF4FF)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshFormData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Form(
                    key: _formKey,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth >= 980;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: _brandNavy,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Center(
                              child: Text(
                                'Create your agent account to continue.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Flex(
                              direction: isDesktop
                                  ? Axis.horizontal
                                  : Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(
                                  builder: (_) {
                                    final content = Column(
                                      children: [
                                        _sectionCard(
                                          icon: Icons.badge_outlined,
                                          title: 'Basic Information',
                                          subtitle:
                                              'Personal and agency details',
                                          child: _grid(
                                            children: [
                                              _textField(
                                                'Full Name',
                                                _fullNameController,
                                                hint: 'Enter your full name',
                                                focusNode: _fullNameFocus,
                                                errorText: _fieldErrors['fullName'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('fullName')),
                                              ),
                                              _dropdownField(
                                                label: 'Gender',
                                                value: _gender,
                                                items: _genderOptions,
                                                hint: 'Select gender',
                                                errorText: _fieldErrors['gender'],
                                                onChanged: (v) =>
                                                    setState(() {
                                                      _gender = v;
                                                      _fieldErrors.remove('gender');
                                                    }),
                                              ),
                                              _textField(
                                                'Agency Name',
                                                _agencyNameController,
                                                hint:
                                                    'Your registered business name',
                                                spanTwoColumns: true,
                                                focusNode: _agencyNameFocus,
                                                errorText: _fieldErrors['agencyName'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('agencyName')),
                                              ),
                                              _textField(
                                                'Agency Address',
                                                _agencyAddressController,
                                                hint:
                                                    'Business location details...',
                                                maxLines: 2,
                                                spanTwoColumns: true,
                                                focusNode: _agencyAddressFocus,
                                                errorText: _fieldErrors['agencyAddress'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('agencyAddress')),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _sectionCard(
                                          icon: Icons.location_on_outlined,
                                          title: 'Permanent Address',
                                          subtitle:
                                              'Where you are permanently located',
                                          child: _grid(
                                            children: [
                                              _districtDropdown(),
                                              _policeStationDropdown(),
                                              _textField(
                                                'Full Address',
                                                _addressController,
                                                hint:
                                                    'Street name, house number, etc.',
                                                maxLines: 3,
                                                spanTwoColumns: true,
                                                focusNode: _addressFocus,
                                                errorText: _fieldErrors['address'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('address')),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _sectionCard(
                                          icon: Icons.lock_open_outlined,
                                          title: 'Login Information',
                                          subtitle:
                                              'Credentials for your agent portal',
                                          child: _grid(
                                            children: [
                                              _textField(
                                                'Email Address',
                                                _emailController,
                                                hint: 'agent@company.com',
                                                focusNode: _emailFocus,
                                                errorText: _fieldErrors['email'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('email')),
                                              ),
                                              _textField(
                                                'Phone Number',
                                                _phoneController,
                                                hint: '+880 1XXX XXXXXX',
                                                focusNode: _phoneFocus,
                                                errorText: _fieldErrors['phone'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('phone')),
                                              ),
                                              _textField(
                                                'Password',
                                                _passwordController,
                                                hint: '••••••••',
                                                obscure: true,
                                                focusNode: _passwordFocus,
                                                errorText: _fieldErrors['password'],
                                                onChanged: (_) => setState(() => _fieldErrors.remove('password')),
                                              ),
                                              _textField(
                                                'Confirm Password',
                                                _confirmPasswordController,
                                                hint: '••••••••',
                                                obscure: true,
                                                focusNode: _confirmPasswordFocus,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                    return isDesktop
                                        ? Expanded(flex: 8, child: content)
                                        : content;
                                  },
                                ),
                                SizedBox(
                                  width: isDesktop ? 20 : 0,
                                  height: isDesktop ? 0 : 20,
                                ),
                                SizedBox(
                                  width: isDesktop ? 360 : double.infinity,
                                  child: _documentCard(),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
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

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _brandBlue.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _brandBlue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _brandNavy,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _documentCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Your Documents',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _brandNavy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Upload required documents and submit your registration.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 22),
          _UploadBox(
            label: 'Profile Photo',
            file: _profileImage,
            icon: Icons.add_a_photo_outlined,
            onTap: () => _pickFile((f) => _profileImage = f),
          ),
          const SizedBox(height: 14),
          _UploadBox(
            label: 'NID (Both Sides)',
            file: _nidImage,
            icon: Icons.badge_outlined,
            onTap: () => _pickFile((f) => _nidImage = f),
          ),
          const SizedBox(height: 14),
          _UploadBox(
            label: 'Trade License (Optional)',
            file: _tradeLicenseImage,
            icon: Icons.verified_user_outlined,
            onTap: () => _pickFile((f) => _tradeLicenseImage = f),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                activeColor: _brandBlue,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'By signing up, I agree to the ',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PolicyScreen(policyType: 'PRIVACY'),
                              ),
                            ),
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 13,
                                color: _brandBlue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PolicyScreen(policyType: 'TERMS'),
                              ),
                            ),
                            child: const Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                fontSize: 13,
                                color: _brandBlue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(_loading ? 'Creating...' : 'Create Agent Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 2 : 1;
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
    bool spanTwoColumns = false,
    FocusNode? focusNode,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          maxLines: maxLines,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _brandBlue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (errorText != null) return errorText;
            return (value == null || value.trim().isEmpty) ? 'Required' : null;
          },
        ),
      ],
    );
    return spanTwoColumns ? _SpanTwoColumn(field) : field;
  }

  void _showSearchableDialog<T>({
    required String title,
    required List<T> items,
    required String Function(T) getName,
    required ValueChanged<T> onSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final filtered = items.where((item) {
              return getName(item).toLowerCase().contains(query.toLowerCase());
            }).toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text('Select $title'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search $title...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (val) {
                        setStateDialog(() => query = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text('No results found'))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return ListTile(
                                  title: Text(getName(item)),
                                  onTap: () {
                                    onSelected(item);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _districtDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'District',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _locationsLoading
              ? null
              : () {
                  _showSearchableDialog<DistrictOption>(
                    title: 'District',
                    items: _districts,
                    getName: (d) => d.name,
                    onSelected: (v) {
                      setState(() {
                        _selectedDistrict = v;
                        _fieldErrors.remove('district');
                      });
                      _loadPoliceStations(v.id);
                    },
                  );
                },
          child: InputDecorator(
            decoration: _dropdownDecoration(
              'Select district',
              errorText: _fieldErrors['district'],
            ),
            isEmpty: _selectedDistrict == null,
            child: _selectedDistrict == null
                ? null
                : Text(
                    _selectedDistrict!.name,
                    style: const TextStyle(color: Colors.black),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _policeStationDropdown() {
    final enabled = _policeStations.isNotEmpty && !_locationsLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Police Station',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: !enabled
              ? null
              : () {
                  _showSearchableDialog<PoliceStationOption>(
                    title: 'Police Station',
                    items: _policeStations,
                    getName: (ps) => ps.name,
                    onSelected: (v) {
                      setState(() {
                        _selectedPoliceStation = v;
                        _fieldErrors.remove('policeStation');
                      });
                    },
                  );
                },
          child: InputDecorator(
            decoration: _dropdownDecoration(
              enabled ? 'Select police station' : 'Select district first',
              errorText: _fieldErrors['policeStation'],
            ),
            isEmpty: _selectedPoliceStation == null,
            child: _selectedPoliceStation == null
                ? null
                : Text(
                    _selectedPoliceStation!.name,
                    style: const TextStyle(color: Colors.black),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String hint = 'Select an option',
    String? errorText,
  }) {
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
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: _dropdownDecoration(hint, errorText: errorText),
          validator: (v) {
            if (errorText != null) return errorText;
            return (v == null || v.isEmpty) ? 'Required' : null;
          },
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration(String hint, {String? errorText}) => InputDecoration(
    hintText: hint,
    errorText: errorText,
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _brandBlue),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.label,
    required this.file,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final XFile? file;
  final IconData icon;
  final VoidCallback onTap;

  bool get _hasFile => file != null;

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
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _hasFile
                    ? _AgentSignUpScreenState._brandBlue
                    : const Color(0xFFCBD5E1),
                style: BorderStyle.solid,
                width: 1.4,
              ),
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFFF8FAFC),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _hasFile ? Icons.check_circle : icon,
                      size: 18,
                      color: _hasFile
                          ? _AgentSignUpScreenState._brandBlue
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        file?.name ?? 'Tap to upload',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _hasFile
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF64748B),
                          fontWeight: _hasFile ? FontWeight.w600 : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hasFile ? 'Change' : 'Browse',
                      style: TextStyle(
                        color: _hasFile
                            ? _AgentSignUpScreenState._brandBlue
                            : const Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (_hasFile) ...[
                  const SizedBox(height: 12),
                  _SelectedImagePreview(file: file!),
                ],
              ],
            ),
          ),
        ),
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
            height: 120,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final bytes = snapshot.data;
        if (bytes == null || bytes.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'Preview unavailable',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 140,
            color: const Color(0xFFE2E8F0),
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}

class _SpanTwoColumn extends StatelessWidget {
  const _SpanTwoColumn(this.child);
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}
