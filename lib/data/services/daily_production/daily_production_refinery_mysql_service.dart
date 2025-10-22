import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DailyProductionRefineryMySQLService {
  Future<bool> insertTicket(DailyProductionRefineryEntity entity) async {
    MySQLConnection? connection;

    try {
      var connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(Daily Production Refinery MySQL) Failed to get MySQL connection for insert ticket.',
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
          'INSERT INTO t_daily_production_refinery (${columns.join(', ')}) VALUES (${params.join(', ')})';
      log('Generated SQL: $sql');
      log('Data for SQL: $sqlExecuteParams');
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
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.shift,
            a.cpo_tank,
            a.oil_type_rm AS oil_type_rm_id,
            b.raw_material AS oil_type_rm,
            a.oil_type_rm_awal_jam,
            a.oil_type_rm_awal_flowmeter,
            a.oil_type_rm_akhir_jam,
            a.oil_type_rm_akhir_flowmeter,
            a.oil_type_rm_total,
            a.oil_type_fg AS oil_type_fg_id,
            b.finish_good AS oil_type_fg,
            a.oil_type_fg_awal_jam,
            a.oil_type_fg_awal_flowmeter,
            a.oil_type_fg_akhir_jam,
            a.oil_type_fg_akhir_flowmeter,
            a.oil_type_fg_total,
            a.oil_type_fg_to_tank,
            a.bp_oil_type AS bp_oil_type_id,
            b.by_product AS bp_oil_type,
            a.bp_awal_jam,
            a.bp_awal_flowmeter,
            a.bp_akhir_jam,
            a.bp_akhir_flowmeter,
            a.bp_total,
            a.bp_to_tank,
            a.be_ref_tank,
            a.be_ref_qty,
            a.be_total_bag,
            a.be_total_jenis,
            a.be_lot_batch_number,
            a.be_yield_percent,
            a.pa_ref_tank,
            a.pa_ref_qty,
            a.pa_total,
            a.pa_lot_batch_number,
            a.pa_yield_percent,
            a.remarks,
            a.flag,
            a.uu_item,
            a.uu_budget_ref_tank,
            a.uu_budget_qty,
            a.uu_total_cpo,
            a.uu_total_steam,
            a.uu_steam_cpo,
            a.uu_yield_percent,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.verified_by,
            a.verified_date,
            a.verified_status,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date
          FROM 
                t_daily_production_refinery AS a
          JOIN m_product AS b 
          ON a.oil_type_rm = b.id
          WHERE
            a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
  
          """;

          params["plantCode"] = plantCode;
          break;
        case 'OPR' || 'OPR_PROD' || 'MGR' || 'MGR_PROD':
          baseQuery = """
        SELECT
          a.id,
          a.company,
          a.plant,
          a.transaction_date,
          a.posting_date,
          a.work_center,
          a.shift,
          a.cpo_tank,
          a.oil_type_rm AS oil_type_rm_id,
          b.raw_material AS oil_type_rm,
          a.oil_type_rm_awal_jam,
          a.oil_type_rm_awal_flowmeter,
          a.oil_type_rm_akhir_jam,
          a.oil_type_rm_akhir_flowmeter,
          a.oil_type_rm_total,
          a.oil_type_fg AS oil_type_fg_id,
          b.finish_good AS oil_type_fg,
          a.oil_type_fg_awal_jam,
          a.oil_type_fg_awal_flowmeter,
          a.oil_type_fg_akhir_jam,
          a.oil_type_fg_akhir_flowmeter,
          a.oil_type_fg_total,
          a.oil_type_fg_to_tank,
          a.bp_oil_type AS bp_oil_type_id,
          b.by_product AS bp_oil_type,
          a.bp_awal_jam,
          a.bp_awal_flowmeter,
          a.bp_akhir_jam,
          a.bp_akhir_flowmeter,
          a.bp_total,
          a.bp_to_tank,
          a.be_ref_tank,
          a.be_ref_qty,
          a.be_total_bag,
          a.be_total_jenis,
          a.be_lot_batch_number,
          a.be_yield_percent,
          a.pa_ref_tank,
          a.pa_ref_qty,
          a.pa_total,
          a.pa_lot_batch_number,
          a.pa_yield_percent,
          a.remarks,
          a.flag,
          a.uu_item,
          a.uu_budget_ref_tank,
          a.uu_budget_qty,
          a.uu_total_cpo,
          a.uu_total_steam,
          a.uu_steam_cpo,
          a.uu_yield_percent,
          a.entry_by,
          a.entry_date,
          a.prepared_by,
          a.prepared_date,
          a.prepared_status,
          a.prepared_status_remarks,
          a.verified_by,
          a.verified_date,
          a.verified_status,
          a.checked_by,
          a.checked_date,
          a.checked_status,
          a.checked_status_remarks,
          a.form_no,
          a.date_issued,
          a.revision_no,
          a.revision_date
        FROM 
          t_daily_production_refinery AS a
        JOIN m_product AS b 
        ON a.oil_type_rm = b.id
        WHERE
          a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T') 
        """;
          params["plantCode"] = plantCode;
          break;

        case 'ADM':
          // Query for Admin: Can see all reports.
          baseQuery = """
              SELECT
                a.id,
                a.company,
                a.plant,
                a.transaction_date,
                a.posting_date,
                a.work_center,
                a.shift,
                a.cpo_tank,
                a.oil_type_rm AS oil_type_rm_id,
                b.raw_material AS oil_type_rm,
                a.oil_type_rm_awal_jam,
                a.oil_type_rm_awal_flowmeter,
                a.oil_type_rm_akhir_jam,
                a.oil_type_rm_akhir_flowmeter,
                a.oil_type_rm_total,
                a.oil_type_fg AS oil_type_fg_id,
                b.finish_good AS oil_type_fg,
                a.oil_type_fg_awal_jam,
                a.oil_type_fg_awal_flowmeter,
                a.oil_type_fg_akhir_jam,
                a.oil_type_fg_akhir_flowmeter,
                a.oil_type_fg_total,
                a.oil_type_fg_to_tank,
                a.bp_oil_type AS bp_oil_type_id,
                b.by_product AS bp_oil_type,
                a.bp_awal_jam,
                a.bp_awal_flowmeter,
                a.bp_akhir_jam,
                a.bp_akhir_flowmeter,
                a.bp_total,
                a.bp_to_tank,
                a.be_ref_tank,
                a.be_ref_qty,
                a.be_total_bag,
                a.be_total_jenis,
                a.be_lot_batch_number,
                a.be_yield_percent,
                a.pa_ref_tank,
                a.pa_ref_qty,
                a.pa_total,
                a.pa_lot_batch_number,
                a.pa_yield_percent,
                a.remarks,
                a.flag,
                a.uu_item,
                a.uu_budget_ref_tank,
                a.uu_budget_qty,
                a.uu_total_cpo,
                a.uu_total_steam,
                a.uu_steam_cpo,
                a.uu_yield_percent,
                a.entry_by,
                a.entry_date,
                a.prepared_by,
                a.prepared_date,
                a.prepared_status,
                a.prepared_status_remarks,
                a.verified_by,
                a.verified_date,
                a.verified_status,
                a.checked_by,
                a.checked_date,
                a.checked_status,
                a.checked_status_remarks,
                a.form_no,
                a.date_issued,
                a.revision_no,
                a.revision_date
              FROM 
                t_daily_production_refinery AS a
              JOIN m_product AS b 
              ON a.oil_type_rm = b.id
              WHERE a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')""";
          params["plantCode"] = plantCode;
          break;
        default:
          log('User role $role is not authorized to view reports.');
          return [];
      }
      // Add date and time filters to the query for all roles
      if (dateFilter != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND a.transaction_date = :reportDate";
        } else {
          baseQuery += " WHERE a.transaction_date = :reportDate";
        }
        params["reportDate"] = dateFilter;
      }
      if (time != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND a.time = :time";
        } else {
          baseQuery += " WHERE a.time = :time";
        }
        params["time"] = time;
      }

      baseQuery += " ORDER BY a.transaction_date DESC";

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
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'PRM'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['ticket'];
        log("ticket id from database: ${row['ticket']}");

        return latestId;
      }
      await closeMySQLConnection(connection);
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
        log('Failed to get MySQL connection for updating autonumber.');
        return false;
      }

      connection = connResult.connection!;

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'PRM'";
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

  Future<bool> updateTicket(DailyProductionRefineryEntity entity) async {
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
        if (keyInEntityMap != 'id') {
          String actualDbColumnName = keyInEntityMap;
          String safeParameterName = keyInEntityMap;

          setClause.add('`$actualDbColumnName` = :$safeParameterName');
          sqlExecuteParams[safeParameterName] = value;
        }
      });
      sqlExecuteParams['id'] = entity.id;

      final sql =
          "UPDATE t_daily_production_refinery SET ${setClause.join(', ')} WHERE id = :id";

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
        await closeMySQLConnection(connection);
      } catch (e) {
        log('$e');
      }
    }
  }

  // TODO: FUNCTIONS IMPORTED
  Future<bool> sendApproveRejectTicket(
    final String username,
    final String status,
    final String userRole,
    final int shift,
    final String? remark,
    final String id,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for Sending approve/reject Daily Production Refinery report.',
        );
        return false;
      }
      connection = connResult.connection;
      final date = DateTime.now();
      String? sql;
      Map<String, dynamic>? params;

      if (AppRoles.managerProd.contains(userRole)) {
        sql =
            "UPDATE t_daily_production_refinery SET verified_by = :username, verified_status = :status, verified_date = :date, checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE id = :id";
        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        };
      } else if (AppRoles.leadProd.contains(userRole)) {
        sql =
            "UPDATE t_daily_production_refinery SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE id = :id";
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

  Future<List<Map<String, dynamic>>> getReportsForManager(
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get reports for manager.');
        return [];
      }
      connection = connResult.connection;
      const sql = """
        SELECT * FROM t_daily_production_refinery 
        WHERE prepared_status = 'Approved' AND plant = :plantCode AND (flag IS NULL OR flag = 'T')
        ORDER BY posting_date DESC
      """;
      final result = await connection!.execute(sql, {"plantCode": plantCode});
      log("Fetched ${result.rows.length} reports for manager.");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching reports for manager: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<bool> deleteTicket(String id, String username) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log("Failed to get MySQL connection for deleting ticket");
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE t_daily_production_refinery SET flag = 'D', prepared_by= :username, prepared_status = :prepared_status, prepared_date = :prepared_date WHERE id = :id",
        {
          "username": username,
          "prepared_status": "Deleted",
          "prepared_date": "${DateTime.now()}",
          "id": id,
        },
      );
      log('Ticket $id terhapus: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error closing connection: $e");
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
          "SELECT * FROM t_daily_production_refinery AND (flag IS NULL OR flag = 'T')";

      final result = await connection!.execute(baseQuery);
      log("Fetched ${result.rows.length} reports for Daily production.");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('$e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error Closing Connection: $e");
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
          "SELECT * FROM t_daily_production_refinery WHERE DATE(posting_date) = :dateFilter AND plant = :plantCode";

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
      log(
        "(PRM MySQL) Error getting all pretreatment bleaching filtration tickets: $e",
      );
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log('(PRM MySQL) MySQL connection closed for getTickets.');
      }
    }
  }
}
