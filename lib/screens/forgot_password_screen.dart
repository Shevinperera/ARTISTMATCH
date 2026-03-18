// ─────────────────────────────────────────────
//  forgot_password_screen.dart  —  ArtistMatch
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';   // AMInput, AMBlueBtn
import 'verify_account_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.90),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Image.asset('assets/AM_logo.png', width: 144, height: 107, fit: BoxFit.fill),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Text('Forgot your password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, height: 1.50)),
              const SizedBox(height: 2),
              const Text('Enter your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.50)),
              const SizedBox(height: 24),
              AMInput(controller: _emailCtrl, hint: 'email@domain.com'),
              const SizedBox(height: 16),
              AMBlueBtn(
                label: 'Continue',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const VerifyAccountScreen())),
              ),
            ]),
          ),
          const Spacer(),
          const _QwertyKeyboard(),
          Container(width: 134, height: 5,
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(100))),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ─── QWERTY Keyboard ─────────────────────────────────────────────────────────

class _QwertyKeyboard extends StatelessWidget {
  const _QwertyKeyboard();
  static const _row1 = ['q','w','e','r','t','y','u','i','o','p'];
  static const _row2 = ['a','s','d','f','g','h','j','k','l'];
  static const _row3 = ['z','x','c','v','b','n','m'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 0),
      decoration: const BoxDecoration(
        color: Color(0xFFE6E9ED),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10),
          bottomLeft: Radius.circular(62), bottomRight: Radius.circular(62),
        ),
      ),
      child: Column(spacing: 11, children: [
        Row(spacing: 6, children: _row1.map((k) => Expanded(child: _QKey(k))).toList()),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(spacing: 6, children: _row2.map((k) => Expanded(child: _QKey(k))).toList())),
        Row(spacing: 0, children: [
          _QFnKey(child: const Icon(Icons.arrow_upward, color: Color(0xFF595959), size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Row(spacing: 6, children: _row3.map((k) => Expanded(child: _QKey(k))).toList())),
          const SizedBox(width: 14),
          _QFnKey(child: const Icon(Icons.backspace_outlined, color: Color(0xFF595959), size: 18)),
        ]),
        Row(spacing: 6, children: [
          Container(width: 91, height: 45,
              decoration: ShapeDecoration(color: const Color(0xFF333333),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))),
              child: const Center(child: Text('ABC', style: TextStyle(color: Color(0xFF595959), fontSize: 16, fontFamily: 'Inter')))),
          Expanded(child: Container(height: 45,
              decoration: ShapeDecoration(color: const Color(0xFF333333),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))))),
          Container(width: 92, height: 45,
              decoration: ShapeDecoration(color: const Color(0xFF0088FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))),
              child: const Center(child: Icon(Icons.keyboard_return, color: Colors.white, size: 20))),
        ]),
        const SizedBox(height: 12),
      ]),
    );
  }
}

class _QKey extends StatelessWidget {
  const _QKey(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    height: 45,
    decoration: ShapeDecoration(color: const Color(0xFF333333),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))),
    child: Center(child: Text(label,
        style: const TextStyle(color: Color(0xFF595959), fontSize: 22, fontFamily: 'Inter'))),
  );
}

class _QFnKey extends StatelessWidget {
  const _QFnKey({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: 44, height: 45,
    decoration: ShapeDecoration(color: const Color(0xFF333333),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))),
    child: Center(child: child),
  );
}
