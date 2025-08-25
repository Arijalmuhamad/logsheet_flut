import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:mysql_client/mysql_client.dart';

class DataFormNoMySQLService {
  Future<List<Map<String, dynamic>>> getAllDataFormNo() async {
    MySQLConnection? connection;
    try {
      await closeMySQLConnection();
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for business unit registration.');
      }

      connection = connResult.connection!;
      final result = await connection.execute("SELECT * FROM m_data_form_no");
      log("Fetched ${result.numOfRows} forms number");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all data forms: $e');
      return [];
    } finally {
      await closeMySQLConnection();
    }
  }
}
