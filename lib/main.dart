<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'static_nav.dart';

>>>>>>> 2c33f19ca12066cdb523f7ea680cc40682fea54e
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'ArtistMatch',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ArtistSearchPage(), // ← keep this as the entry point
=======
      home: MainScreen(),
>>>>>>> 2c33f19ca12066cdb523f7ea680cc40682fea54e
    );
  }
}