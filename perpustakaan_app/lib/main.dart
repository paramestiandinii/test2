import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:'https://fpqeeyzuuxsuyxzrgabt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZwcWVleXp1dXhzdXl4enJnYWJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTM5NTgsImV4cCI6MjA0NzEyOTk1OH0.vA21dy0Cu2lWQ7eKwymQiiUjOtf0UbGS-tHnjV0dXyI'
    
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Library',
      home: BookListPage(),
    );
  }
}
