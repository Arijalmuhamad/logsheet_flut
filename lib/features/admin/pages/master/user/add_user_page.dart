import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/user_entity.dart';
import 'package:logsheet_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddUserPage extends StatefulWidget {
  final UserEntity? editingUser;

  const AddUserPage({super.key, this.editingUser});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  String? selectedIsActive;
  // String? selectedIsRoles;

  final Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();

    if (widget.editingUser != null) {
      nameController.text = widget.editingUser!.username;
      passwordController.text = widget.editingUser!.password;
      selectedIsActive = widget.editingUser!.isActive;
      roleController.text = widget.editingUser!.role;
      // selectedIsRoles = widget.editingUser!.role;
    } else {
      selectedIsActive = 'T';
      // selectedIsRoles = 'user';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  Widget buildBody() {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.editingUser == null ? 'Tambah User' : 'Edit User',
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
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                hintText: 'Role',
                prefixIcon: const Icon(Icons.person_rounded),
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
                DropdownMenuItem(value: 'F', child: Text('Tidak Aktif')),
              ],
              onChanged: (value) => setState(() => selectedIsActive = value),
            ),

            const SizedBox(height: 20),
            Spacer(),
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
                onPressed: _registerUser,
                child: Text(
                  widget.editingUser == null ? 'Add User' : 'Edit User',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() => AppBar(title: const Text('Add User'));

  void _registerUser() async {
    final username = nameController.text.trim();
    final password = passwordController.text.trim();
    final role = roleController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        role.isEmpty ||
        selectedIsActive == null) {
      _showSnackBar('Mohon isi semua fields.');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final userData = UserEntity(
      userid: widget.editingUser?.userid ?? uuid.v4(),
      username: username,
      password: password,
      role: role,
      isActive: selectedIsActive!,
    );

    bool? success;

    if (widget.editingUser == null) {
      success = await userProvider.registerUser(userData);
      switch (success) {
        case null:
          _showSnackBar('Terjadi error: ${userProvider.errorMessage}');
        case false:
          _showSnackBar('Registrasi User gagal: ${userProvider.errorMessage}');
        case true:
          _showSnackBar('Registrasi User berhasil.');
          if (mounted) Navigator.pop(context);
        // _resetForm();
      }
    } else {
      _showSnackBar('TODO: Fitur edit belum jadi');
    }
    // _showSnackBar('User berhasil ditambah.');
  }
}
