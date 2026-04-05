void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArtistMatch',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ArtistSearchPage(), // ← keep this as the entry point
    );
  }
}