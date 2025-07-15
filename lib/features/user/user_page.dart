import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class UserHomePage extends StatefulWidget {
  final String userName;

  const UserHomePage({super.key, required this.userName});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  void _logoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'User Page',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade100),
              child: Row(
                children: const [
                  Icon(Icons.account_circle, size: 40, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    'User Menu',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings_applications_outlined),
              title: const Text('Master'),
              iconColor: Colors.blue,
              collapsedIconColor: Colors.grey,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 40),
                  leading: const Icon(Icons.person_outline),
                  title: const Text('User Management'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 40),
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('Category'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 40),
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Data Storage'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: _logoutConfirmation,
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            'Welcome, ${widget.userName}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
