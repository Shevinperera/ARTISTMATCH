import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap; // This lets MainScreen know a button was pressed

  const CustomNavBar({
    super.key, 
    required this.currentIndex, 
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xFF0091EA), 
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      
      currentIndex: currentIndex, 
      onTap: onTap, // Passes the tap back to MainScreen
      
      items: const [
                BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "",
        ),
                BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: "",
        ),
                BottomNavigationBarItem(
          icon: Icon(Icons.star_border_outlined, size: 30),
          activeIcon: Icon(Icons.star, size: 30),
          label: "",
        ),
                BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble_sharp),
          label: "",
        ),
                BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "",
        ),
      ],
    );
  }
}