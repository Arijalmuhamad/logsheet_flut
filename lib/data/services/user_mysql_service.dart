import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';

class UserMySQLService {
  Future<bool> registerUser(
    String username,
    String password,
    String isActive,
    String role,
  ) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for registration.');
      return false;
    }
    try {
      final result = await conn.execute(
        "INSET INTO m_users (userid, username, password, roles, isactive) VALUES (:username, :password, :isactive, :role)",
        {
          "username": username,
          "password": password,
          "isactive": isActive,
          "role": role,
        },
      );
      log("User registered: ${result.affectedRows} row(s) affected.");
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error registering user: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for login.');
      return null;
    }

    try {
      final result = await conn.execute(
        "SELECT userid, username, roles, isactive FROM m_user WHERE username = :username AND password = :password AND isactive = 'T'",
        {"username": username, "password": password},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();
        log('User logged in: ${row['username']}');
        return row;
      } else {
        log('Login failed: Invalid credentials or inactive user.');
        return null;
      }
    } catch (e) {
      log('Error during login: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for login.');
      return [];
    }

    try {
      final result = await conn.execute(
        "SELECT userid, username, roles, isactive FROM m_users",
      );
      log('Fetched ${result.rows.length} users');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all users: $e');
      return [];
    }
  }

  Future<bool> updateUser(
    String userid,
    String username,
    String newPassword,
    String newisActive,
    String newRole,
  ) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for updating user.');
      return false;
    }

    try {
      final result = await conn.execute(
        "UPDATE m_user SET username = :username, password = :newPassword, isactive = :newIsActive, roles = :newRole WHERE userid = :userid",
        {
          "username": username,
          "password": newPassword,
          "isactive": newisActive,
          "roles": newRole,
          "userid": userid,
        },
      );

      log('User updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deletedUser(String userid) async {
    final conn = await getMySQLConnection();

    if (conn == null) {
      log('Failed to get MySQL connection for deleting user.');
      return false;
    }

    try {
      final result = await conn.execute(
        "DELETE FROM  m_user WHERE userid = :userid",
        {"userid": userid},
      );
      log('User Deleted: ${result.affectedRows} row(s) affected');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting user: $e');
    }
    return true;
  }
}
