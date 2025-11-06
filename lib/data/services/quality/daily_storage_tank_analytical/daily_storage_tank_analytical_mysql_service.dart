import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DailyStorageTankAnalyticalMySQLService {
  final String dailyStorageTankAnalyticalReport = "t_daily_storage_tank_analytical_report";

  Future<bool> insertDailyStorageTankAnalytical({
    required DailyStorageTankAnalyticalToDbEntity report,
    
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for insertChangeProductChecklist.');
        return false;
      }
      connection = connResult.connection!;

      // Start a transaction
      await connection.transactional((_) async {
        // 1. Insert the Header
        final Map<String, dynamic> reportMap = report.toMap();
        final List<String> reportColumns = [];
        final List<String> reportParams = [];
        final Map<String, dynamic> reportSqlParams = {};

        reportMap.forEach((key, value) {
          reportColumns.add('`$key`');
          reportParams.add(':$key');
          reportSqlParams[key] = value;
        });

        final String reportSql =
            'INSERT INTO $dailyStorageTankAnalyticalReport (${reportColumns.join(', ')}) VALUES (${reportParams.join(', ')})';
        await connection!.execute(reportSql, reportSqlParams);
      }); // Added closing parenthesis for transactional
    } catch (e) {
      log('Error in insertChangeProductChecklist: $e');
      return false;
    } finally {
      await connection?.close();
    }
    return true;
  } 

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return false;
      }

      connection = connResult.connection!;

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'Q01'";
      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connection.execute(sql, params);
      log(
        'Autonumber for $plantCode updated. Affected rows: ${result.affectedRows}',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating autonumber: $e');
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

  Future<String?> getLatestId(String plantCode) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return null;
      }

      connection = connResult.connection!;
      final result = await connection.execute(
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as id FROM m_controlnumber WHERE plantid = :plant AND prefix = 'Q01'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['id'];
        log("ticket id from database: ${row['id']}");

        return latestId;
      }

      return null;
    } catch (e) {
      log('Error fetching latest ticket id: $e');
      return null;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

   Future<List<Map<String, dynamic>>> getAllDailyStorageTankReport(
    String? dateFilter,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }

      connection = connResult.connection;

      // Base query
      String baseQuery = """
      SELECT 
        a.id, 
        a.company, 
        a.plant, 
        a.transaction_date, 
        a.posting_date, 
        a.tank_no, 
        a.oil_type, 
        a.kapasitas_tanki, 
        a.quantity, 
        a.empty_space, 
        a.suhu, 
        a.qp_ffa, 
        a.qp_moisture, 
        a.qp_lovibond_color_r, 
        a.qp_lovibond_color_y, 
        a.qp_iv, 
        a.qp_pv, 
        a.qp_slip_melting_point, 
        a.qp_cloud_point, 
        a.qp_anv, 
        a.qp_beta_carotene, 
        a.qp_p, 
        a.qp_dobi, 
        a.qp_totox, 
        a.qp_odor, 
        a.remarks, 
        a.flag, 
        a.entry_by, 
        a.entry_date, 
        a.prepared_by, 
        a.prepared_date, 
        a.prepared_status, 
        a.prepared_status_remarks, 
        a.approved_by, 
        a.approved_date, 
        a.approved_status, 
        a.approved_status_remarks, 
        a.updated_by, 
        a.updated_date, 
        a.form_no, 
        a.date_issued, 
        a.revision_no, 
        a.revision_date
      FROM t_daily_storage_tank_analytical_report AS a
      WHERE 
         DATE(a.transaction_date) = :date
      ORDER BY 
          a.id ASC;
""";

      final IResultSet result = await connection!.execute(baseQuery, {
        "date": dateFilter,
      });

      log('Fetched ${result.rows.length} Daily Storage Tanks reports');

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

  Future<bool> deleteDailyStorageTankAnalyticalReport(String id) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for deleteChangeProductChecklist.');
        return false;
      }
      connection = connResult.connection!;

      final String sql =
          "UPDATE $dailyStorageTankAnalyticalReport SET flag = 'D' WHERE id = :id";
      final Map<String, String> params = {"id": id};

      final result = await connection.execute(sql, params);

      log(
        'Successfully updated flag to "D" for change product checklist with ID: $id',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting change product checklist (updating flag): $e');
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

  Future<bool> updateDailyStorageTankAnalyticalReport({
  required DailyStorageTankAnalyticalToDbEntity report,
  required String id,
}) async {
  MySQLConnection? connection;
  try {
    final connResult = await getMySQLConnection();
    if (connResult.connection == null) {
      log('Failed to get MySQL connection for updateDailyStorageTankAnalyticalReport.');
      return false;
    }

    connection = connResult.connection!;
    final Map<String, dynamic> reportMap = report.toMap();

    // Build the SET clause dynamically
    final List<String> setClauses = [];
    final Map<String, dynamic> sqlParams = {};

    reportMap.forEach((key, value) {
      setClauses.add('`$key` = :$key');
      sqlParams[key] = value;
    });

    // Add the WHERE clause param
    sqlParams['id'] = id;

    final String sql = '''
      UPDATE $dailyStorageTankAnalyticalReport
      SET ${setClauses.join(', ')}
      WHERE id = :id
    ''';

    final result = await connection.execute(sql, sqlParams);

    log('Updated DailyStorageTankAnalyticalReport for ID $id. Affected rows: ${result.affectedRows}');
    return result.affectedRows > BigInt.from(0);
  } catch (e) {
    log('Error in updateDailyStorageTankAnalyticalReport: $e');
    return false;
  } finally {
    await closeMySQLConnection(connection);
  }
}

}