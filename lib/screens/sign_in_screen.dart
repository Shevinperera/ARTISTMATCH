// ─────────────────────────────────────────────
//  sign_in_screen.dart  —  ArtistMatch
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:artistmatch/main.dart';   // MainNavScreen
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() { _emailCtrl.dispose(); _passwordCtrl.dispose(); super.dispose(); }

  // Replace the entire stack so the user can't go back to Sign In
  void _goHome() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
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
            const SizedBox(height: 24),
            const Text('Create an account or login to start',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, height: 1.50)),
            const SizedBox(height: 2),
            const Text('Enter your email',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
            const SizedBox(height: 16),
            AMInput(controller: _emailCtrl, hint: 'email@domain.com'),
            const SizedBox(height: 16),
            AMInput(controller: _passwordCtrl, hint: 'password', obscure: true),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                child: const Text('forgot password?',
                    style: TextStyle(color: Color(0xFF4285F4), fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w500, height: 1.40)),
              ),
            ),
            const SizedBox(height: 16),
            AMBlueBtn(label: 'Continue', onTap: _goHome),
            const SizedBox(height: 16),
            const AMDivider(),
            const SizedBox(height: 16),
            AMSocialBtn(label: 'Continue with Google', icon: Icons.g_mobiledata, iconColor: const Color(0xFFDB4437), onTap: _goHome),
            const SizedBox(height: 12),
            AMSocialBtn(label: 'Continue with Apple', icon: Icons.apple, iconColor: Colors.black, onTap: _goHome),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen())),
              child: const Text.rich(TextSpan(children: [
                TextSpan(text: "Don't have an account? ",
                    style: TextStyle(color: Color(0xFF828282), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
                TextSpan(text: 'Sign up',
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

// ════════════════════════════════════════════════════════
//  SHARED AUTH WIDGETS  (used by all auth screens)
//  Exported so sign_up, forgot_pw etc. can import them.
// ════════════════════════════════════════════════════════

class AMInput extends StatelessWidget {
  const AMInput({super.key, required this.controller, required this.hint, this.obscure = false});
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, height: 40,
    decoration: ShapeDecoration(color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFDFDFDF)),
        borderRadius: BorderRadius.circular(8))),
    child: TextField(
      controller: controller, obscureText: obscure,
      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF828282), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.40),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: InputBorder.none),
    ),
  );
}

class AMBlueBtn extends StatelessWidget {
  const AMBlueBtn({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 40,
      decoration: ShapeDecoration(color: const Color(0xFF0094FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Center(child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w500, height: 1.40))),
    ),
  );
}

class AMSocialBtn extends StatelessWidget {
  const AMSocialBtn({super.key, required this.label, required this.icon, required this.iconColor, required this.onTap});
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 40,
      decoration: ShapeDecoration(color: const Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Color(0xFF828282), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w500, height: 1.40)),
      ]),
    ),
  );
}

class AMDivider extends StatelessWidget {
  const AMDivider({super.key});
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Container(height: 1, color: const Color(0xFFE6E6E6))),
    const Padding(padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('or', style: TextStyle(color: Color(0xFF828282), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.40))),
    Expanded(child: Container(height: 1, color: const Color(0xFFE6E6E6))),
  ]);
}

class AMTerms extends StatelessWidget {
  const AMTerms({super.key});
  @override
  Widget build(BuildContext context) => const Text.rich(
    TextSpan(children: [
      TextSpan(text: 'By clicking continue, you agree to our ',
          style: TextStyle(color: Color(0xFF828282), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
      TextSpan(text: 'Terms of Service',
          style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
      TextSpan(text: ' and ',
          style: TextStyle(color: Color(0xFF828282), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
      TextSpan(text: 'Privacy Policy',
          style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
    ]),
    textAlign: TextAlign.center,
  );
}
