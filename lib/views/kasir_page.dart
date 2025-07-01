import 'package:flutter/material.dart';

class KasirHomePage extends StatefulWidget {
  const KasirHomePage({super.key});

  @override
  State<KasirHomePage> createState() => _KasirHomePageState();
}

class _KasirHomePageState extends State<KasirHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Kasir Home Page'),
      ),
    );
  }
}