import 'dart:async';
import 'dart:developer';

import 'package:mysql_client/mysql_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

MySQLConnection? _connection;

Future<({MySQLConnection? connection, String? error})>
getMySQLConnection() async {
  if (_connection != null && _connection!.connected) {
    log('Reusing existing MySQL connection');
    return (connection: _connection, error: null);
  }
  final conn = await MySQLConnection.createConnection(
    // host: '172.30.61.192',
    // host: dotenv.env['DB_HOST'],
    // userName: dotenv.env['DB_USER']!,
    // password: dotenv.env['DB_PASSWORD']!,
    // databaseName: dotenv.env['DB_NAME'],
    host: '172.30.6.167',
    userName: 'user_wb',
    password: 'kpnwb#2025',
    databaseName: 'logsheet_automation',
    port: int.parse(dotenv.env['DB_PORT']!),
    secure: false,
  ).timeout(
    Duration(seconds: 30),
    onTimeout: () {
      throw TimeoutException(
        'Koneksi ke database gagal: Waktu koneksi habis. Pastikan perangkat Anda terhubung ke jaringan yang benar dan IP database dapat dijangkau.',
      );
    },
  );

  try {
    await conn.connect();
    _connection = conn;
    log('Connected to MySQL');
    return (connection: _connection, error: null);
  } on TimeoutException catch (e) {
    return (connection: null, error: e.message);
  } catch (e) {
    log('Error connecting to MySQL: $e');
    conn.close;
    _connection = null;
    return (
      connection: null,
      error:
          'Koneksi ke database gagal: Terjadi masalah jaringan atau konfigurasi. (${e.toString()})',
    );
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
