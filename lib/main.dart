import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'chat_screen.dart';
=======
import 'artist_search.dart';
>>>>>>> 998e9ba080b059dc2dafedd7b1e8cbbc2a8bf411

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'ArtistMatch',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ChatScreen(),
=======
      home: ArtistSearchPage(),
>>>>>>> 998e9ba080b059dc2dafedd7b1e8cbbc2a8bf411
    );
  }
}