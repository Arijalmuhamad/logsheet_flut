import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_report_production_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class QualityReportProductionMySQLService {
  Future<bool> insertTicket(QualityReportProductionEntity entity) async {
    MySQLConnection? connection;
    try {
      var connResult = await getMySQLConnection();
      await closeMySQLConnection();
      log("closed? ${connResult.connection?.connected}");
      connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for business unit registration.');
        return false;
      }

      connection = connResult.connection;

      List<String> columns = [];
      List<String> params = [];
      final Map<String, dynamic> entityData = entity.toMap();
      final Map<String, dynamic> sqlExecuteParams = {};

      entityData.forEach((keyInEntityMap, value) {
        String actualDbColumnName = keyInEntityMap;
        String safeParameterName = keyInEntityMap;
        dynamic formattedValue = value;

        if (keyInEntityMap == 'transaction_date' ||
            keyInEntityMap == 'posting_date' ||
            keyInEntityMap == 'entry_date') {
          if (value != null && value is DateTime) {
            formattedValue = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
          }
        }

        if (keyInEntityMap == 'rm_mni') {
          actualDbColumnName = 'rm_m&i';
          safeParameterName = 'rm_mni_param';
        } else if (keyInEntityMap == 'fg_mni') {
          actualDbColumnName = 'fg_m&i';
          safeParameterName = 'fg_mni_param';
        } else if (keyInEntityMap == 'bp_mni') {
          actualDbColumnName = 'bp_m&i';
          safeParameterName = 'bp_mni_param';
        } else if (keyInEntityMap == 'wsbeqc') {
          actualDbColumnName = 'w_sbe_qc';
          safeParameterName = 'w_sbe_qc_param';
        } else if (keyInEntityMap == 'w_sbe_mni') {
          actualDbColumnName = 'w_sbe_m&i';
          safeParameterName = 'w_sbe_mni_param';
        } else if (keyInEntityMap == 'w_sbe_m&i') {
          actualDbColumnName = 'w_sbe_m&i';
          safeParameterName = 'w_sbe_mni_param';
        }

        columns.add('`$actualDbColumnName`');
        params.add(':$safeParameterName');
        sqlExecuteParams[safeParameterName] = formattedValue;
      });

      final String sql =
          'INSERT INTO t_quality_report_refinery (${columns.join(', ')}) VALUES (${params.join(', ')})';

      // final String sql =
      //     'INSERT INTO t_quality_report_refinery_2 (`id`) VALUES ("QRMPS2125000108")';

      log('Generated SQL: $sql');
      log('Data for SQL: $sqlExecuteParams');
      log(
        connection!.connected
            ? "Connected to the database"
            : "Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);

      // connResult.connection?.close();

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error inserting Quality Report Refinery Report: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllTickets(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      String baseQuery;
      final Map<String, dynamic> params = {};

      switch (role) {
        case 'LEAD' || 'LEAD_PROD':
          baseQuery = """
          SELECT
            t_quality_report_refinery.*
          FROM
            t_quality_report_refinery
          JOIN
            m_roles_shift_prepared ON t_quality_report_refinery.shift = m_roles_shift_prepared.shift_code
          WHERE
            m_roles_shift_prepared.username = :username AND m_roles_shift_prepared.isactive = :is_active AND t_quality_report_refinery.plant = :plantCode AND (t_quality_report_refinery.flag IS NULL OR t_quality_report_refinery.flag = 'T') 
        """;
          params["username"] = username;
          params["is_active"] = "T";
          params["plantCode"] = plantCode;
          break;
        case 'OPR':
          baseQuery = """
          SELECT
            *
          FROM
            t_quality_report_refinery
          WHERE plant = :plantCode AND (t_quality_report_refinery.flag IS NULL OR t_quality_report_refinery.flag = 'T') 
        """;

          params["plantCode"] = plantCode;
          break;

        case 'MGR' || 'MGR_PROD':
          baseQuery = """
          SELECT
            *
          FROM
            t_quality_report_refinery
          WHERE
            prepared_status = :status AND plant = :plantCode AND (flag IS NULL OR flag = 'T') 
        """;
          params["status"] = "Approved";
          params["plantCode"] = plantCode;
          break;
        case 'ADM':
          // Query for Admin: Can see all reports.
          baseQuery =
              "SELECT * FROM t_quality_report_refinery WHERE plant = :plantCode AND (flag IS NULL OR flag = 'T')";
          params["plantCode"] = plantCode;
          break;

        default:
          log('User role $role is not authorized to view reports.');
          return [];
      }

      // Add date and time filters to the query for all roles
      if (dateFilter != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND report_date = :reportDate";
        } else {
          baseQuery += " WHERE report_date = :reportDate";
        }
        params["reportDate"] = dateFilter;
      }
      if (time != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND time = :time";
        } else {
          baseQuery += " WHERE time = :time";
        }
        params["time"] = time;
      }

      // Add the ORDER BY clause
      baseQuery += " ORDER BY transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      log(
        'Fetched ${result.rows.length} reports for user $username with role $role.',
      );
      await closeMySQLConnection();
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all reports: $e');
      return [];
    }
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return null;
      }
      final result = await connResult.connection!.execute(
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'QRRM'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['ticket'];
        log("ticket id from database: ${row['ticket']}");

        return latestId;
      }
      await closeMySQLConnection();
      return null;
    } catch (e) {
      log('Error fetching latest ticket id: $e');
      return null;
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return false;
      }

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'QRRM'";
      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connResult.connection!.execute(sql, params);
      log(
        'Autonumber for $plantCode updated. Affected rows: ${result.affectedRows}',
      );
      connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating autonumber: $e');
      return false;
    }
  }

  Future<bool> updateTicket(QualityReportProductionEntity entity) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating ticket.');
        return false;
      }

      connection = connResult.connection;

      final entityData = entity.toMap();
      final List<String> setClause = [];
      final Map<String, dynamic> sqlExecuteParams = {};

      entityData.forEach((keyInEntityMap, value) {
        if (keyInEntityMap != 'id' || keyInEntityMap != 'id_fk') {
          String actualDbColumnName = keyInEntityMap;
          String safeParameterName = keyInEntityMap;

          // Handle specific column name mappings
          if (keyInEntityMap == 'rm_mni') {
            actualDbColumnName = 'rm_m&i';
            safeParameterName = 'rm_mni_param';
          } else if (keyInEntityMap == 'fg_mni') {
            actualDbColumnName = 'fg_m&i';
            safeParameterName = 'fg_mni_param';
          } else if (keyInEntityMap == 'bp_mni') {
            actualDbColumnName = 'bp_m&i';
            safeParameterName = 'bp_mni_param';
          } else if (keyInEntityMap == 'wsbeqc') {
            actualDbColumnName = 'w_sbe_qc';
            safeParameterName = 'w_sbe_qc_param';
          } else if (keyInEntityMap == 'w_sbe_mni') {
            actualDbColumnName = 'w_sbe_m&i';
            safeParameterName = 'w_sbe_mni_param';
          } else if (keyInEntityMap == 'w_sbe_m&i') {
            actualDbColumnName = 'w_sbe_m&i';
            safeParameterName = 'w_sbe_mni_param';
          }

          setClause.add('`$actualDbColumnName` = :$safeParameterName');
          sqlExecuteParams[safeParameterName] = value;
        }
      });
      sqlExecuteParams['id'] = entity.idFk;

      final sql =
          "UPDATE t_quality_report_refinery SET ${setClause.join(', ')} WHERE id_fk = :id";

      log('Generated UPDATE SQL: $sql');
      log('Params for SQL: $sqlExecuteParams');

      final result = await connection!.execute(sql, sqlExecuteParams);
      log('ticket updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating report: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log('$e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReportsForManager(
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      final result = await connection!.execute(
        "SELECT * FROM t_quality_report_refinery WHERE prepared_status = 'Approved' AND plant = :plantCode AND (flag IS NULL OR flag = 'T');",
        {"plantCode": plantCode},
      );
      log('Fetched ${result.rows.length} row.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all prepared transactions: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<bool> sendApproveRejectTicket(
    final String username,
    final String status,
    final String userRole,
    final int shift,
    final String? remark,
    final String id,
  ) async {
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for sending approve/reject ticket.',
        );
        return false;
      }
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (userRole == "MGR" || userRole == "MGR_PROD") {
        final sql =
            "UPDATE t_quality_report_refinery SET checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE id = :id";

        final result = await connResult.connection!.execute(sql, {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        });
        log("Query Sent: $sql");
        log("Affected Rows: ${result.affectedRows}");
        connResult.connection?.close();
        return result.affectedRows > BigInt.from(0);
      } else {
        final sql =
            "UPDATE t_quality_report_refinery SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE id = :id";

        final result = await connResult.connection!.execute(sql, {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        });
        log("Query Sent: $sql");
        log("Affected Rows: ${result.affectedRows}");
        return result.affectedRows > BigInt.from(0);
      }
    } catch (e) {
      log("Error sending approve or reject ticket");
      return false;
    }
  }

  Future<List<int>> getReportedHours(
    DateTime dateFilter,
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return [];
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "SELECT time FROM t_quality_report_refinery WHERE date(posting_date) = :date AND plant = :plantCode AND (flag IS NULL OR flag = 'T');",
        {"date": dateFilter, "plantCode": plantCode},
      );

      final List<int> hours = [];
      for (final row in result.rows) {
        // row.assoc() converts the row into a Map<String, dynamic>
        // We access the 'time' column and cast it to an int.
        // It's good practice to handle potential nulls or incorrect types.
        final timeValue = row.assoc()['time'];
        if (timeValue is int && timeValue != null) {
          log(timeValue);
          hours.add(int.tryParse(timeValue) ?? 0);
        }
      }
      return hours;
    } catch (e) {
      return [];
    } finally {
      await closeMySQLConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getReadyForManagerApprovalReports() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for manager alerts.');
        return [];
      }
      connection = connResult.connection!;
      log('attempting the select query.');
      final result = await connection.execute("""
          SELECT
            DATE(posting_date) as report_date,
            work_center,
            oil_type
          FROM
            t_quality_report_refinery
          WHERE
            (flag IS NULL OR flag = 'T') AND
            posting_date >= CURDATE() - INTERVAL 7 DAY
          GROUP BY
            DATE(posting_date),
            work_center,
            oil_type
          HAVING
           SUM(shift in (1,2,3,4,5) AND prepared_status = 'Approved') = 24
          AND
            COUNT(checked_status) < 24;
          """);
      log('done selecting.');
      log("Affected Rows: ${result.affectedRows}");

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching reports ready for manager approval: $e');
      return [];
    } finally {
      await closeMySQLConnection();
    }
  }

  Future<bool> deleteTicket(String id) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for deleting ticket.');
        return false;
      }

      connection = connResult.connection!;

      final result = await connection.execute(
        // "DELETE FROM t_quality_report_refinery WHERE id = :id", // Delete query
        "UPDATE t_quality_report_refinery SET flag = 'D' WHERE id_fk = :id", // Delete with Flag
        {"status": "Deleted", "date": "${DateTime.now()}", "id": id},
      );
      log('Ticket $id terhapus: ${result.affectedRows} row(s) affected.');
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error closing connection: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getTickets(
    DateTime? dateFilter,
    String plantCode, {
    String? shift = "All",
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for getTickets.');
        return [];
      }
      connection = connResult.connection;
      String query =
          "SELECT * FROM t_quality_report_refinery WHERE DATE(posting_date) = :dateFilter AND plant = :plantCode";

      dateFilter ??= DateTime.now();

      final Map<String, dynamic> params = {
        "dateFilter": DateFormat('yyyy-MM-dd').format(dateFilter),
        "plantCode": plantCode,
      };
      log("Params: $params");

      if (shift != "All") {
        query += " AND shift = :shift";
        params['shift'] = shift;
      }
      log("Query: $query");
      log("Params: $params");

      final IResultSet result = await connection!.execute(query, params);
      log("QR Tickets fetched: ${result.rows.length}");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log("(QR MySQL) Error getting all Quality Report tickets: $e");
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log('(QR MySQL) MySQL connection closed for getTickets.');
      }
    }
  }
}
