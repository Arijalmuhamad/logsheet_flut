import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/master/user/add_user_page.dart';
import 'package:logsheet_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<UserProvider>(context, listen: false).fetchAllUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah User diklik");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => (AddUserPage())),
          );
        },
        label: const Text(
          "Tambah User",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar buildAppBar() => AppBar(title: const Text('Users'));

  Widget buildBody(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (userProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error: ${userProvider.errorMessage!}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (userProvider.listUser.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tidak ada User dalam database.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: userProvider.listUser.length,
          itemBuilder: (context, index) {
            final user = userProvider.listUser[index];
            return Card(
              elevation: 2,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: const Icon(
                  Icons.person,
                  color: Color(0xFF6B7280),
                  size: 40,
                ),
                title: Text(
                  user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF655F5B),
                  ),
                ),
                subtitle: Text(
                  'Active: ${user.isActive == 'T' ? 'Aktif' : 'Tidak Aktif'} | Role: ${user.role}',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        // color: Color(0xFFAB2F2B),
                        color: Color(0xFFB91C1C),
                      ),
                      onPressed: () async {
                        log('Icon delete diklik');

                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Hapus ${user.username}?'),
                                content: Text(
                                  'Apakah anda yakin ingin menghapus ${user.username}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text("Ya"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text("Tidak"),
                                  ),
                                ],
                              ),
                        );
                        if (confirmDelete == true) {
                          bool success = await userProvider.deleteUser(
                            user.userid,
                          );
                          if (success) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'User ${user.username} berhasil dihapus.',
                                ),
                              ),
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal menghapus user ${user.username}: ${userProvider.errorMessage}',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
