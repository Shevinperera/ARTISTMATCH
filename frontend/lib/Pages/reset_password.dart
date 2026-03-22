import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool isLoading = false;
  final baseUrl = "http://10.0.2.2:5000";

  Future<void> resetPassword() async {
    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'password': passwordController.text.trim()}),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Password reset successfully")));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()), // go to login
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['error'] ?? "Reset failed")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Network error")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _inputField(String hint, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0091EA);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset('assets/AM_logo.png', height: 120),
              const SizedBox(height: 30),
              const Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Enter new password", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              _inputField("New Password", passwordController, isPassword: true),
              const SizedBox(height: 16),
              _inputField("Confirm Password", confirmController, isPassword: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(backgroundColor: brandBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Reset Password", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}