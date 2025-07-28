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

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            itemCount: userProvider.listUser.length,
            itemBuilder: (context, index) {
              final user = userProvider.listUser[index];
              return Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surface,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(25),
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(200),

                      size: 48,
                    ),
                  ),
                  title: Text(
                    user.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF655F5B),
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            user.role,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child:
                                user.isActive == 'T'
                                    ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 17,
                                    )
                                    : Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.red,
                                      size: 17,
                                    ),
                          ),
                          Text(
                            user.isActive == 'T' ? 'Aktif' : 'Tidak Aktif',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddUserPage(editingUser: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          // color: Color(0xFFAB2F2B),
                          color: Theme.of(context).colorScheme.error,
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
                                          () => Navigator.pop(context, false),
                                      child: const Text(
                                        "Tidak",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text("Ya"),
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
          ),
        );
      },
    );
  }
}
