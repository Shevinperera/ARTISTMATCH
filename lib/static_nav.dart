import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'artist_search.dart';
import 'my_profile.dart';
//import 'notifications_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Home - Coming Soon", style: TextStyle(color: Colors.white))),  // Index 0 - Home
    const ArtistSearchPage(),  // Index 1 - Explore
    const Center(child: Text("Add - Coming Soon", style: TextStyle(color: Colors.white))),   // Index 2 - Add
    const Center(child: Text("Notifications - Coming Soon", style: TextStyle(color: Colors.white))),  // Index 3 - Notifications
    MyProfilePage(             // Index 4 - Profile
      token: 'dummy_token',
      userData: const {
        'name': 'Your Name',
        'posts': '3',
      },
    ),
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