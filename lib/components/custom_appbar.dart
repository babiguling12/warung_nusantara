import 'package:flutter/material.dart';
import '../views/login_page.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String role;

  CustomAppbar({required this.title, required this.role});

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('$role Logout'),
            content: Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: TextStyle(color: Colors.teal[700])),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                child: Text('Logout', style: TextStyle(color: Colors.teal[700])),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded, size: 30),
          tooltip: '$role Logout',
          onPressed: () => showLogoutDialog(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // menentukan tinggi appbar (wajib diisi), defaultnya kToolbarHeight
}
