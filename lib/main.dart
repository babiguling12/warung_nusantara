import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_nusantara/views/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Nusantara',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      home: LoginPage(),
    );
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}
