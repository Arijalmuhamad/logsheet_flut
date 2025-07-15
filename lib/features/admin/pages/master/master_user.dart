import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/features/admin/admin_page.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/dao/user_dao.dart';

class MstUserPage extends StatefulWidget {
  final String userName;

  const MstUserPage({super.key, required this.userName});

  @override
  State<MstUserPage> createState() => _UserPageState();
}

class _UserPageState extends State<MstUserPage> {
  late final AppDatabase db;
  late final UserDao userDao;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedIsActive;
  String? selectedIsRoles;

  List<MUser> users = [];
  MUser? editingUser;
  final logger = Logger();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    userDao = UserDao(db);
    _loadUsers();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final data = await userDao.getAllUsers();
    setState(() => users = data);
  }

  void _resetForm() {
    nameController.clear();
    passwordController.clear();
    selectedIsActive = null;
    selectedIsRoles = null;
    setState(() => editingUser = null);
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    await _loadUsers();
    setState(() => isLoading = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveUser() async {
    final name = nameController.text.trim();
    final password = passwordController.text.trim();
    final isactive = selectedIsActive;
    final roles = selectedIsRoles;

    if (name.isEmpty || password.isEmpty) {
      _showSnackbar('❗ Username dan password wajib diisi');
      return;
    }

    if (isactive == null || roles == null) {
      _showSnackbar('❗ Status aktif dan peran wajib dipilih');
      return;
    }

    final uuid = Uuid();

    final user = MUsersCompanion(
      userid: drift.Value(editingUser?.userid ?? uuid.v4()),
      username: drift.Value(name),
      password: drift.Value(password),
      isactive: drift.Value(isactive),
      role: drift.Value(roles),
    );

    if (editingUser == null) {
      await userDao.insertUser(user);
      _showSnackbar('✅ User berhasil ditambahkan');
    } else {
      final updateUser = MUser(
        userid: editingUser!.userid,
        username: name,
        password: password,
        isactive: isactive,
        role: roles,
      );
      await userDao.updateUser(updateUser);
      _showSnackbar('✅ User berhasil diperbarui');
    }

    _resetForm();
    await _loadUsers();
  }

  void _editUser(MUser user) {
    nameController.text = user.username;
    passwordController.text = user.password;
    selectedIsActive = user.isactive;
    selectedIsRoles = user.role;
    setState(() => editingUser = user);
  }

  Future<void> _deleteUser(String? id) async {
    if (id == null || id.isEmpty) {
      _showSnackbar('❌ Gagal menghapus: ID user tidak valid');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Apakah Anda yakin ingin menghapus user ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await userDao.deleteUser(id);
        _showSnackbar('🗑️ User berhasil dihapus');
        await _loadUsers(); // Refresh data
      } catch (e) {
        _showSnackbar('❌ Terjadi kesalahan saat menghapus user');
      }
    }
  }

  Future<void> exportDatabase() async {
    // Meminta permission untuk akses penyimpanan
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      final manageStorageStatus =
          await Permission.manageExternalStorage.request();

      if (!storageStatus.isGranted && !manageStorageStatus.isGranted) {
        _showSnackbar('❌ Akses penyimpanan ditolak');
        return;
      }
    } else {
      _showSnackbar('❌ Export database hanya tersedia di Android');
      return;
    }

    try {
      // Path ke database internal aplikasi
      final appDir = await getApplicationDocumentsDirectory();
      final dbFile = File(
        p.join(appDir.path, 'logsheet.sqlite'),
      ); // Sesuaikan nama file

      if (!await dbFile.exists()) {
        _showSnackbar('❌ File database tidak ditemukan di direktori aplikasi');
        return;
      }

      // Path ke folder Downloads (Android)
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Salin file ke Downloads
      final copiedFile = File(
        p.join(downloadsDir.path, 'exported_logsheet.sqlite'),
      );
      await dbFile.copy(copiedFile.path);

      _showSnackbar('✅ Database berhasil diekspor ke ${copiedFile.path}');
    } catch (e, stacktrace) {
      logger.e('Export database gagal', e, stacktrace);
      _showSnackbar('❌ Gagal mengekspor database');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFEFF3F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            // centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
            title: Text(
              editingUser == null
                  ? 'Master User'
                  : 'Edit User: ${editingUser!.username}',
              style: const TextStyle(
                color: Color(0xFF655F5B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminHomePage(userName: widget.userName),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshPage,
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: exportDatabase,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          editingUser == null ? 'Tambah User' : 'Edit User',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedIsActive,
                          decoration: InputDecoration(
                            hintText: 'Select active status',
                            prefixIcon: const Icon(Icons.check_circle_outline),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'T', child: Text('Aktif')),
                            DropdownMenuItem(
                              value: 'F',
                              child: Text('Tidak Aktif'),
                            ),
                          ],
                          onChanged:
                              (value) =>
                                  setState(() => selectedIsActive = value),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedIsRoles,
                          decoration: InputDecoration(
                            hintText: 'Select role',
                            prefixIcon: const Icon(Icons.verified_user),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                            DropdownMenuItem(
                              value: 'user',
                              child: Text('User'),
                            ),
                          ],
                          onChanged:
                              (value) =>
                                  setState(() => selectedIsRoles = value),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAB2F2B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _saveUser,
                            child: Text(
                              editingUser == null ? 'Add User' : 'Update User',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Daftar User',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (_, i) {
                    final user = users[i];
                    return Card(
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
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
                          'Active: ${user.isactive == 'T' ? 'Aktif' : 'Tidak Aktif'} | Role: ${user.role}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF6B7280),
                              ),
                              onPressed: () => _editUser(user),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                // color: Color(0xFFAB2F2B),
                                color: Color(0xFFB91C1C),
                              ),
                              onPressed: () => _deleteUser(user.userid),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
