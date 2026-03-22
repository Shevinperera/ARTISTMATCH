import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_page.dart';
import 'login_page.dart';

class ArtistSignup extends StatefulWidget {
  const ArtistSignup({super.key});

  @override
  State<ArtistSignup> createState() => _ArtistSignupState();
}

class _ArtistSignupState extends State<ArtistSignup> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Expanded lists
  final List<String> genres = [
    'Hip Hop', 'House', 'R&B', 'Pop', 'Rock', 'Electronic', 'Jazz', 'Reggae',
    'Afrobeats', 'Latin', 'K-Pop', 'Country', 'Amapiano', 'Techno', 'Indie',
    'Phonk', 'Metal', 'Dancehall', 'Ambient', 'Drum and Bass'
  ];

  late final Map<String, int> genreMap = {
    for (int i = 0; i < genres.length; i++) genres[i]: i + 1
  };

  final List<String> roles = [
    'Producer', 'Songwriter', 'Vocalist', 'DJ', 'Mixing Engineer', 'Mastering Engineer',
    'Composer', 'Instrumentalist', 'Recording Engineer', 'Other'
  ];

  final List<String> genders = ['Male', 'Female'];

  final List<String> languages = [
    'Sinhala', 'Tamil', 'Hindi', 'English', 'German', 'French', 'Portuguese',
    'Japanese', 'Spanish', 'Mandarin', 'Korean', 'Arabic'
  ];

  final List<String> locations = [
    'Sri Lanka', 'India', 'United States', 'United Kingdom', 'Germany', 'France',
    'Brazil', 'Nigeria', 'South Africa', 'Australia', 'Japan', 'Mexico', 'Canada',
    'China', 'South Korea', 'Indonesia', 'Sweden', 'Italy', 'Egypt', 'Turkey'
  ];

  String? selectedGenre;
  String? selectedRole;
  String? selectedGender;
  String? selectedLanguage;
  String? selectedLocation;

  bool isLoading = false;

  Future<void> registerArtist() async {
    if (passwordController.text != confirmPasswordController.text) {
      showSnack("Passwords do not match");
      return;
    }

    if ([selectedGenre, selectedRole, selectedGender, selectedLanguage, selectedLocation].contains(null)) {
      showSnack("Please fill all required fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('http://10.0.2.2:5000/auth/signup');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'genre_id': genreMap[selectedGenre]!,
          'role': selectedRole,
          'gender': selectedGender,
          'language': selectedLanguage,
          'location': selectedLocation,
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
        showSnack(data['error'] ?? "Signup failed");
      }
    } catch (e) {
      showSnack("Network error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnack(String message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

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

  Widget buildDropdown(String hint, String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0091EA);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/AM_logo.png', height: 120, width: 120),
            const SizedBox(height: 30),
            const Text("Artist Registration", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text("Register as an artist", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _inputField("Artist Name", nameController),
            const SizedBox(height: 16),
            _inputField("Email", emailController),
            const SizedBox(height: 16),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 16),
            _inputField("Confirm Password", confirmPasswordController, isPassword: true),
            const SizedBox(height: 16),
            buildDropdown("Select Genre", selectedGenre, genres, (val) => setState(() => selectedGenre = val)),
            const SizedBox(height: 16),
            buildDropdown("Select Role", selectedRole, roles, (val) => setState(() => selectedRole = val)),
            const SizedBox(height: 16),
            buildDropdown("Select Gender", selectedGender, genders, (val) => setState(() => selectedGender = val)),
            const SizedBox(height: 16),
            buildDropdown("Select Language", selectedLanguage, languages, (val) => setState(() => selectedLanguage = val)),
            const SizedBox(height: 16),
            buildDropdown("Select Location", selectedLocation, locations, (val) => setState(() => selectedLocation = val)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : registerArtist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register Artist", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}