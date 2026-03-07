import 'package:flutter/material.dart';
import 'new_gig_form.dart';
import 'nav_bar.dart'; //


class GigPostPage extends StatefulWidget {
  const GigPostPage({super.key});

  @override
  State<GigPostPage> createState() => _GigPostPageState();
}

class _GigPostPageState extends State<GigPostPage> {
  List<Map<String, dynamic>> gigs = [
    {
      "title": "Acoustic Night",
      "location": "Hilton, Colombo",
      "date": "January 15, 7pm",
      "price": "Rs 20,000",
      "color": Colors.brown,
    },
    {
      "title": "Techno & House",
      "location": "Industry, Colombo",
      "date": "January 21, 8pm",
      "price": "Rs 25,000",
      "color": Colors.purple,
    },
  ];
  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0091EA);

    return Scaffold(
      
      floatingActionButton: FloatingActionButton.extended(
    onPressed: () async {
      // Wait for the form to return data
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const CreateGigPage()),
      
    );
    // fn 
    if (result != null) {
      setState(() {
        // .insert(0, ...) puts the newest gig at the VERY TOP of the feed
        gigs.insert(0, result); 
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gig Posted Successfully!")),
      );
    }
  },
  backgroundColor: const Color(0xFF0091EA),
  icon: const Icon(Icons.add, color: Colors.white),
  label: const Text("Post Gig", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
),
    
      
      // Navigate to the form page

      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // --- SEARCH BAR ---
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
                  // Filter Button
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white, size: 28),
                    onPressed: () => _showFilterSheet(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- GIG LIST (Now takes up all remaining space) ---
             Expanded(
  child: ListView.builder(
    itemCount: gigs.length, 
    itemBuilder: (context, index) {
      final gig = gigs[index]; 
      
      return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _buildGigCard(
              title: gig["title"],
              location: gig["location"],
              date: gig["date"],
              price: gig["price"],
              color: gig["color"],
            ),
          ); // <--- 1. Closes the Padding & ends the return
        }, // <--- 2. Closes the itemBuilder function
      ),
    ), // <--- 3. Closes Expanded
  ], // <--- 4. Closes the Column's 'children' list
), // <--- 5. Closes the Column
), // <--- 6. Closes the top-level Padding
), // <--- 7. Closes the SafeArea


    );
  }

  // --- HELPER: GIG CARD ---
  Widget _buildGigCard({
    required String title,
    required String location,
    required String date,
    required String price,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Placeholder
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.image, color: Colors.white24, size: 50), // Temp Icon
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

  // --- HELPER: FILTER SHEET ---
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Filter Gigs", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildFilterOption(Icons.sort, "Sort by Price"),
              _buildFilterOption(Icons.calendar_today, "Sort by Date"),
              _buildFilterOption(Icons.location_on, "Location"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}