import 'package:flutter/material.dart';
import 'artist_search_filters.dart';
import 'notifications_page.dart';
// Artist Search update test
class ArtistSearchPage extends StatefulWidget {
  const ArtistSearchPage({super.key});

  @override
  State<ArtistSearchPage> createState() => _ArtistSearchPageState();
}

class _ArtistSearchPageState extends State<ArtistSearchPage> {
  int _currentBannerIndex = 0;
  int _selectedNavIndex = 0;

  final List<Map<String, String>> _suggestedArtists = [
    {'name': 'Costa', 'image': 'https://piscum.photos/76x76'},
    {'name': 'Misfit', 'image': 'https://piscum.photos/76x76'},
    {'name': 'SG Lewis', 'image': 'https://piscum.photos/76x76'},
    {'name': 'Chase Atlantic', 'image': 'https://piscum.photos/76x76'},
  ];

  final List<Map<String, String>> _newReleases = [
    {
      'title': '3005',
      'artist': 'Misfit',
      'time': '3 Days Ago',
      'image': 'https://piscum.photos/148x148',
    },
    {
      'title': 'HEAT',
      'artist': 'Tove Lo, SG Lewis',
      'time': 'Last Month',
      'image': 'https://piscum.photos/148x148',
    },
    {
      'title': "don's panic",
      'artist': 'soscamo',
      'time': 'Last Year',
      'image': 'https://piscum.photos/148x148',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar row
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.only(top: 8, left: 12, right: 16, bottom: 8),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF595959),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFFF7F7F7), size: 20),
                          SizedBox(width: 12),
                          Text(
                            'ArtistSearch',
                            style: TextStyle(
                              color: Color(0xFFF7F7F7),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          builder: (_, controller) => const SearchFiltersPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF595959),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFFF7F7F7), size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /*// Filter chips (have to put this later when we have actual filters to show)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip(Icons.history_outlined, 'History'),
                  const SizedBox(width: 8),
                  _buildFilterChip(Icons.favorite_border, 'Favorites'),
                  const SizedBox(width: 8),
                  _buildFilterChip(Icons.person_add_alt_outlined, 'Following'),
                ],
              ),
            ),*/

            const SizedBox(height: 8),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTrendingBanner(),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Suggested Artists'),
                    _buildSuggestedArtists(),
                    const SizedBox(height: 8),
                    _buildSectionHeader('New Releases For You'),
                    _buildNewReleases(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF828282)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFF7F7F7), size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF7F7F7),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.57,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 136,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/trending_banner.png'),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
          // Title
          /*const Positioned(
            left: 20,
            top: 54,
            child: Text(
              'Trending Genres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.40,
                letterSpacing: -0.40,
              ),
            ),
          ),
          // Dots
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: ShapeDecoration(
                    color: index == _currentBannerIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.30),
                    shape: const OvalBorder(),
                  ),
                );
              }),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.32,
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const ShapeDecoration(
              color: Color(0xFF595959),
              shape: OvalBorder(),
            ),
            child: const Icon(Icons.chevron_right, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedArtists() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestedArtists.length,
        itemBuilder: (context, index) {
          final artist = _suggestedArtists[index];
          return Container(
            margin: const EdgeInsets.only(right: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(artist['image']!),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 76,
                  child: Text(
                    artist['name']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF7F7F7),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.40,
                      letterSpacing: 0.14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewReleases() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _newReleases.length,
        itemBuilder: (context, index) {
          final release = _newReleases[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 148,
                  height: 148,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(release['image']!),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  release['time']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 1.40,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 148,
                  child: Text(
                    release['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      height: 1.40,
                    ),
                  ),
                ),
                SizedBox(
                  width: 148,
                  child: Text(
                    release['artist']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.40,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      Icons.home_outlined,
      Icons.explore_outlined,
      Icons.add_box_outlined,
      Icons.notifications_outlined,
      Icons.person_outline,
    ];

    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 0,
            offset: Offset(0, -0.50),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = _selectedNavIndex == index;
          return GestureDetector(
            onTap: () {
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              } else {
                setState(() => _selectedNavIndex = index);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  items[index],
                  color: isSelected ? Colors.white : const Color(0xFF595959),
                  size: 24,
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 3,
                    height: 3,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: OvalBorder(),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}