import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DryFractionationMySQLService {
  var className = "Dry Fractionation";

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
}
