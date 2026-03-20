import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'gig_post_page.dart';
import 'user_profile_screen.dart';
import 'messages_screen.dart'; // ← inbox (tap a chat to open ChatScreen)

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const GigPostPage(),                                                                          // 0 Home
    const Center(child: Text("Explore - Coming Soon", style: TextStyle(color: Colors.white))),    // 1 Explore
    const Center(child: Text("Add - Coming Soon",     style: TextStyle(color: Colors.white))),    // 2 Add
    const MessagesScreen(),                                                                       // 3 Messages
    const UserProfileScreen(),                                                                    // 4 Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}