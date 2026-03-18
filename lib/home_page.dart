import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _posts = [ //dummy data for feed posts
    {
      'username': 'Chris Stussy',
      'caption': 'Yesterday was lit at Berlin!\n#house #minimalhouse',
      'likes': 20000,
      'image': 'https://picsum.photos/400/800?random=1',
      'isFollowing': false,
      'isLiked': false,
    },
    {
      'username': 'SG Lewis',
      'caption': 'Studio session with the gang 🎹\n#rnb #producer',
      'likes': 15400,
      'image': 'https://picsum.photos/400/800?random=2',
      'isFollowing': false,
      'isLiked': false,
    },
    {
      'username': 'Costa',
      'caption': 'New track out now 🔥\n#indie #newmusic',
      'likes': 8200,
      'image': 'https://picsum.photos/400/800?random=3',
      'isFollowing': false,
      'isLiked': false,
    },
    {
      'username': 'Misfit',
      'caption': 'Late night sessions 🌙\n#hiphop #beats',
      'likes': 31000,
      'image': 'https://picsum.photos/400/800?random=4',
      'isFollowing': false,
      'isLiked': false,
    },
  ];

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}k';
    return count.toString();
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            _optionTile(Icons.flag_outlined, 'Report Post', Colors.red),
            _optionTile(Icons.person_off_outlined, 'Block Artist', Colors.white),
            _optionTile(Icons.visibility_off_outlined, 'Not Interested', Colors.white),
            _optionTile(Icons.share_outlined, 'Share Post', Colors.white),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(IconData icon, String label, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
 

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ──
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFF7F7F7).withOpacity(0.37),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 24),
                  Image.asset(
                    'assets/AM_logo2.png',
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                  const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
            // ── Feed ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _posts.length,
                itemBuilder: (context, index) => _buildPost(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context, int index) {
    final post = _posts[index];

    return Stack(
      fit: StackFit.expand,
      children: [
        // Full post image
        Image.network(
          post['image'],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1A1A1A),
            child: const Center(
              child: Icon(Icons.image_outlined,
                  color: Color(0xFF595959), size: 64),
            ),
          ),
        ),

        // Bottom gradient so text is readable
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 280,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.88),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Three dots — top right
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => _showPostOptions(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: List.generate(3, (i) => Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : 3),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                )),
              ),
            ),
          ),
        ),

        
      ],
    );
  }
}
