import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/app_database.dart';

class UserListCard extends StatelessWidget {
  const UserListCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final MUser user;
  final void Function(MUser) onEdit;
  final Future<void> Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    log(user.toString());
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.person, color: Color(0xFF6B7280), size: 40),
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
              icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
              onPressed: () => onEdit(user),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                // color: Color(0xFFAB2F2B),
                color: Color(0xFFB91C1C),
              ),
              onPressed: () async => await onDelete(user.userid),
            ),
          ],
        ),
      ),
    );
  }
}
