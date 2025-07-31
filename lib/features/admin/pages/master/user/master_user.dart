import 'dart:developer';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/features/admin/admin_home_page.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../../data/dao/user_dao.dart';

class MstUserPage extends StatefulWidget {
  final String userName;
  final UserEntity userEntity;

  const MstUserPage({
    super.key,
    required this.userName,
    required this.userEntity,
  });

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
                    builder:
                        (_) => AdminHomePage(
                          userName: widget.userName,
                          userEntity: widget.userEntity,
                        ),
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
                MasterAddUserCard(
                  nameController: nameController,
                  passwordController: passwordController,
                  selectedIsActive: selectedIsActive,
                  selectedIsRoles: selectedIsRoles,
                  onSave: _saveUser,
                  onActiveChanged:
                      (value) => setState(() => selectedIsActive = value),
                  onRoleChanged:
                      (value) => setState(() => selectedIsRoles = value),
                  isEdit: editingUser != null,
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
                    log(users.length.toString());
                    return UserListCard(
                      user: user,
                      onEdit: _editUser,
                      onDelete: _deleteUser,
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
