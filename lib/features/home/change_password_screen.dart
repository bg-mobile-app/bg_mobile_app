import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../common/theme/app_palette.dart';
import '../../common/theme/app_text_styles.dart';
import 'dashboard_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully')));
      _formKey.currentState!.reset();
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to change password')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/customer/change-password',
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _breadcrumb(),
                const SizedBox(height: 8),
                Text('Change Password', style: AppTextStyles.headline2.copyWith(fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Keep your account secure by setting a strong password.', style: AppTextStyles.body2.copyWith(color: AppPalette.textMuted)),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppPalette.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppPalette.borderSoftBlue),
                    boxShadow: AppPalette.cardShadow,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _passwordField(
                              label: 'Old Password',
                              controller: _oldPasswordController,
                              visible: _showOldPassword,
                              onVisibility: () => setState(() => _showOldPassword = !_showOldPassword),
                            ),
                            const SizedBox(height: 14),
                            _passwordField(
                              label: 'New Password',
                              controller: _newPasswordController,
                              visible: _showNewPassword,
                              onVisibility: () => setState(() => _showNewPassword = !_showNewPassword),
                              minLength: 8,
                            ),
                            const SizedBox(height: 14),
                            _passwordField(
                              label: 'Confirm Password',
                              controller: _confirmPasswordController,
                              visible: _showConfirmPassword,
                              onVisibility: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                              minLength: 8,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'All fields are required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'New password and confirm password do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: _isLoading ? null : () => Navigator.maybePop(context),
                                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppPalette.borderSoftBlue)),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 12),
                                FilledButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: FilledButton.styleFrom(backgroundColor: AppPalette.brandBlue),
                                  child: Text(_isLoading ? 'Changing...' : 'Change Password'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumb() {
    return BreadCrumb(
      items: <BreadCrumbItem>[
        BreadCrumbItem(content: Text('Dashboard', style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted))),
        BreadCrumbItem(
          content: Text('Change Password', style: AppTextStyles.caption.copyWith(color: AppPalette.textStrongBlue, fontWeight: FontWeight.w700)),
        ),
      ],
      divider: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onVisibility,
    int minLength = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppPalette.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppPalette.borderSoftBlue)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppPalette.borderSoftBlue)),
        suffixIcon: IconButton(
          onPressed: onVisibility,
          icon: Icon(visible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'All fields are required';
            }
            if (value.length < minLength) {
              return 'Password must be at least 8 characters long';
            }
            return null;
          },
    );
  }
}
