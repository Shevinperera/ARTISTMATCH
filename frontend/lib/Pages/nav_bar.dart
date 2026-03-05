import 'package:flutter/material.dart';
import 'gig_post_page.dart'; // Make sure this path is correct!

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    // If we click the tab we are already on, do nothing!
    if (index == currentIndex) return; 

    // Figure out which page to go to based on the icon clicked
    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const GigPostPage(); // 0 is Home
        break;
      case 4:
        // 4 is Profile. Just a placeholder until you build the real one!
        nextPage = const Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Profile Page", style: TextStyle(color: Colors.white)))); 
        break;
      default:
        // Placeholder for Explore, Add, and Alerts
        nextPage = const Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Coming Soon", style: TextStyle(color: Colors.white))));
    }

    // Switch the page instantly without the "sliding" animation
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => nextPage,
        transitionDuration: Duration.zero, 
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xFF0091EA), // Brand Blue
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      
      currentIndex: currentIndex, // Highlights the correct icon
      onTap: (index) => _onTap(context, index), // Runs the routing logic
      
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}