import 'package:flutter/material.dart';
import '../views/login_page.dart';
import 'custom_alert_dialog.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String role;

  CustomAppbar({required this.title, required this.role});

  void _showLogoutDialog(BuildContext context) {
    customAlertDialog(
      context: context,
      title: '$role Logout',
      content: 'Apakah Anda yakin ingin logout?',
      onConfirm: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.teal[700],
          fontWeight: FontWeight.w600,
          fontSize: 21,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded, size: 30),
          tooltip: '$role Logout',
          onPressed: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // menentukan tinggi appbar (wajib diisi), defaultnya kToolbarHeight
}
