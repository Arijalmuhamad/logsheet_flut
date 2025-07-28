import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/role_entity.dart';
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
  // final TextEditingController roleController = TextEditingController();

  String? selectedIsActive;
  bool _isEditing = false;
  String? selectedRole;

  final Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<UserProvider>(context, listen: false).fetchAllRoles(),
    );

    if (widget.editingUser != null) {
      nameController.text = widget.editingUser!.username;
      passwordController.text = widget.editingUser!.password;
      selectedIsActive = widget.editingUser!.isActive;
      // roleController.text = widget.editingUser!.role;
      _isEditing = true;
      selectedRole = widget.editingUser!.role;
    } else {
      selectedIsActive = 'T';
      _isEditing = false;
      selectedRole = 'ADM';
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
              // readOnly: _isEditing,
              enabled: !_isEditing,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Enter your name',
                prefixIcon: Icon(
                  Icons.person,
                  color: _isEditing ? Colors.grey[500] : Colors.black,
                ),
                filled: true,
                fillColor: _isEditing ? Colors.grey[300] : Color(0xFFF0ECE9),
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
              enabled: !_isEditing,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: _isEditing ? Colors.grey[500] : Colors.black,
                ),
                filled: true,
                fillColor: _isEditing ? Colors.grey[300] : Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // TextField(
            //   controller: roleController,
            //   decoration: InputDecoration(
            //     hintText: 'Role',
            //     prefixIcon: const Icon(Icons.person_rounded),
            //     filled: true,
            //     fillColor: const Color(0xFFF0ECE9),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //       borderSide: BorderSide.none,
            //     ),
            //   ),
            // ),
            // DropdownButtonFormField<String>(items: , onChanged: onChanged),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {}
                if (userProvider.errorMessage != null) {
                  return Text(
                    'Error: ${userProvider.errorMessage!}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  );
                }

                final roleList = userProvider.listRoles;
                return DropdownButtonFormField<String>(
                  value: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value),
                  items:
                      roleList.map<DropdownMenuItem<String>>((RoleEntity role) {
                        return DropdownMenuItem<String>(
                          value: role.code,
                          child: Text('${role.code} - ${role.name}'),
                        );
                      }).toList(),
                );
              },
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
                  widget.editingUser == null ? 'Add User' : 'Edit User Role',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() => AppBar(
    title: Text(widget.editingUser == null ? 'Add User' : 'Edit User Role'),
  );

  void _registerUser() async {
    final username = nameController.text.trim();

    if (username.isEmpty || selectedRole == null || selectedIsActive == null) {
      _showSnackBar('Mohon isi semua fields.');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final userData = UserEntity(
      userid: widget.editingUser?.userid ?? uuid.v4(),
      username: username,
      password: '',
      role: selectedRole!,
      isActive: selectedIsActive!,
    );

    bool? success;

    if (_isEditing) {
      success = await userProvider.updateUser(userData);
    } else {
      success = await userProvider.registerUser(userData);
    }
    switch (success) {
      case null:
        _showSnackBar('Terjadi error: ${userProvider.errorMessage}');
      case false:
        _showSnackBar('Registrasi User gagal: ${userProvider.errorMessage}');
      case true:
        _showSnackBar('Registrasi User berhasil.');
        userProvider.fetchAllUsers();
        if (mounted) Navigator.pop(context);
      // _resetForm();
    }

    // _showSnackBar('User berhasil ditambah.');
  }
}
