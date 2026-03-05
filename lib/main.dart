import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const ArtistMatchApp());
}

class ArtistMatchApp extends StatelessWidget {
  const ArtistMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArtistMatch',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ChatScreen(),
    );
  }
}