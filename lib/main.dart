// ─────────────────────────────────────────────
//  main.dart  —  ArtistMatch
//
//  Auth flow:
//    SignInScreen
//      ├─ "Continue" / Google / Apple  ──→  MainNavScreen
//      ├─ "Sign up"                    ──→  SignUpScreen  ──→  MainNavScreen
//      └─ "Forgot password?"           ──→  ForgotPasswordScreen
//                                               └─ VerifyAccountScreen
//                                                      └─ ResetPasswordScreen
//                                                              └─ popUntil(first)
//                                                                 (back to SignIn)
//
//  MainNavScreen:
//    Tab 0 → UserProfileScreen
//    Tab 1 → ChatScreen
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'screens/sign_in_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const ArtistMatchApp());
}

class ArtistMatchApp extends StatelessWidget {
  const ArtistMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArtistMatch',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Inter',
      ),
      // App always starts at Sign In
      home: const SignInScreen(),
    );
  }
}

// ════════════════════════════════════════════════════════
//  MainNavScreen  — reached after successful auth
// ════════════════════════════════════════════════════════

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  // Screens are kept alive by IndexedStack so state isn't lost on tab switch
  final List<Widget> _screens = const [
    UserProfileScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps both screens mounted — no rebuild on tab switch
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: const Color(0xFF0094FF),   // ArtistMatch blue
        unselectedItemColor: const Color(0xFF888888),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
