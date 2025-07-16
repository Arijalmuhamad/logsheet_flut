import 'package:flutter/material.dart';

class MasterAddUserCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final String? selectedIsActive;
  final String? selectedIsRoles;
  final VoidCallback onSave;
  final ValueChanged<String?> onActiveChanged;
  final ValueChanged<String?> onRoleChanged;
  final bool isEdit;

  const MasterAddUserCard({
    super.key,
    required this.nameController,
    required this.passwordController,
    required this.selectedIsActive,
    required this.selectedIsRoles,
    required this.onSave,
    required this.onActiveChanged,
    required this.onRoleChanged,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isEdit ? 'Edit User' : 'Tambah User',
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
                DropdownMenuItem(value: 'F', child: Text('Tidak Aktif')),
              ],
              onChanged: onActiveChanged,
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
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'user', child: Text('User')),
              ],
              onChanged: onRoleChanged,
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
                onPressed: onSave,
                child: Text(
                  isEdit ? 'Update User' : 'Add User',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
