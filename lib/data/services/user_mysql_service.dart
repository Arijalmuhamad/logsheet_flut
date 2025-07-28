import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/role_entity.dart';
import 'package:logsheet_app/data/remote/user_entity.dart';

class UserMySQLService {
  Future<bool> registerUser(
    String userid,
    String username,
    String password,
    String isActive,
    String role,
  ) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for user registration.');
      return false;
    }
    try {
      final result = await conn.execute(
        "INSERT INTO m_user (userid, username, password, roles, isactive) VALUES (:userid, :username, :password, :role, :isactive)",
        {
          "userid": userid,
          "username": username,
          "password": password,
          "role": role,
          "isactive": isActive,
        },
      );
      log(
        "User $username teregistrasi: ${result.affectedRows} row(s) affected.",
      );
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
      log('Failed to get MySQL connection for get all users.');
      return [];
    }

    try {
      final result = await conn.execute(
        "SELECT userid, username, password, roles, isactive FROM m_user",
      );
      log('Fetched ${result.rows.length} users');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all users: $e');
      return [];
    }
  }

  Future<bool> updateUser(UserEntity user) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for updating user.');
      return false;
    }

    try {
      final result = await conn.execute(
        "UPDATE m_user SET isactive = :newIsActive, roles = :newRole WHERE userid = :userid",
        {
          "newIsActive": user.isActive,
          "newRole": user.role,
          "userid": user.userid,
        },
      );

      log('User updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating user: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllRoles() async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for get all roles.');
      return [];
    }

    try {
      final result = await conn.execute("SELECT * FROM m_role;");

      log('Fetched ${result.rows.length} users');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all users: $e');
      return [];
    }
  }

  Future<bool> deleteUser(String userid) async {
    final conn = await getMySQLConnection();

    if (conn == null) {
      log('Failed to get MySQL connection for deleting user.');
      return false;
    }

    try {
      final result = await conn.execute(
        "DELETE FROM m_user WHERE userid = :userid",
        {"userid": userid},
      );
      log('User terhapus: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting user: $e');
      return false;
    }
  }
}
