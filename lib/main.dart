import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:warung_nusantara/views/login_page.dart';
// import 'package:warung_nusantara/services/copy_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id');

  // await copyDatabaseFromAsset();

  runApp(const MyApp());
}

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
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.teal, // warna kursor
        selectionColor: Colors.teal[100], // warna blok saat nge select
        selectionHandleColor: Colors.teal, // warna titik pegangan blok teks
      )
    );
  }
}
