import 'package:flutter/material.dart';
import 'login_page.dart';
import 'nav_bar.dart';

/// ─────────────────────────────────────────────
/// CENTRALIZED GENRES
/// ─────────────────────────────────────────────
final List<String> genres = [
  'Hip Hop', 'House', 'R&B', 'Pop', 'Rock', 'Electronic', 'Jazz', 'Reggae',
  'Afrobeats', 'Latin', 'K-Pop', 'Country', 'Amapiano', 'Techno', 'Indie',
  'Phonk', 'Metal', 'Dancehall', 'Ambient', 'Drum and Bass'
];

final Map<int, String> genreIdToName = {
  for (int i = 0; i < genres.length; i++) i + 1: genres[i]
};

/// ─────────────────────────────────────────────
/// MODELS
/// ─────────────────────────────────────────────
class ArtistProfile {
  final String name;
  final String tagline;
  final String bio;
  final String bannerUrl;
  final String avatarUrl;
  final int followers;
  final int following;
  final int posts;
  final int activeGigs;
  final String spotifyUrl;
  final String instagramUrl;
  final String soundcloudUrl;
  final List<GigItem> activeGigs2;
  final List<CatalogItem> catalog;
  final List<String> postImages;

  const ArtistProfile({
    required this.name,
    required this.tagline,
    required this.bio,
    required this.bannerUrl,
    required this.avatarUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.activeGigs,
    required this.spotifyUrl,
    required this.instagramUrl,
    required this.soundcloudUrl,
    required this.activeGigs2,
    required this.catalog,
    required this.postImages,
  });
}

class GigItem {
  final String title;
  final String imageUrl;
  GigItem({required this.title, required this.imageUrl});
}

class CatalogItem {
  final String title;
  final String imageUrl;
  final double price;

  CatalogItem({
    required this.title,
    required this.imageUrl,
    required this.price,
  });
}

/// ─────────────────────────────────────────────
/// MAIN SCREEN (ARTIST ONLY)
/// ─────────────────────────────────────────────
class ArtistProfileScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> userData;

  const ArtistProfileScreen({
    super.key,
    required this.token,
    required this.userData,
  });

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  late final ArtistProfile profile;
  late final String? genreName;

  int _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    genreName = genreIdToName[widget.userData['genre_id']];
    profile = _mapToProfile(widget.userData);
  }

  /// NAVIGATION HANDLER
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // TODO: Add navigation logic
  }

  /// MAP API DATA → UI MODEL
  ArtistProfile _mapToProfile(Map<String, dynamic> data) {
    return ArtistProfile(
      name: data['name'] ?? 'No Name',
      tagline: "${data['role'] ?? ''} · ${data['language'] ?? ''}",
      bio: "Artist from ${data['location'] ?? ''}",
      bannerUrl:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      avatarUrl:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200',
      followers: 0,
      following: 0,
      posts: 0,
      activeGigs: 0,
      spotifyUrl: '',
      instagramUrl: '',
      soundcloudUrl: '',
      activeGigs2: [],
      catalog: [],
      postImages: [],
    );
  }

  /// LOGOUT
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// BANNER
            Stack(
              children: [
                Image.network(
                  profile.bannerUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Text(
                      "Artist Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.avatarUrl),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      profile.tagline,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: const Text(
                        "ARTIST",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _info("Role", widget.userData['role']),
                    _info("Language", widget.userData['language']),
                    _info("Location", widget.userData['location']),
                    _info("Genre", genreName ?? 'N/A'),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logout,
                  child: const Text("Logout"),
                ),
              ),
            ),
          ],
        ),
      ),

      /// NAVBAR
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "$label: ${value ?? 'N/A'}",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}