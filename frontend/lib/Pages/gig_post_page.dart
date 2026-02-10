import 'package:flutter/material.dart';

class GigPostPage extends StatelessWidget { // <--- This is the Class Name!
  const GigPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0091EA);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. SEARCH BAR & FILTER
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Find Gigs",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Icon
                  const Icon(Icons.tune, color: Colors.white, size: 28),
                ],
              ),

              const SizedBox(height: 16),

              // 2. TABS (Post Gig, All Gigs, etc.)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab("Post Gig", brandBlue, true),
                    _buildTab("All Gigs", Colors.transparent, false),
                    _buildTab("My Applications", Colors.transparent, false),
                    _buildTab("Saved", Colors.transparent, false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. GIG LIST
              Expanded(
                child: ListView(
                  children: [
                    // Card 1: Acoustic Night
                    _buildGigCard(
                      title: "Acoustic Night",
                      location: "Hilton, Colombo",
                      date: "January 15, 7pm",
                      price: "Rs 20,000",
                      imageAsset: "assets/acoustic.jpg", // Make sure to add images later!
                      color: Colors.brown, // Placeholder color
                    ),
                    const SizedBox(height: 20),
                    
                    // Card 2: Techno & House
                    _buildGigCard(
                      title: "Techno & House",
                      location: "Industry, Colombo",
                      date: "January 21, 8pm",
                      price: "Rs 25,000",
                      imageAsset: "assets/techno.jpg",
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 30), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildTab(String text, Color color, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? null : Border.all(color: Colors.grey),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGigCard({
    required String title,
    required String location,
    required String date,
    required String price,
    required String imageAsset,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Placeholder 
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color, 
            borderRadius: BorderRadius.circular(12),
          ),
          // Once you have real images, replace 'Container' with 'Image.asset'
        ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("📍 $location  •  $date", style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$price / night", style: const TextStyle(color: Colors.white, fontSize: 16)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0091EA),
                foregroundColor: Colors.white,
              ),
              child: const Text("Apply"),
            ),
          ],
        ),
      ],
    );
  }
}