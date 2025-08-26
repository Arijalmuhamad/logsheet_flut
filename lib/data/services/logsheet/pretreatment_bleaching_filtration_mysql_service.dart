import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/transactions/pretreatment_bleaching_filtration_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class PretreatmentBleachingFiltrationMySQLService {
  Future<bool> insert(PretreatmentBleachingFiltrationEntity entity) async {
    MySQLConnection? connection;
    try {
      await closeMySQLConnection();
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

  Future<List<Map<String, dynamic>>> getReportsById() async {
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
      } finally {
        try {
          await closeMySQLConnection();
        } catch (e) {
          log("$e");
        }
      }
    }
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return null;
      }
      final result = await connResult.connection!.execute(
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'PBM'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['ticket'];
        log("ticket id from database: ${row['ticket']}");

        return latestId;
      }

      return null;
    } catch (e) {
      log('Error fetching latest ticket id: $e');
      return null;
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return false;
      }
      connection = connResult.connection;

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'PBM'";
      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connection!.execute(sql, params);
      log(
        'Autonumber for $plantCode updated. Affected rows: ${result.affectedRows}',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating autonumber: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllLogsheet() async {
    MySQLConnection? connection;
    try {
      log("mysql function getAllLogsheet");

      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return [];
      }
      connection = connResult.connection;
      final sql = "SELECT * FROM t_pretreatment_bleaching_filtration";
      final result = await connection!.execute(sql);
      log(result.rows.length.toString());
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error getting all pretreatment bleaching filtration logsheet: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
      }
    }
  }
}
