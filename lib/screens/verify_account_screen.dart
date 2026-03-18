// ─────────────────────────────────────────────
//  verify_account_screen.dart  —  ArtistMatch
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';   // AMBlueBtn
import 'reset_password_screen.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});
  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final List<String> _otp = List.filled(6, '');

  void _tap(String digit) {
    setState(() {
      final i = _otp.indexOf('');
      if (i != -1) _otp[i] = digit;
    });
  }

  void _back() {
    setState(() {
      for (int i = 5; i >= 0; i--) {
        if (_otp[i].isNotEmpty) { _otp[i] = ''; break; }
      }
    });
  }

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
          const Text('Verify your account',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFF7F7F7), fontSize: 20, fontFamily: 'Inter', fontWeight: FontWeight.w600, height: 1.50)),
          const SizedBox(height: 32),

          // ── 6 OTP boxes ───────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => _OtpBox(value: _otp[i])),
            ),
          ),
          const SizedBox(height: 16),
          const Text('send code again 00:12',
              style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w500, height: 1.40)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AMBlueBtn(
              label: 'Verify',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ResetPasswordScreen())),
            ),
          ),
          const Spacer(),
          _NumericKeypad(onDigit: _tap, onBack: _back),
          Container(width: 134, height: 5,
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(100))),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.value});
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    width: 48, height: 48,
    decoration: ShapeDecoration(color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.5,
            color: value.isNotEmpty ? const Color(0xFF4285F4) : const Color(0xFFDFDFDF)),
        borderRadius: BorderRadius.circular(8))),
    child: Center(child: Text(value,
        style: const TextStyle(color: Color(0xFF4285F4), fontSize: 18, fontFamily: 'Inter', fontWeight: FontWeight.w600))),
  );
}

class _NumericKeypad extends StatelessWidget {
  const _NumericKeypad({required this.onDigit, required this.onBack});
  final void Function(String) onDigit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFE6E9ED),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10),
          bottomLeft: Radius.circular(62), bottomRight: Radius.circular(62),
        ),
      ),
      child: Column(spacing: 11, children: [
        _numRow(['1','2','3']),
        _numRow(['4','5','6']),
        _numRow(['7','8','9']),
        Row(spacing: 6, children: [
          Expanded(child: Container(height: 50)),
          Expanded(child: _NumKey(label: '0', onTap: () => onDigit('0'))),
          Expanded(child: GestureDetector(
            onTap: onBack,
            child: Container(height: 50,
              decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))),
              child: const Center(child: Icon(Icons.backspace_outlined, color: Color(0xFF141414), size: 22))),
          )),
        ]),
      ]),
    );
  }

  Widget _numRow(List<String> digits) => Row(
    spacing: 6,
    children: digits.map((d) => Expanded(child: _NumKey(label: d, onTap: () => onDigit(d)))).toList(),
  );
}

class _NumKey extends StatelessWidget {
  const _NumKey({required this.label, required this.onTap});
  final String label; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(height: 50,
      decoration: ShapeDecoration(color: const Color(0xFFEDEDED),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.5))),
      child: Center(child: Text(label,
          style: const TextStyle(color: Colors.black, fontSize: 23, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.22))),
    ),
  );
}
