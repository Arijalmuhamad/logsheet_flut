import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DeodorizingFiltrationMySQLService {
  Future<bool> insertTicket(DeodorizingFiltrationEntity entity) async {
    MySQLConnection? connection;
    try {
      await closeMySQLConnection();
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for inserting pretreatment bleaching filtration ticket.',
        );
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
          'INSERT INTO t_deodorizing_filtration (${columns.join(', ')}) VALUES (${params.join(', ')})';

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
        log(
          "(DEODORIZING FILTRATION MySQL) Is still connected: ${connection?.connected}",
        );
      } catch (e) {
        log("(DEODORIZING FILTRATION MySQL) Error Closing Connection: $e");
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
      log(
        "(DEODORIZING FILTRATION MySQL) mysql function getAllLogsheet for user: $username, role: $role, plant: $plantCode",
      );
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for getAllLogsheet.',
        );
        return [];
      }
      connection = connResult.connection;

      String baseQuery;
      final Map<String, dynamic> params = {};

      switch (role) {
        case 'LEAD':
          // Query untuk Shift Leader: Hanya bisa melihat logsheet dari shift yang dipegangnya.
          baseQuery = """
            SELECT
              t.*
            FROM
              t_deodorizing_filtration t
            JOIN
              m_roles_shift_prepared rs ON t.shift = rs.shift_code
            WHERE
              rs.username = :username AND rs.isactive = :is_active AND t.plant = :plantCode AND t.posting_date >= CURRENT_DATE - INTERVAL '7' DAY AND (T.flag IS NULL OR T.flag = 'T')
          """;

          // baseQuery = """
          // SELECT * FROM t_deodorizing_filtration WHERE isactive = :is_active AND plant = :plantCode AND posting_date >= CURRENT_DATE - INTERVAL '7' DAY
          // """;
          params["username"] = username;
          params["is_active"] = "T";
          params["plantCode"] = plantCode;
          break;

        case 'OPR':
          // Query untuk Operator: Dapat melihat semua logsheet di plant-nya.
          baseQuery = """
          SELECT
            *
          FROM
            t_deodorizing_filtration
          WHERE plant = :plantCode
        """;
          params["plantCode"] = plantCode;
          break;
        case 'MGR':
          // Query untuk Manager: Hanya bisa melihat logsheet yang statusnya sudah 'Approved' oleh Shift Leader.
          baseQuery = """
          SELECT
            *
          FROM
            t_deodorizing_filtration
          WHERE
            prepared_status = :status AND plant = :plantCode AND (T.flag IS NULL OR T.flag = 'T')
        """;
          params["status"] = "Approved";
          params["plantCode"] = plantCode;
          break;
        case 'ADM':
          // Query untuk Admin: Dapat melihat semua logsheet di plant-nya.
          baseQuery =
              "SELECT * FROM t_deodorizing_filtration WHERE plant = :plantCode AND (T.flag IS NULL OR T.flag = 'T')";
          params["plantCode"] = plantCode;
          break;

        default:
          log(
            '(DEODORIZING FILTRATION MySQL) User role $role is not authorized to view logsheets.',
          );
          return [];
      }

      // 2. Add date and time filters dynamically
      if (dateFilter != null) {
        // Menggunakan DATE() untuk membandingkan hanya bagian tanggal dari kolom transaction_date
        baseQuery += " AND DATE(t.transaction_date) = :transactionDate";
        params["transactionDate"] = DateFormat('yyyy-MM-dd').format(dateFilter);
      }
      if (time != null) {
        baseQuery += " AND t.time = :time";
        params["time"] = time;
      }

      // 3. Add the ORDER BY clause for consistent sorting
      if (role == 'LEAD') {
        baseQuery += " ORDER BY t.transaction_date ASC, t.time ASC";
      } else {
        baseQuery += " ORDER BY transaction_date ASC, time ASC";
      }

      final IResultSet result = await connection!.execute(baseQuery, params);

      log("baseQuery: $baseQuery");

      log(
        '(DEODORIZING FILTRATION MySQL) Fetched ${result.rows.length} deodorizing filtration logsheet records for user $username with role $role.',
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log(
        '(DEODORIZING FILTRATION MySQL) Error getting all pretreatment bleaching filtration logsheet: $e',
      );
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log('MySQL connection closed for getAllLogsheet.');
      }
    }
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for get all deodorizing reports.',
        );
        return null;
      }
      final result = await connResult.connection!.execute(
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'FDM'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['ticket'];
        log(
          "(DEODORIZING FILTRATION MySQL) ticket id from database: ${row['ticket']}",
        );

        return latestId;
      }

      return null;
    } catch (e) {
      log('(DEODORIZING FILTRATION MySQL) Error fetching latest ticket id: $e');
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
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for updating autonumber.',
        );
        return false;
      }
      connection = connResult.connection;

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'FDM'";
      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connection!.execute(sql, params);
      log(
        '(DEODORIZING FILTRATION MySQL) Autonumber for $plantCode updated. Affected rows: ${result.affectedRows}',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('(DEODORIZING FILTRATION MySQL) Error updating autonumber: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<bool> updateTicket(DeodorizingFiltrationEntity entity) async {
    MySQLConnection? connection;

    try {
      await closeMySQLConnection();
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for editing deodorizing filtration ticket.',
        );
        return false;
      }

      connection = connResult.connection;

      List<String> setClause = [];
      final Map<String, dynamic> entityData = entity.toMap();
      final Map<String, dynamic> sqlExecuteParams = {};

      entityData.forEach((keyInEntityMap, value) {
        String actualDbColumnName = keyInEntityMap;
        String safeParameterName = keyInEntityMap;
        dynamic formattedValue = value;

        setClause.add('`$actualDbColumnName` = :$safeParameterName');
        sqlExecuteParams[safeParameterName] = formattedValue;
      });
      sqlExecuteParams['id'] = entity.id;
      final String sql =
          'UPDATE t_deodorizing_filtration SET ${setClause.join(', ')} WHERE id = :id';

      log("Generated SQL: $sql");
      log('Data for SQL: $sqlExecuteParams');
      log(
        connection!.connected
            ? "Connected to the database"
            : "Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);
      log(
        '(DEODORIZING FILTRATION MySQL) Deodorizing Filtration updated: ${result.affectedRows} row(s) affected.',
      );

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('$e');
      log(
        "(DEODORIZING FILTRATION MySQL) Is still connected: ${connection?.connected}",
      );
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log(
          "(DEODORIZING FILTRATION MySQL) Is still connected: ${connection?.connected}",
        );
      } catch (e) {
        log("(DEODORIZING FILTRATION MySQL) Error Closing Connection: $e");
      }
    }
  }

  Future<bool> sendApproveRejectReport(
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
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for Sending approve/reject PBE deodorizing filtration.',
        );
        return false;
      }
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String sql;
      Map<String, dynamic> params;

      if (userRole == "MGR") {
        sql =
            "UPDATE t_deodorizing_filtration SET checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE id = :id";
        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        };
      } else {
        sql =
            "UPDATE t_deodorizing_filtration SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE id = :id";
        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        };
      }
      final result = await connResult.connection!.execute(sql, params);
      log("Query Sent: $sql");
      log("Affected Rows: ${result.affectedRows}");
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log("$e");
      return false;
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
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
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for get reports for manager.',
        );
        return [];
      }
      connection = connResult.connection;
      const sql = """
        SELECT * FROM t_deodorizing_filtration 
        WHERE prepared_status = 'Approved' AND plant = :plantCode AND (flag IS NULL OR flag = 'T')
        ORDER BY posting_date DESC
      """;
      final result = await connection!.execute(sql, {"plantCode": plantCode});
      log(
        "(DEODORIZING FILTRATION MySQL) Fetched ${result.rows.length} reports for manager.",
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log(
        '(DEODORIZING FILTRATION MySQL) Error fetching reports for manager: $e',
      );
      return [];
    } finally {
      try {
        await closeMySQLConnection();
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<bool> deleteTicket(String id) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          "(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for deleting ticket",
        );
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE t_deodorizing_filtration SET flag = 'D' WHERE id = :id",
        {"status": "Deleted", "prepared_date": "${DateTime.now()}", "id": id},
      );
      log(
        '(DEODORIZING FILTRATION MySQL) Ticket $id terhapus: ${result.affectedRows} row(s) affected.',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('(DEODORIZING FILTRATION MySQL) Error deleting ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log(
          "(DEODORIZING FILTRATION MySQL) Is still connected: ${connection?.connected}",
        );
      } catch (e) {
        log("(DEODORIZING FILTRATION MySQL) Error closing connection: $e");
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
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for getTickets.',
        );
        return [];
      }
      connection = connResult.connection;
      String query =
          "SELECT * FROM t_deodorizing_filtration WHERE DATE(posting_date) = :dateFilter AND plant = :plantCode";

      dateFilter ??= DateTime.now();

      final Map<String, dynamic> params = {
        "dateFilter": DateFormat('yyyy-MM-dd').format(dateFilter),
        "plantCode": plantCode,
      };
      log("Params: $params");

      if (shift != null && shift != "All") {
        query += " AND shift = :shift";
        params['shift'] = shift;
      }
      log("Query: $query");
      log("Params: $params");

      final IResultSet result = await connection!.execute(query, params);
      log("DEODORIZING FILTRATION Tickets fetched: ${result.rows.length}");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log(
        "(DEODORIZING FILTRATION MySQL) Error getting all pretreatment bleaching filtration tickets: $e",
      );
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log(
          '(DEODORIZING FILTRATION MySQL) MySQL connection closed for getTickets.',
        );
      }
    }
  }
}
