import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: _titles[_selectedIndex],
        role: 'Admin',
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
