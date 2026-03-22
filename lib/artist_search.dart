import 'package:flutter/material.dart';
import 'artist_search_filters.dart';
//import 'notifications_page.dart';
// Artist Search update test
class ArtistSearchPage extends StatefulWidget {
  const ArtistSearchPage({super.key});

  @override
  State<ArtistSearchPage> createState() => _ArtistSearchPageState();
}

class _ArtistSearchPageState extends State<ArtistSearchPage> {
  int _currentBannerIndex = 0;
  int _selectedNavIndex = 0;
  List<String> _selectedRoles = [];
  List<String> _selectedGenres = [];
  List<String> _selectedTrackTypes = [];
  String? _selectedGender;
  List<String> _selectedLanguages = [];
  String? _selectedExp;
  String? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  final List<Map<String, String>> _suggestedArtists = [ // temp pictures 
    {'name': 'Costa', 'image': 'https://piscum.photos/76x76'},
    {'name': 'Misfit', 'image': 'https://piscum.photos/76x76'},
    {'name': 'SG Lewis', 'image': 'https://piscum.photos/76x76'},
    {'name': 'Chase Atlantic', 'image': 'https://piscum.photos/76x76'},
  ];

  final List<Map<String, String>> _newReleases = [ // dummy data for search page 
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
  final List<Map<String, dynamic>> _allArtists = [ // dummy data for search results
    {
      'name': 'SG Lewis',
      'roles': 'Producer, DJ',
      'followers': '479',
      'genres': ['#MinimalHouse', '#UKG'],
      'image': 'https://picsum.photos/52/52?random=10',
      'relevant': true,
    },
    {
      'name': 'FISHER',
      'roles': 'DJ, Producer',
      'followers': '7,839',
      'genres': ['#TechHouse', '#DeepHouse'],
      'image': 'https://picsum.photos/52/52?random=11',
      'relevant': false,
    },
    {
      'name': 'Costa',
      'roles': 'Musician',
      'followers': '1,200',
      'genres': ['#Indie', '#Pop'],
      'image': 'https://picsum.photos/52/52?random=12',
      'relevant': false,
    },
    {
      'name': 'Misfit',
      'roles': 'Producer',
      'followers': '890',
      'genres': ['#HipHop', '#Beats'],
      'image': 'https://picsum.photos/52/52?random=13',
      'relevant': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                      padding: const EdgeInsets.only(left: 12, right: 16),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF595959),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFFF7F7F7), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: Color(0xFFF7F7F7),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'ArtistSearch',
                                hintStyle: TextStyle(
                                  color: Color(0xFFF7F7F7),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                  _isSearching = value.isNotEmpty;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final result = await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          builder: (_, controller) => SearchFiltersPage(
                            initialRoles: _selectedRoles,
                            initialGenres: _selectedGenres,
                            initialTrackTypes: _selectedTrackTypes,
                            initialGender: _selectedGender,
                            initialLanguages: _selectedLanguages,
                            initialExp: _selectedExp,
                            initialLocation: _selectedLocation,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _selectedRoles = result['roles'] ?? [];
                          _selectedGenres = result['genres'] ?? [];
                          _selectedTrackTypes = result['trackTypes'] ?? [];
                          _selectedGender = result['gender'];
                          _selectedLanguages = result['languages'] ?? [];
                          _selectedExp = result['exp'];
                          _selectedLocation = result['location'];
                        });
                      }
                    },
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
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
                          if (_selectedRoles.isNotEmpty ||
                              _selectedGenres.isNotEmpty ||
                              _selectedTrackTypes.isNotEmpty ||
                              _selectedGender != null ||
                              _selectedLanguages.isNotEmpty ||
                              _selectedExp != null ||
                              _selectedLocation != null)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0088FF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
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
              child: _isSearching
                  ? _buildSearchResults() //MAKE THIS FUNCTION
                  : SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final query = _searchQuery.toLowerCase();
    final relevant = _allArtists
        .where((a) =>
            a['name'].toString().toLowerCase().contains(query) &&
            a['relevant'] == true)
        .toList();
    final related = _allArtists
        .where((a) =>
            a['name'].toString().toLowerCase().contains(query) &&
            a['relevant'] == false)
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        if (relevant.isNotEmpty) ...[
          const Text(
            'Most Relevant Results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          ...relevant.map((artist) => _buildArtistResultCard(artist)),
          const SizedBox(height: 16),
        ],
        if (related.isNotEmpty) ...[
          const Text(
            'Related Results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          ...related.map((artist) => _buildArtistResultCard(artist)),
        ],
        if (relevant.isEmpty && related.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'No artists found',
                style: TextStyle(
                  color: Color(0xFF595959),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildArtistResultCard(Map<String, dynamic> artist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      height: 67,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Container(
            width: 52,
            height: 52,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(artist['image']),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(38),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist['name'],
                  style: const TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.75,
                  ),
                ),
                Text(
                  '${artist['followers']} Followers',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                artist['roles'],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: (artist['genres'] as List<String>).map((genre) {
                  return Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
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
      height: 124,
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
}