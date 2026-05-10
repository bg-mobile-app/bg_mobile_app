import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';

class AgencySignUpScreen extends StatelessWidget {
  const AgencySignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Agency Sign Up')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  return GridView.count(
                    crossAxisCount: isWide ? 3 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isWide ? 0.9 : 1.25,
                    children: const [
                      _AgencyTypeCard(
                        title: 'Recruiting Agency',
                        imagePath: 'assets/img/sign-up/recurting.jpg',
                        onTapRoute: AppRoutes.recruitingSignUp,
                      ),
                      _AgencyTypeCard(
                        title: 'Hajj & Umrah Agency',
                        imagePath: 'assets/img/sign-up/hajj.jpg',
                      ),
                      _AgencyTypeCard(
                        title: 'Student Consultancy',
                        imagePath: 'assets/img/sign-up/student.jpg',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgencyTypeCard extends StatelessWidget {
  const _AgencyTypeCard({
    required this.title,
    required this.imagePath,
    this.onTapRoute,
  });

  final String title;
  final String imagePath;
  final String? onTapRoute;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapRoute == null
          ? null
          : () => context.push(onTapRoute!),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xBFDDE5F1),
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            bottom: BorderSide(color: Color(0xFF94A3B8), width: 8),
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
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
