import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DailyQualityCompositeFractionationMysqlService {
  final String dailyQualityCompositeFractionationTable =
      "t_daily_quality_composite_fractionation_500_mt";

  Future<bool> insertDailyQualityCompositeFractionationReport({
    required DailyQualityCompositeFractionationEntity report,
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
            'INSERT INTO $dailyQualityCompositeFractionationTable (${reportColumns.join(', ')}) VALUES (${reportParams.join(', ')})';
        await connection!.execute(reportSql, reportSqlParams);
      }); // Added closing parenthesis for transactional
    } catch (e) {
      log('Error in insertDailyQualityCompositeFractionation: $e');
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
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'Q03A'";
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
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as id FROM m_controlnumber WHERE plantid = :plant AND prefix = 'Q03A'",
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

  Future<List<Map<String, dynamic>>> getAllDailyQualityCompositeReport(
    String? dateFilter,
    String? role,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }

      connection = connResult.connection;
      String baseQuery = '';
      // Base query

      if (AppRoles.leadQC.contains(role)) {
        baseQuery = """
      SELECT 
       * FROM t_daily_quality_composite_fractionation_500_mt  AS a
      WHERE 
         DATE(a.transaction_date) = :date AND a.prepared_status IS NULL
      ORDER BY 
          a.id ASC;
""";
      } else {
        baseQuery = """
      SELECT *
      FROM t_daily_quality_composite_fractionation_500_mt AS a
      WHERE 
         DATE(a.transaction_date) = :date
      ORDER BY 
          a.id ASC;
""";
      }

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
        log(
          'Failed to get MySQL connection for deletedailyQualityCompositeFractionation.',
        );
        return false;
      }
      connection = connResult.connection!;

      final String sql =
          "UPDATE $dailyQualityCompositeFractionationTable SET flag = 'D' WHERE id = :id";
      final Map<String, String> params = {"id": id};

      final result = await connection.execute(sql, params);

      log(
        'Successfully updated flag to "D" for dailyQualityCompositeFractionation with ID: $id',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log(
        'Error deleting dailyQualityCompositeFractionation (updating flag): $e',
      );
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

  Future<bool> updateDailyQualityCompositeFractionationReport({
    required DailyQualityCompositeFractionationEntity report,
    required String id,
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for update DailyQualityCompositeFractionationReport.',
        );
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
      UPDATE $dailyQualityCompositeFractionationTable
      SET ${setClauses.join(', ')}
      WHERE id = :id
    ''';

      final result = await connection.execute(sql, sqlParams);

      log(
        'Updated DailyQualityCompositeFractionationReport for ID $id. Affected rows: ${result.affectedRows}',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error in update DailyQualityCompositeFractionationReport: $e');
      return false;
    } finally {
      await closeMySQLConnection(connection);
    }
  }

  Future<List<Map<String, dynamic>>>
  getAllDailyQualityCompositeApprovalReport() async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all approval reports.');
        return [];
      }

      connection = connResult.connection;

      // Query without date filter
      const String baseQuery = """
      SELECT 
      *
      FROM t_daily_quality_composite_fractionation_500_mt AS a
      ORDER BY a.id ASC;
    """;

      final IResultSet result = await connection!.execute(baseQuery);

      log(
        'Fetched ${result.rows.length} Daily Quality Composite Fractionation Approval reports',
      );

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all approval reports: $e');
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

  Future<bool> updateApproveRejectToHeader({
    required String id,
    required String approvedBy,
    required String status,
    required String role,
    String? remarks,
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updateApproveRejectToHeader.');
        return false;
      }
      connection = connResult.connection!;
      String query;
      final Map<String, dynamic> params = {
        "id": id,
        "approvedBy": approvedBy,
        "approvedDate": DateTime.now(),
        "status": status,
        "remark": remarks,
      };

      if (AppRoles.leadQC.contains(role)) {
        query = """
          UPDATE $dailyQualityCompositeFractionationTable
          SET prepared_status = :status, prepared_by = :approvedBy, prepared_date = :approvedDate, prepared_status_remarks = :remark
          WHERE id = :id
        """;
      } else if (AppRoles.qualityControlManagerApproval.contains(role)) {
        query = """
          UPDATE $dailyQualityCompositeFractionationTable
          SET checked_status = :status, checked_by = :approvedBy, checked_date = :approvedDate, checked_status_remarks = :remark
          WHERE id = :id
        """;
      } else {
        log('Invalid role provided for approval update: $role');
        return false;
      }

      final result = await connection.execute(query, params);

      log(
        'Successfully updated approval status for Change Product Checklist ID: $id by $approvedBy ($role) with status: $status',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating approval status for Change Product Checklist: $e');
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
