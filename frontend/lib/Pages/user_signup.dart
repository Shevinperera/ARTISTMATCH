import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_page.dart';
import 'login_page.dart';
import 'artist_signup.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Full genre list
  final List<String> genres = [
    'Hip Hop', 'House', 'R&B', 'Pop', 'Rock', 'Electronic', 'Jazz', 'Reggae',
    'Afrobeats', 'Latin', 'K-Pop', 'Country', 'Amapiano', 'Techno', 'Indie',
    'Phonk', 'Metal', 'Dancehall', 'Ambient', 'Drum and Bass'
  ];

  final List<String> selectedGenres = [];
  late final Map<String, int> genreMap = {
    for (int i = 0; i < genres.length; i++) genres[i]: i + 1
  };

  bool isLoading = false;

  Future<void> signupUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    if (selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one genre")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('https://artistmatch-backend-production.up.railway.app/auth/signup');
      final genreIds = selectedGenres.map((g) => genreMap[g]!).toList();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'genres': genreIds,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              email: emailController.text.trim(),
              nextPage: const LoginPage(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? "Signup failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error")),
      );
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0091EA);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Are you an artist? ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ArtistSignup())),
                  child: const Text("Signup here", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Image.asset('assets/AM_logo.png', height: 120, width: 120),
            const SizedBox(height: 30),
            const Text("User Registration", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text("Create your account", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _inputField("Full Name", nameController),
            const SizedBox(height: 16),
            _inputField("Email", emailController),
            const SizedBox(height: 16),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 16),
            _inputField("Confirm Password", confirmPasswordController, isPassword: true),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Select Genres", style: TextStyle(color: Colors.grey[400])),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: genres.map((genre) {
                final isSelected = selectedGenres.contains(genre);
                return ChoiceChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (selected) => setState(() {
                    selected ? selectedGenres.add(genre) : selectedGenres.remove(genre);
                  }),
                  selectedColor: brandBlue,
                  backgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[300]),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : signupUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold)),

            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}