import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class UserMySQLService {
  Future<bool> registerUser(
    String userid,
    String username,
    String password,
    String isActive,
    String role,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for user registration.');
        return false;
      }

      connection = connResult.connection;
      final result = await connection!.execute(
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
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error registering user: $e');
      return false;
    } finally {
      await closeMySQLConnection(connection);
      log(connection!.connected ? "Connected" : "Disconnected");
    }
  }

  Future<({Map<String, dynamic>? user, String? errorMessage})> loginUser(
    String username,
    String password,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for login.');
        return (user: null, errorMessage: connResult.error);
      }

      connection = connResult.connection;
      final result = await connection!.execute(
        "SELECT userid, username, roles, isactive FROM m_user WHERE username = :username AND password = :password AND isactive = 'T'",
        {"username": username, "password": password},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();
        log('User logged in: ${row['username']}');
        return (user: result.rows.first.assoc(), errorMessage: null);
      } else {
        log(
          'Login failed: Invalid credentials or inactive user. users: ${result.rows.length}',
        );
        // connResult.connection?.close();
        return (
          user: null,
          errorMessage: 'Username atau password salah, atau akun tidak aktif.',
        );
      }
    } catch (e) {
      log('Error during login: $e');
      return (
        user: null,
        errorMessage: 'Terjadi kesalahan saat mencoba login: $e',
      );
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all users.');
        // connResult.connection?.close();
        return [];
      }

      connection = connResult.connection;
      final result = await connection!.execute(
        "SELECT userid, username, password, roles, isactive FROM m_user",
      );
      log('Fetched ${result.rows.length} users');
      // connResult.connection?.close();
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all users: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> updateUser(UserEntity user) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating user.');
        // connResult.connection?.close();
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE m_user SET isactive = :newIsActive, roles = :newRole WHERE userid = :userid",
        {
          "newIsActive": user.isActive,
          "newRole": user.role,
          "userid": user.userid,
        },
      );

      log('User updated: ${result.affectedRows} row(s) affected.');
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating user: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllRoles() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all roles.');
        return [];
      }
      connection = connResult.connection!;
      final result = await connection.execute("SELECT * FROM m_role;");

      log('Fetched ${result.rows.length} users');
      // connResult.connection?.close();
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all users: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> deleteUser(String userid) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for deleting user.');
        return false;
      }

      connection = connResult.connection!;

      final result = await connection.execute(
        "DELETE FROM m_user WHERE userid = :userid",
        {"userid": userid},
      );
      log('User terhapus: ${result.affectedRows} row(s) affected.');
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting user: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }
}
