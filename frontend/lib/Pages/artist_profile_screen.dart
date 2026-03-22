import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

final List<String> genres = [
  'Hip Hop', 'House', 'R&B', 'Pop', 'Rock', 'Electronic', 'Jazz', 'Reggae',
  'Afrobeats', 'Latin', 'K-Pop', 'Country', 'Amapiano', 'Techno', 'Indie',
  'Phonk', 'Metal', 'Dancehall', 'Ambient', 'Drum and Bass'
];

final Map<int, String> genreIdToName = {
  for (int i = 0; i < genres.length; i++) i + 1: genres[i]
};

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

class _ArtistProfileScreenState extends State<ArtistProfileScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scroll;
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  bool _headerCollapsed = false;
  static const double _collapseOffset = 180;

  String get _name => widget.userData['name'] ?? 'Artist';
  String get _role => widget.userData['role'] ?? '';
  String get _language => widget.userData['language'] ?? '';
  String get _location => widget.userData['location'] ?? '';
  String get _genreName => genreIdToName[widget.userData['genre_id']] ?? 'N/A';
  String get _avatarUrl =>
      widget.userData['profile_image'] ??
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400';
  String get _bannerUrl =>
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=900';

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()
      ..addListener(() {
        final collapsed = _scroll.offset > _collapseOffset;
        if (collapsed != _headerCollapsed) {
          setState(() => _headerCollapsed = collapsed);
        }
      });
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Color(0xFFFF453A))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
        );
      }
    }
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _sheetOption(Icons.share_outlined, 'Share Profile', Colors.white),
            _sheetOption(Icons.flag_outlined, 'Report', Colors.white),
            _sheetOption(Icons.logout, 'Logout', const Color(0xFFFF453A),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sheetOption(IconData icon, String label, Color color,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label,
          style: TextStyle(
              color: color, fontSize: 15, fontWeight: FontWeight.w400)),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              // ── HERO BANNER ──
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SizedBox(
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _bannerUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF1C1C1E)),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0x990A0A0A),
                                Color(0xFF0A0A0A),
                              ],
                              stops: [0.3, 0.7, 1.0],
                            ),
                          ),
                        ),
                        // Avatar + name at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0094FF),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0094FF)
                                          .withOpacity(0.4),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    _avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFF1C1C1E),
                                      child: const Icon(Icons.person,
                                          color: Colors.white54, size: 40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _role,
                                style: const TextStyle(
                                  color: Color(0xFF0094FF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── STATS ROW ──
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: Row(
                        children: [
                          _statCell('0', 'Posts'),
                          _statDivider(),
                          _statCell('0', 'Followers'),
                          _statDivider(),
                          _statCell('0', 'Following'),
                          _statDivider(),
                          _statCell('0', 'Gigs'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── INFO TAGS ──
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (_genreName.isNotEmpty) _tag('🎵 $_genreName'),
                        if (_language.isNotEmpty) _tag('🗣 $_language'),
                        if (_location.isNotEmpty) _tag('📍 $_location'),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── DIVIDER ──
              SliverToBoxAdapter(
                child: Divider(
                    color: const Color(0xFF2A2A2A), height: 1, thickness: 1),
              ),

              // ── POSTS SECTION ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Posts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00305A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(
                            color: Color(0xFF0094FF),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── EMPTY POSTS ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.grid_off_outlined,
                            color: Colors.white.withOpacity(0.2), size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'No posts yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // ── STICKY TOP BAR ──
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  _iconBtn(Icons.arrow_back_ios_new_rounded,
                          () => Navigator.maybePop(context)),
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: _headerCollapsed ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _iconBtn(Icons.more_horiz, _showOptions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCell(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF888888), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _statDivider() =>
      Container(width: 1, height: 28, color: const Color(0xFF2A2A2A));

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Color(0xFFF5F5F5),
            fontSize: 12,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}