import 'package:flutter/material.dart';
import 'artist_search_filters.dart';
import 'api_service.dart';

class ArtistSearchPage extends StatefulWidget {
  const ArtistSearchPage({super.key});

  @override
  State<ArtistSearchPage> createState() => _ArtistSearchPageState();
}

class _ArtistSearchPageState extends State<ArtistSearchPage> {
  int _currentBannerIndex = 0;
  int _selectedNavIndex = 0;

  // search
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  // backend data
  List<dynamic> _suggestedArtists = [];
  List<dynamic> _newReleases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  Future<void> _loadPageData() async {
    try {
      final suggested = await ApiService.getSuggestedArtists();
      final releases = await ApiService.getNewReleases();
      setState(() {
        _suggestedArtists = suggested;
        _newReleases = releases;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading page data: $e');
    }
  }

  Future<void> _onSearch(String value) async {
    if (value.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    try {
      final results = await ApiService.searchArtists(value);
      setState(() => _searchResults = results);
    } catch (e) {
      print('Search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar row — same as original but now functional
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF595959),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: _onSearch,
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
                            height: 1.50,
                          ),
                          prefixIcon: Icon(Icons.search, color: Color(0xFFF7F7F7), size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final results = await showModalBottomSheet<List<dynamic>>(
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
                      if (results != null) {
                        setState(() => _searchResults = results);
                      }
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

            const SizedBox(height: 8),

            // Scrollable body
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // show search results OR normal page — never both
                          if (_searchResults.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                'Search Results',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.40,
                                  letterSpacing: -0.32,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final artist = _searchResults[index];
                                return ListTile(
                                  title: Text(
                                    artist['artistName'] ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    artist['genre'] ?? '',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ] else ...[
                            // original page UI
                            _buildTrendingBanner(),
                            const SizedBox(height: 16),
                            _buildSectionHeader('Suggested Artists'),
                            _buildSuggestedArtists(),
                            const SizedBox(height: 8),
                            _buildSectionHeader('New Releases For You'),
                            _buildNewReleases(),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
            ),
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

  // uses backend data from _suggestedArtists
  Widget _buildSuggestedArtists() {
    if (_suggestedArtists.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('No suggested artists yet.', style: TextStyle(color: Colors.grey)),
      );
    }

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
                // placeholder circle since no image in db yet
                Container(
                  width: 76,
                  height: 76,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF595959),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 76,
                  child: Text(
                    artist['artistName'] ?? '',
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

  // uses backend data from _newReleases
  Widget _buildNewReleases() {
    if (_newReleases.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('No new releases yet.', style: TextStyle(color: Colors.grey)),
      );
    }

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
                // placeholder image since no image in db yet
                Container(
                  width: 148,
                  height: 148,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF595959),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 148,
                  child: Text(
                    release['beatName'] ?? '',
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
                    release['artistName'] ?? '',
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