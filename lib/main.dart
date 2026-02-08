import 'package:flutter/material.dart';
import 'Pages/login_page.dart'; // <--- 1. IMPORTANT: Connects to your new file

void main() {
  runApp(const ArtistMatchApp());
}

class ArtistMatchApp extends StatelessWidget {
  const ArtistMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the "Debug" banner
      title: 'ArtistMatch',
      
      // 2. THEME: You can set your app-wide colors here later
      theme: ThemeData(
        brightness: Brightness.dark, // Default to dark mode
        primaryColor: const Color(0xFF0091EA), // Your brand blue
        scaffoldBackgroundColor: const Color(0xFF121212), // Your background
        useMaterial3: true,
      ),

      // 3. HOME: This tells the app "Start here!"
      home: const SignInScreen(), 
    );
  }
}