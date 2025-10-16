import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DryFractionationMySQLService {
  final className = "Dry Fractionation";

  // INSERT FUNCTIONS
  Future<String?> getLatestTicketId(String plantCode) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return null;
      }

      connection = connResult.connection;
      final result = await connection!.execute(
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'DFM'",
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
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return false;
      }

      connection = connResult.connection;

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'DFM'";

      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connection!.execute(sql, params);
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('($className) Error updating autonumber: $e');
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

  Future<bool> insertTicket(DryFractionationEntity entity) async {
    MySQLConnection? connection;

    try {
      var connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(Quality Report QC MySQL) Failed to get MySQL connection for insert ticket.',
        );
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

        columns.add('`$actualDbColumnName`');
        params.add(':$safeParameterName');
        sqlExecuteParams[safeParameterName] = formattedValue;
      });

      final String sql =
          'INSERT INTO t_dry_fractionation (${columns.join(', ')}) VALUES (${params.join(', ')})';

      log("($className) Generated SQL: $sql");
      log('($className) Data for SQL: $sqlExecuteParams');
      log(
        connection!.connected
            ? "Connected to the database"
            : "Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error inserting Quality Report Refinery Report: $e');
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

  // Get All Tickets
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
        case 'LEAD' ||
            'LEAD_PROD' ||
            'OPR' ||
            'OPR_PROD' ||
            'MGR' ||
            'MGR_PROD' ||
            'ADM':
          baseQuery = """
          SELECT
            *
          FROM 
            t_dry_fractionation
          WHERE plant = :plantCode AND (flag IS NULL OR flag = 'T')
          """;
          params["plantCode"] = plantCode;
          break;

        default:
          log('User role $role is not authorized to view reports.');
          return [];
      }

      if (dateFilter != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND report_date = :reportDate";
        } else {
          baseQuery += " WHERE report_date = :reportDate";
        }
        params['reportDate'] = dateFilter;
      }

      if (time != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND time = :time";
        } else {
          baseQuery += " WHERE time = :time";
        }
        params["time"] = time;
      }

      baseQuery += " ORDER BY transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      log(
        'Fetched ${result.rows.length} reports for user $username with role $role.',
      );
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

  // Delete Ticket by ID
  Future<bool> deleteTicket(String id, String username) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          "($className MySQL) Failed to get MySQL connection for deleting ticket",
        );
        return false;
      }

      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE t_dry_fractionation SET flag = 'D', prepared_by = :username, prepared_status = :prepared_status, prepared_date = :prepared_date WHERE id = :id",
        {
          "username": username,
          "prepared_status": "Deleted",
          "prepared_date": "${DateTime.now()}",
          "id": id,
        },
      );

      log(
        '($className MySQL) Ticket $id terhapus: ${result.affectedRows} row(s) affected.',
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('($className MySQL) Error deleting ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("($className MySQL) Is still connected: ${connection?.connected}");
      } catch (e) {
        log("($className MySQL) Error closing connection: $e");
      }
    }
  }

  // Update Ticket
  Future<bool> updateTicket(DryFractionationEntity entity) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          "($className MySQL) Failed to get MySQL connection for deleting ticket",
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
          'UPDATE t_dry_fractionation SET ${setClause.join(', ')} WHERE id = :id';

      log("($className MySQL) Generated SQL: $sql");
      log('($className MySQL) Data for SQL: $sqlExecuteParams');
      log(
        connection!.connected
            ? "($className MySQL) Connected to the database"
            : "($className MySQL) Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);
      log(
        '($className MySQL) updated: ${result.affectedRows} row(s) affected.',
      );

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('($className MySQL) Error updating ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("($className MySQL) Is still connected: ${connection?.connected}");
      } catch (e) {
        log("($className MySQL) Error closing connection: $e");
      }
    }
  }

  // SEND APPROVAL REJECT TICKET
  Future<bool> sendApproveRejectTicket(
    final String username,
    final String status,
    final String userRole,
    final String? remark,
    final String id,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '($className MySQL)Failed to get MySQL connection for Sending approve/reject Daily Production Refinery report.',
        );
        return false;
      }
      connection = connResult.connection;
      final date = DateTime.now();
      String? sql;
      Map<String, dynamic>? params;

      if (AppRoles.managerProd.contains(userRole)) {
        sql =
            "UPDATE t_dry_fractionation SET checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE id = :id";
        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        };
      } else if (AppRoles.leadProd.contains(userRole)) {
        sql =
            "UPDATE t_dry_fractionation SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE id = :id";
        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        };
      }
      final result = await connResult.connection!.execute(sql ?? "", params);
      log("Query Sent: $sql");
      log("Affected Rows: ${result.affectedRows}");
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log("$e");
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log("$e");
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
          "SELECT * FROM t_dry_fractionation WHERE DATE(posting_date) = :dateFilter AND plant = :plantCode";

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
      log("PRM Tickets fetched: ${result.rows.length}");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log("($className MySQL) Error getting all $className tickets: $e");
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log('($className MySQL) MySQL connection closed for getTickets.');
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
          '($className MySQL) Failed to get MySQL connection for get reports for manager.',
        );
        return [];
      }
      connection = connResult.connection;
      const sql = """
        SELECT * FROM t_dry_fractionation 
        WHERE prepared_status = 'Approved' AND plant = :plantCode AND (flag IS NULL OR flag = 'T')
        ORDER BY posting_date DESC
      """;
      final result = await connection!.execute(sql, {"plantCode": plantCode});
      log(
        "($className MySQL) Fetched ${result.rows.length} reports for manager.",
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('($className MySQL) Error fetching reports for manager: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log("$e");
      }
    }
  }
}
