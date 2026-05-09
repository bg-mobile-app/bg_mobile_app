import 'package:flutter/material.dart';

class HeaderActionButton extends StatelessWidget {
  const HeaderActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.brandBlue,
  });

  final String label;
  final VoidCallback onTap;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: brandBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}


class AppBrandHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBrandHeader({
    super.key,
    required this.brandBlue,
    required this.isLoggedIn,
    required this.onSignIn,
    required this.onSignUp,
    required this.onNotifications,
    required this.onProfile,
    this.backgroundColor = const Color(0xFFF5F8FF),
  });

  final Color brandBlue;
  final bool isLoggedIn;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      titleSpacing: 16,
      title: Image.asset('assets/img/logo/logo_black.png', height: 32, fit: BoxFit.contain),
      actions: [
        if (isLoggedIn) ...[
          IconButton(onPressed: onNotifications, icon: const Icon(Icons.notifications_none, color: Colors.black87), tooltip: 'Notifications'),
          IconButton(onPressed: onProfile, icon: const Icon(Icons.person_outline, color: Colors.black87), tooltip: 'Profile'),
        ] else ...[
          HeaderActionButton(label: 'Sign In', onTap: onSignIn, brandBlue: brandBlue),
          const SizedBox(width: 8),
          HeaderActionButton(label: 'Sign Up', onTap: onSignUp, brandBlue: brandBlue),
        ],
        const SizedBox(width: 16),
      ],
    );
  }
}
