// ─────────────────────────────────────────────
//  sign_up_screen.dart  —  ArtistMatch
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'static_nav.dart';
import 'login_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  void _goHome() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.90),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 45),
            Image.asset('assets/AM_logo.png', width: 144, height: 107, fit: BoxFit.fill),
            const SizedBox(height: 16),
            const Text('create your ArtistMatch Account',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, height: 1.50)),
            const SizedBox(height: 16),
            AMInput(controller: _nameCtrl, hint: 'Name'),
            const SizedBox(height: 16),
            AMInput(controller: _emailCtrl, hint: 'email@domain.com'),
            const SizedBox(height: 16),
            AMInput(controller: _passCtrl, hint: 'Password', obscure: true),
            const SizedBox(height: 16),
            AMInput(controller: _confirmCtrl, hint: 'confirm password', obscure: true),
            const SizedBox(height: 16),
            AMBlueBtn(label: 'Sign up', onTap: _goHome),
            const SizedBox(height: 16),
            const AMDivider(),
            const SizedBox(height: 16),
            AMSocialBtn(label: 'Continue with Google', icon: Icons.g_mobiledata, iconColor: const Color(0xFFDB4437), onTap: _goHome),
            const SizedBox(height: 12),
            AMSocialBtn(label: 'Continue with Apple', icon: Icons.apple, iconColor: Colors.black, onTap: _goHome),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SignInScreen())),
              child: const Text.rich(TextSpan(children: [
                TextSpan(text: 'already have an account? ',
                    style: TextStyle(color: Color(0xFF828282), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
                TextSpan(text: 'Sign in',
                    style: TextStyle(color: Color(0xFF4285F4), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
              ])),
            ),
            const SizedBox(height: 12),
            const AMTerms(),
            const SizedBox(height: 20),
            Image.asset('assets/AM_logo2.png', width: 153, height: 36, fit: BoxFit.fill),
            const SizedBox(height: 16),
            Container(width: 134, height: 5,
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(100))),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }
}
