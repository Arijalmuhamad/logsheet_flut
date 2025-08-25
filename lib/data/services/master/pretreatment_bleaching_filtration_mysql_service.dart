import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/transactions/pretreatment_bleaching_filtration_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class PretreatmentBleachingFiltrationMySQLService {
  Future<bool> insert(PretreatmentBleachingFiltrationEntity entity) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for business unit registration.');
        return false;
      }
      connection = connResult.connection!;
      // insert to database logic
      List<String> columns = [];
      List<String> params = [];
      final Map<String, dynamic> entityData = entity.toMap();
      final Map<String, dynamic> sqlExecuteParams = {};

      // just for keys that has special characters
      entityData.forEach((keyInEntityMap, value) {
        String actualDbColumnName = keyInEntityMap;
        String safeParameterName = keyInEntityMap;
        dynamic formattedValue = value;

        columns.add('`$actualDbColumnName`');
        params.add(':$safeParameterName');
        sqlExecuteParams[safeParameterName] = formattedValue;
      });

      final String sql =
          'INSERT INTO t_pretreatment_bleaching_filtration (${columns.join(', ')}) VALUES (${params.join(', ')})';

      log("Generated SQL: $sql");
      log('Data for SQL: $sqlExecuteParams');
      log(
        connection.connected
            ? "Connected to the database"
            : "Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('$e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error Closing Connection: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllReportsById() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      String baseQuery = "";

      baseQuery =
          "SELECT * FROM t_pretreatment_bleaching_filtrationt_pretreatment_bleaching_filtration";

      final result = await connection!.execute(baseQuery);
      log("Fetched ${result.rows.length} reports for pretreatment.");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('$e');
      return [];
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error Closing Connection: $e");
      }
    }
  }

  // Future<bool> editReport(PretreatmentBleachingFiltrationEntity entity) async {
  //   MySQLConnection? connection;
  //   try {
  //     final connResult = await getMySQLConnection();
  //     if (connResult.connection == null) {
  //       log('Failed to get MySQL connection for get all reports.');
  //       return false;
  //     }
  //     connection = connResult.connection;

  //     final dataMap = entity.toMap();
  //     final String id = dataMap.remove("id");

  //     if (dataMap.isEmpty) {
  //       log("Update Failed: No fields to update");
  //       return false;
  //     }

  //     final updateSetQuery = dataMap.keys.map((key) => '$key = ?').join(", ");
  //   } catch (e) {
  //     log('$e');
  //     return false;
  //   } finally {
  //     try {
  //       await closeMySQLConnection();
  //       log("Is still connected: ${connection?.connected}");
  //     } catch (e) {
  //       log("Error Closing Connection: $e");
  //     }
  //   }
  // }
}
