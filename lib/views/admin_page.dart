import 'package:flutter/material.dart';
import 'login_page.dart';
import 'admin/list_makanan_page.dart';
import 'admin/tambah_stok_page.dart';
import 'admin/riwayat_transaksi_page.dart';
import 'admin/favourite_page.dart';
import 'admin/kelola_user_page.dart';
import '../components/custom_bottom_nav.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ListMakananPage(),
    FavouritePage(),
    TambahStokPage(),
    RiwayatTransaksiPage(),
    KelolaUserPage(),
  ];

  final List<String> _titles = const [
    'List Makanan',
    'Favourite',
    'Tambah Stok',
    'Riwayat Transaksi',
    'Kelola Kasir',
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openProfile() {
    // untuk halaman profile atau logout
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Profile Admin'),
            content: Text('Logout'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.teal[700]),
                ),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.teal[700]),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: _openProfile,
            tooltip: 'Profile Admin',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                FadeTransition(opacity: animation, child: child),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
