import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nav_bar.dart';
import 'gig_post_page.dart';
import 'messages_screen.dart';
import 'user_profile_screen.dart';
import 'artist_profile_screen.dart';
import 'home_page.dart';
import 'artist_search.dart';
import 'socket_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _userId = 0;
  String _role = 'user';
  String _token = '';
  Map<String, dynamic> _userData = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId') ?? 0;
      _role = prefs.getString('role') ?? 'user';
      _token = prefs.getString('token') ?? '';
      final userDataString = prefs.getString('userData') ?? '{}';
      _userData = jsonDecode(userDataString);
      _loaded = true;
    });

    // Connect socket for real-time messaging
    if (_userId != 0) {
      SocketService.connect(_userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _userId == 0) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0091EA)),
        ),
      );
    }

    final List<Widget> _pages = [
      FeedPage(userId: _userId),
      const ArtistSearchPage(),
      const GigPostPage(),
      ConversationsScreen(currentUserId: _userId),
      _role == 'artist'
          ? ArtistProfileScreen(token: _token, userData: _userData)
          : UserProfileScreen(token: _token, userData: _userData),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}