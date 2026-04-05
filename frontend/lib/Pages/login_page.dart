import 'package:flutter/material.dart';
import 'gig_post_page.dart';

void main() {
  runApp(const ArtistMatchApp());
}

class ArtistMatchApp extends StatelessWidget {
  const ArtistMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is your Brand Blue color
    const Color brandBlue = Color(0xFF0091EA);

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 50),

              const Spacer(flex: 2),

              // 1. Top Logo (FIXED: Uses an Icon instead of a missing image)
              Image.asset(
                'assets/AM_logo.png', // <--- Change this to your file name
                height: 120, // Adjust height to make it bigger/smaller
                width: 120,
                fit: BoxFit.contain, // This stops it from stretching
              ),
              const SizedBox(height: 30),

              // 2. Headings
              const Text(
                "Create an account or login to start",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 24),

              // 3. Email Input Field
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "email@domain.com",
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 4. Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GigPostPage()),
                    );
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 5. "Or" Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey, thickness: 2)),
                ],
              ),

              const SizedBox(height: 24),

              // 6. Social Buttons
              _buildSocialButton(
                "Continue with Google",
                Icons.email,
                Colors.red,
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                "Continue with Apple",
                Icons.phone_iphone,
                Colors.black,
              ),

              const Spacer(flex: 2),

              // 7. Footer / Legal Text
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  children: [
                    TextSpan(text: "By clicking continue, you agree to our "),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: "\nand "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Bottom ArtistMatch Branding
              Image.asset(
                'assets/AM_logo2.png', // Make sure this matches your filename exactly
                height:
                    150, // You can change this number to make it bigger/smallerwifh
                width: 400,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to avoid repeating code for buttons
  Widget _buildSocialButton(String text, IconData icon, Color iconColor) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Text color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
