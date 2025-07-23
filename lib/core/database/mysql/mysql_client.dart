import 'dart:developer';

import 'package:mysql_client/mysql_client.dart';

MySQLConnection? _connection;

Future<MySQLConnection?> getMySQLConnection() async {
  if (_connection != null && _connection!.connected) {
    log('Reusing existing MySQL connection');
    return _connection;
  }
  final conn = await MySQLConnection.createConnection(
    // host: '172.30.61.192',
    host: '172.30.6.167',
    port: 3306,
    userName: 'user_wb',
    password: 'kpnwb#2025',
    // databaseName: 'logsheet_kpn_db',
    databaseName: 'logsheet_automation',
    secure: false,
  );

  try {
    await conn.connect();
    _connection = conn;
    log('Connected to MySQL');
    return _connection;
  } catch (e) {
    _connection = null;
    log('Error connecting to MySQL: $e');
    return null;
  }
}

Future<void> closeMySQLConnection() async {
  if (_connection != null && _connection!.connected) {
    try {
      await _connection!.close();
      log('MySQL connection closed.');
    } catch (e) {
      log('Error closing MySQL Connection: $e');
    } finally {
      _connection = null;
    }
  }
}
