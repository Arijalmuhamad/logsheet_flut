import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:mysql_client/mysql_client.dart';

class ChangeProductChecklistMySQLService {
  Future<List<Map<String, dynamic>>> getLangkahKerja() async {
    MySQLConnection? connection;
    final String langkahKerjaTable = "m_langkahkerja";

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      final String sql =
          "SELECT * FROM $langkahKerjaTable WHERE isactive = :isactive";
      final Map<String, String> parameter = {"isactive": "T"};

      final result = await connection!.execute(sql, parameter);

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all reports: $e');
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
}
