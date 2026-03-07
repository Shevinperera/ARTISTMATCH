import 'package:flutter/material.dart';
import 'nav_bar.dart'; 
import 'gig_post_page.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // These are the "pictures" that will swap inside the frame
 // HOW IT LOOKS RIGHT NOW
final List<Widget> _pages = [
  const GigPostPage(), // Index 0
  const Center(child: Text("Explore - Coming Soon", style: TextStyle(color: Colors.white))), // Index 1
  const Center(child: Text("Add - Coming Soon", style: TextStyle(color: Colors.white))), // Index 2
  const Center(child: Text("Alerts - Coming Soon", style: TextStyle(color: Colors.white))), // Index 3
  const Center(child: Text("Profile - Coming Soon", style: TextStyle(color: Colors.white))), // Index 4
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // IndexedStack just changes which page in the list is visible
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // The Nav Bar stays permanently fixed at the bottom
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Updates the active icon and page
          });
        },
      ),
    );
  }
}