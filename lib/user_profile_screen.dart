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

  @override
  Widget build(BuildContext context) {
    final name = widget.userData['name'] ?? 'No Name';
    final image = widget.userData['image'] ?? 'https://picsum.photos/76/76?random=20';

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
                        onTap: () {},
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
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: SizedBox(height: 30),
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
}