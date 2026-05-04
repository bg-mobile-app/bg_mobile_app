import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class PartnerSignUpScreen extends StatelessWidget {
  const PartnerSignUpScreen({super.key});

  static const Color _brandBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'Welcome to '),
                        TextSpan(
                          text: 'Bideshgami',
                          style: TextStyle(color: _brandBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select the type of account you want to create',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 700;
                      return GridView.count(
                        crossAxisCount: isWide ? 2 : 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: isWide ? 1 : 1.2,
                        children: const [
                          _AccountTypeCard(
                            label: 'Agent',
                            imagePath: 'assets/img/sign-up/merchent.jpg',
                            onTapRoute: AppRoutes.agentSignUp,
                          ),
                          _AccountTypeCard(
                            label: 'Agency',
                            imagePath: 'assets/img/sign-up/agency.jpg',
                            onTapRoute: AppRoutes.agencySignUp,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Already have an account? Login here',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({
    required this.label,
    required this.imagePath,
    this.onTapRoute,
  });

  final String label;
  final String imagePath;
  final String? onTapRoute;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapRoute == null
          ? null
          : () => Navigator.of(context).pushNamed(onTapRoute!),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xBFDDE5F1),
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            bottom: BorderSide(color: Color(0xFF94A3B8), width: 6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
