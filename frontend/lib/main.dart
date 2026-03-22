import 'package:flutter/material.dart';
import 'Pages/login_page.dart';
import 'Pages/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // 2. Now it is safe to boot up the app!
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      
      
      home: SplashScreen(),
    );
  }
}