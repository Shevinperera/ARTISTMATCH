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
            const Expanded(
              child: Center(
                child: Text('Feed coming soon',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
