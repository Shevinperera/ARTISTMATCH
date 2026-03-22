import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> userData;

  const UserProfileScreen({
    super.key,
    required this.token,
    required this.userData,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;
  
  void _showOptions() {
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
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.red, size: 22),
              title: const Text(
                'Report',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person_off_outlined, color: Colors.white, size: 22),
              title: const Text(
                'Block',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userData['name'] ?? 'No Name';
    final image = widget.userData['image'] ?? 'https://picsum.photos/76/76?random=20';
    final followers = widget.userData['followers'] ?? '2,018';
    final following = widget.userData['following'] ?? '2,085';
    final posts = widget.userData['posts'] ?? '3';
    final roles = widget.userData['roles'] ?? 'Artist';
    final bio = widget.userData['bio'] ?? 'Stream LA, out now!';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                width: double.infinity,
                height: 195,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.userData['banner'] ??
                          'https://picsum.photos/354/195?random=99',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Back button
                    Positioned(
                      left: 6,
                      top: 8,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    // Three dots
                    Positioned(
                      right: 6,
                      top: 8,
                      child: GestureDetector(
                        onTap: _showOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: List.generate(
                              3,
                              (i) => Container(
                                width: 4,
                                height: 4,
                                margin: EdgeInsets.only(left: i == 0 ? 0 : 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Avatar + name
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 24,
                      child: Column(
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(38),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
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
                        ],
                      ),
                    ),
                    // Stats placeholder
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: Row(
                        children: [
                          _statItem(followers, 'followers'),
                          _statItem(following, 'following'),
                          _statItem(posts, 'posts'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  roles,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    height: 1.50,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                    Text(
                      bio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Row(
                  children: [
                    const Text(
                      'View Links',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.white, size: 12),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: GestureDetector(
                  onTap: () => setState(() => _isFollowing = !_isFollowing),
                  child: Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _isFollowing ? Colors.transparent : const Color(0xFF0088FF),
                      borderRadius: BorderRadius.circular(8),
                      border: _isFollowing ? Border.all(color: const Color(0xFF595959)) : null,
                    ),
                    child: Center(
                      child: Text(
                        _isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: const Color(0xFFE6E6E6).withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Posts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _postThumb('https://picsum.photos/127/121?random=30'),
                        const SizedBox(width: 4),
                        _postThumb('https://picsum.photos/127/121?random=31'),
                        const SizedBox(width: 4),
                        _postThumb('https://picsum.photos/127/121?random=32'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
  Widget _postThumb(String url) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 127 / 121,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

}