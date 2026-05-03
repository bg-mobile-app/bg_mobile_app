import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  static const Color _brandBlue = Color(0xFF2563EB);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 768;
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 56),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Form(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isDesktop)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  'assets/img/sign-in/login.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 14,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _buildLoginCard(),
                          ),
                        ),
                      ],
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

  Widget _buildLoginCard() {
    return Column(
      children: [
        Image.asset(
          'assets/img/logo/logo_black.png',
          width: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        const Text(
          'Login to your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Welcome Back to Bideshgami! Please Enter Your Login Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        _buildUnderlineInput(
          controller: _usernameController,
          hintText: 'Enter your username or phone',
          autofocus: true,
        ),
        const SizedBox(height: 20),
        _buildPasswordField(),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF334155),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Forgot Password'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Didn\'t have an account? '),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: _brandBlue,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Sign Up!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnderlineInput({
    required TextEditingController controller,
    required String hintText,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF64748B)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF64748B)),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF64748B)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Enter your password',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showPassword = !_showPassword),
            icon: Icon(
              _showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF475569),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
