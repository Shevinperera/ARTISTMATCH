import 'package:flutter/material.dart';
//import 'login_page.dart';
import 'nav_bar.dart';

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
  int _currentIndex = 4;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
              Navigator.pop(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userData['name'] ?? 'No Name';
    final email = widget.userData['email'] ?? 'No Email';

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔥 BANNER
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.5),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Text(
                      "User Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
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
                    const SizedBox(height: 15),

                    /// AVATAR
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// NAME
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// TAGLINE
                    const Text(
                      "Music Lover 🎧",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 15),

                    /// ROLE BADGE
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: const Text(
                        "USER",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// USER INFO
                    _info("Email", email),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
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

      /// 🔥 NAVBAR
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