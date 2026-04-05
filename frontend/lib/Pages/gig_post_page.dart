import 'package:flutter/material.dart';
import 'gig_apply_page.dart';
import 'new_gig_form.dart';
import 'gig_service.dart';

class GigPostPage extends StatefulWidget {
  const GigPostPage({super.key});

  @override
  State<GigPostPage> createState() => _GigPostPageState();
}

class _GigPostPageState extends State<GigPostPage> {
  List<Map<String, dynamic>> gigs = [];
  bool _isLoading = true;     // true while fetching from backend
  String? _errorMessage;      // holds error text if fetch fails

  @override
  void initState() {
    super.initState();
    _loadGigs(); // ← fetch gigs from backend when page opens
  }

  // ── Fetch all gigs from Express backend ────────────────────────────────────
  Future<void> _loadGigs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final fetchedGigs = await GigService.fetchGigs();

    setState(() {
      _isLoading = false;
      if (fetchedGigs.isEmpty && gigs.isEmpty) {
        // No gigs yet or network error — show empty state
        gigs = [];
      } else {
        gigs = fetchedGigs;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGigPage()),
          );
          // If the form returned a new gig, insert it at the top
          if (result != null) {
            setState(() {
              gigs.insert(0, result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gig Posted Successfully!")),
            );
          }
        },
        backgroundColor: const Color(0xFF0091EA),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Post Gig",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ── SEARCH BAR + FILTER ──────────────────────────────────────
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
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white, size: 28),
                    onPressed: () => _showFilterSheet(context),
                  ),
                  // Refresh button — re-fetch from backend
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 26),
                    onPressed: _loadGigs,
                    tooltip: "Refresh gigs",
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── GIG LIST ─────────────────────────────────────────────────
              Expanded(
                child: _buildGigList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Conditionally show loading / error / empty / list ─────────────────────
  Widget _buildGigList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0091EA)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.grey, size: 48),
            const SizedBox(height: 12),
            Text(_errorMessage!,
                style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGigs,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0091EA)),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (gigs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, color: Colors.grey, size: 48),
            SizedBox(height: 12),
            Text("No gigs yet. Be the first to post!",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: gigs.length,
      itemBuilder: (context, index) {
        final gig = gigs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: _buildGigCard(
            title: gig["title"] ?? "Untitled",
            location: gig["location"] ?? "Unknown",
            date: gig["date"] ?? "TBD",
            price: gig["price"] ?? "Rs 0",
            color: gig["color"] ?? Colors.teal,
          ),
        );
      },
    );
  }

  // ── GIG CARD ──────────────────────────────────────────────────────────────
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
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12)),
          child:
          const Icon(Icons.image, color: Colors.white24, size: 50),
        ),
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("📍 $location  •  $date",
            style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$price / night",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplyPage(
                      gigTitle: title,
                      gigDate: date,
                      gigLocation: location,
                      price: price,
                    ),
                  ),
                );
              },
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

  // ── FILTER SHEET ──────────────────────────────────────────────────────────
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Filter Gigs",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
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
          Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}