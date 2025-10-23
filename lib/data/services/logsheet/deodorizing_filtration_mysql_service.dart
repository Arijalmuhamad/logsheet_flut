import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DeodorizingFiltrationMySQLService {
  Future<bool> insertTicket(DeodorizingFiltrationEntity entity) async {
    MySQLConnection? connection;
    try {
      await closeMySQLConnection(connection);
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING MySQL) Failed to get MySQL connection for inserting pretreatment bleaching filtration ticket.',
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

      log("(DEODORIZING MySQL) Generated SQL: $sql");
      log('(DEODORIZING MySQL) Data for SQL: $sqlExecuteParams');
      log(
        connection.connected
            ? "(DEODORIZING MySQL) Connected to the database"
            : "(DEODORIZING MySQL) Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('$e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("(DEODORIZING MySQL) Is still connected: ${connection?.connected}");
      } catch (e) {
        log("(DEODORIZING MySQL) Error Closing Connection: $e");
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
        "(DEODORIZING MySQL) mysql function getAllLogsheet for user: $username, role: $role, plant: $plantCode",
      );
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING MySQL) Failed to get MySQL connection for getAllLogsheet.',
        );
        return [];
      }
      connection = connResult.connection;

      String baseQuery;
      final Map<String, dynamic> params = {};

      switch (role) {
        case 'LEAD' || 'LEAD_PROD':
          // Query untuk Shift Leader: Hanya bisa melihat logsheet dari shift yang dipegangnya.
          baseQuery = """
            SELECT 
                a.id,
                a.company,
                a.plant,
                a.transaction_date,
                a.posting_date,
                a.refinery_machine,
                a.time,
                a.oil_type AS oil_type_id,
                b.raw_material AS oil_type,
                a.shift,
                a.fit701_bpo,
                a.d701_vacum,
                a.d701_td701,
                a.e702,
                a.thermopac_inlet,
                a.thermopac_outlet,
                a.d702_inlet,
                a.d702_outlet,
                a.d702_vacum,
                a.sparging_a,
                a.sparging_b,
                a.e730_inlet,
                a.steam_inlet,
                a.pish_706,
                a.tiwh_706,
                a.f702_a,
                a.f702_b,
                a.f702_c,
                a.oil_type_fg AS oil_type_fg_id,
                b.finish_good AS oil_type_fg,
                a.fit704_rpo,
                a.e704,
                a.oil_type_bp AS oil_type_bp_id,
                b.by_product AS oil_type_bp,
                a.fit_705_pfad,
                a.e705,
                a.clarity,
                a.remarks,
                a.flag,
                a.entry_by,
                a.entry_date,
                a.prepared_by,
                a.prepared_date,
                a.prepared_status,
                a.prepared_status_remarks,
                a.checked_by,
                a.checked_date,
                a.checked_status,
                a.checked_status_remarks,
                a.updated_by,
                a.updated_date,
                a.form_no,
                a.date_issued,
                a.revision_no,
                a.revision_date
            FROM 
                t_deodorizing_filtration AS a
            JOIN 
                m_product AS b ON a.oil_type = b.id
            WHERE
               a.plant = :plantCode AND a.posting_date >= CURRENT_DATE - INTERVAL '7' DAY AND (a.flag IS NULL OR a.flag = 'T')
          """;

          // baseQuery = """
          // SELECT * FROM t_deodorizing_filtration WHERE isactive = :is_active AND plant = :plantCode AND posting_date >= CURRENT_DATE - INTERVAL '7' DAY
          // """;
          params["plantCode"] = plantCode;
          break;

        case 'OPR' || 'OPR_PROD':
          // Query untuk Operator: Dapat melihat semua logsheet di plant-nya.
          baseQuery = """
          SELECT 
                a.id,
                a.company,
                a.plant,
                a.transaction_date,
                a.posting_date,
                a.refinery_machine,
                a.time,
                a.oil_type AS oil_type_id,
                b.raw_material AS oil_type,
                a.shift,
                a.fit701_bpo,
                a.d701_vacum,
                a.d701_td701,
                a.e702,
                a.thermopac_inlet,
                a.thermopac_outlet,
                a.d702_inlet,
                a.d702_outlet,
                a.d702_vacum,
                a.sparging_a,
                a.sparging_b,
                a.e730_inlet,
                a.steam_inlet,
                a.pish_706,
                a.tiwh_706,
                a.f702_a,
                a.f702_b,
                a.f702_c,
                a.oil_type_fg AS oil_type_fg_id,
                b.finish_good AS oil_type_fg,
                a.fit704_rpo,
                a.e704,
                a.oil_type_bp AS oil_type_bp_id,
                b.by_product AS oil_type_bp,
                a.fit_705_pfad,
                a.e705,
                a.clarity,
                a.remarks,
                a.flag,
                a.entry_by,
                a.entry_date,
                a.prepared_by,
                a.prepared_date,
                a.prepared_status,
                a.prepared_status_remarks,
                a.checked_by,
                a.checked_date,
                a.checked_status,
                a.checked_status_remarks,
                a.updated_by,
                a.updated_date,
                a.form_no,
                a.date_issued,
                a.revision_no,
                a.revision_date
            FROM 
                t_deodorizing_filtration AS a
            JOIN 
                m_product AS b ON a.oil_type = b.id
            WHERE a.plant = :plantCode
        """;
          params["plantCode"] = plantCode;
          break;
        case 'MGR' || 'MGR_PROD':
          // Query untuk Manager: Hanya bisa melihat logsheet yang statusnya sudah 'Approved' oleh Shift Leader.
          baseQuery = """
            SELECT 
                a.id,
                a.company,
                a.plant,
                a.transaction_date,
                a.posting_date,
                a.refinery_machine,
                a.time,
                a.oil_type AS oil_type_id,
                b.raw_material AS oil_type,
                a.shift,
                a.fit701_bpo,
                a.d701_vacum,
                a.d701_td701,
                a.e702,
                a.thermopac_inlet,
                a.thermopac_outlet,
                a.d702_inlet,
                a.d702_outlet,
                a.d702_vacum,
                a.sparging_a,
                a.sparging_b,
                a.e730_inlet,
                a.steam_inlet,
                a.pish_706,
                a.tiwh_706,
                a.f702_a,
                a.f702_b,
                a.f702_c,
                a.oil_type_fg AS oil_type_fg_id,
                b.finish_good AS oil_type_fg,
                a.fit704_rpo,
                a.e704,
                a.oil_type_bp AS oil_type_bp_id,
                b.by_product AS oil_type_bp,
                a.fit_705_pfad,
                a.e705,
                a.clarity,
                a.remarks,
                a.flag,
                a.entry_by,
                a.entry_date,
                a.prepared_by,
                a.prepared_date,
                a.prepared_status,
                a.prepared_status_remarks,
                a.checked_by,
                a.checked_date,
                a.checked_status,
                a.checked_status_remarks,
                a.updated_by,
                a.updated_date,
                a.form_no,
                a.date_issued,
                a.revision_no,
                a.revision_date
            FROM 
                t_deodorizing_filtration AS a
            JOIN 
                m_product AS b ON a.oil_type = b.id
            WHERE
                a.prepared_status = :status AND a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
        """;
          params["status"] = "Approved";
          params["plantCode"] = plantCode;
          break;
        case 'ADM':
          // Query untuk Admin: Dapat melihat semua logsheet di plant-nya.
          baseQuery = """
              SELECT 
                  a.id,
                  a.company,
                  a.plant,
                  a.transaction_date,
                  a.posting_date,
                  a.refinery_machine,
                  a.time,
                  a.oil_type AS oil_type_id,
                  b.raw_material AS oil_type,
                  a.shift,
                  a.fit701_bpo,
                  a.d701_vacum,
                  a.d701_td701,
                  a.e702,
                  a.thermopac_inlet,
                  a.thermopac_outlet,
                  a.d702_inlet,
                  a.d702_outlet,
                  a.d702_vacum,
                  a.sparging_a,
                  a.sparging_b,
                  a.e730_inlet,
                  a.steam_inlet,
                  a.pish_706,
                  a.tiwh_706,
                  a.f702_a,
                  a.f702_b,
                  a.f702_c,
                  a.oil_type_fg AS oil_type_fg_id,
                  b.finish_good AS oil_type_fg,
                  a.fit704_rpo,
                  a.e704,
                  a.oil_type_bp AS oil_type_bp_id,
                  b.by_product AS oil_type_bp,
                  a.fit_705_pfad,
                  a.e705,
                  a.clarity,
                  a.remarks,
                  a.flag,
                  a.entry_by,
                  a.entry_date,
                  a.prepared_by,
                  a.prepared_date,
                  a.prepared_status,
                  a.prepared_status_remarks,
                  a.checked_by,
                  a.checked_date,
                  a.checked_status,
                  a.checked_status_remarks,
                  a.updated_by,
                  a.updated_date,
                  a.form_no,
                  a.date_issued,
                  a.revision_no,
                  a.revision_date
              FROM 
                  t_deodorizing_filtration AS a
              JOIN 
                  m_product AS b ON a.oil_type = b.id 
              
              WHERE a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')""";
          params["plantCode"] = plantCode;
          break;

        default:
          log(
            '(DEODORIZING MySQL) User role $role is not authorized to view logsheets.',
          );
          return [];
      }

      // 2. Add date and time filters dynamically
      if (dateFilter != null) {
        // Menggunakan DATE() untuk membandingkan hanya bagian tanggal dari kolom transaction_date
        baseQuery += " AND DATE(a.transaction_date) = :transactionDate";
        params["transactionDate"] = DateFormat('yyyy-MM-dd').format(dateFilter);
      }
      if (time != null) {
        baseQuery += " AND a.time = :time";
        params["time"] = time;
      }

      // 3. Add the ORDER BY clause for consistent sorting
      if (role == 'LEAD') {
        baseQuery += " ORDER BY a.transaction_date DESC, a.time ASC";
      } else {
        baseQuery += " ORDER BY a.transaction_date DESC, a.time ASC";
      }

      final IResultSet result = await connection!.execute(baseQuery, params);

      log("baseQuery: $baseQuery");

      log(
        '(DEODORIZING MySQL) Fetched ${result.rows.length} deodorizing filtration logsheet records for user $username with role $role.',
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
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for get all deodorizing reports.',
        );
        return null;
      }
      connection = connResult.connection;
      final result = await connection!.execute(
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
        await closeMySQLConnection(connection);
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
        await closeMySQLConnection(connection);
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<bool> updateTicket(DeodorizingFiltrationEntity entity) async {
    MySQLConnection? connection;

    try {
      await closeMySQLConnection(connection);
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
        await closeMySQLConnection(connection);
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
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for Sending approve/reject PBE deodorizing filtration.',
        );
        return false;
      }
      connection = connResult.connection;
      final date = DateTime.now();
      String sql;
      Map<String, dynamic> params;

      if (AppRoles.managerProd.contains(userRole)) {
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
      final result = await connection!.execute(sql, params);
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
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for get reports for manager.',
        );
        return [];
      }
      connection = connResult.connection;
      const sql = """
        SELECT 
                a.id,
                a.company,
                a.plant,
                a.transaction_date,
                a.posting_date,
                a.refinery_machine,
                a.time,
                a.oil_type AS oil_type_id,
                b.raw_material AS oil_type,
                a.shift,
                a.fit701_bpo,
                a.d701_vacum,
                a.d701_td701,
                a.e702,
                a.thermopac_inlet,
                a.thermopac_outlet,
                a.d702_inlet,
                a.d702_outlet,
                a.d702_vacum,
                a.sparging_a,
                a.sparging_b,
                a.e730_inlet,
                a.steam_inlet,
                a.pish_706,
                a.tiwh_706,
                a.f702_a,
                a.f702_b,
                a.f702_c,
                a.oil_type_fg AS oil_type_fg_id,
                b.finish_good AS oil_type_fg,
                a.fit704_rpo,
                a.e704,
                a.oil_type_bp AS oil_type_bp_id,
                b.by_product AS oil_type_bp,
                a.fit_705_pfad,
                a.e705,
                a.clarity,
                a.remarks,
                a.flag,
                a.entry_by,
                a.entry_date,
                a.prepared_by,
                a.prepared_date,
                a.prepared_status,
                a.prepared_status_remarks,
                a.checked_by,
                a.checked_date,
                a.checked_status,
                a.checked_status_remarks,
                a.updated_by,
                a.updated_date,
                a.form_no,
                a.date_issued,
                a.revision_no,
                a.revision_date
            FROM 
                t_deodorizing_filtration AS a
            JOIN 
                m_product AS b ON a.oil_type = b.id 
            WHERE 
                a.prepared_status = 'Approved' AND a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
            ORDER BY 
                a.posting_date DESC
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
        log(
          "(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for deleting ticket",
        );
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE t_deodorizing_filtration SET flag = 'D', prepared_by = :username, prepared_status = :prepared_status, prepared_date = :prepared_date WHERE id = :id",
        {
          "username": username,
          "prepared_status": "Deleted",
          "prepared_date": "${DateTime.now()}",
          "id": id,
        },
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
        await closeMySQLConnection(connection);
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
      String query = """
          SELECT 
              a.id,
              a.company,
              a.plant,
              a.transaction_date,
              a.posting_date,
              a.refinery_machine,
              a.time,
              a.oil_type AS oil_type_id,
              b.raw_material AS oil_type,
              a.shift,
              a.fit701_bpo,
              a.d701_vacum,
              a.d701_td701,
              a.e702,
              a.thermopac_inlet,
              a.thermopac_outlet,
              a.d702_inlet,
              a.d702_outlet,
              a.d702_vacum,
              a.sparging_a,
              a.sparging_b,
              a.e730_inlet,
              a.steam_inlet,
              a.pish_706,
              a.tiwh_706,
              a.f702_a,
              a.f702_b,
              a.f702_c,
              a.oil_type_fg AS oil_type_fg_id,
              b.finish_good AS oil_type_fg,
              a.fit704_rpo,
              a.e704,
              a.oil_type_bp AS oil_type_bp_id,
              b.by_product AS oil_type_bp,
              a.fit_705_pfad,
              a.e705,
              a.clarity,
              a.remarks,
              a.flag,
              a.entry_by,
              a.entry_date,
              a.prepared_by,
              a.prepared_date,
              a.prepared_status,
              a.prepared_status_remarks,
              a.checked_by,
              a.checked_date,
              a.checked_status,
              a.checked_status_remarks,
              a.updated_by,
              a.updated_date,
              a.form_no,
              a.date_issued,
              a.revision_no,
              a.revision_date
          FROM 
              t_deodorizing_filtration AS a
          JOIN 
              m_product AS b ON a.oil_type = b.id 
          WHERE 
              DATE(posting_date) = :dateFilter AND plant = :plantCode""";

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
        "(DEODORIZING FILTRATION MySQL) Error getting all Deodorizing filtration tickets: $e",
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

  Future<bool?> isDataExist({
    required DateTime date,
    required TimeOfDay time,
    required String company,
    required String plant,
    required String workCenter,
  }) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          '(DEODORIZING FILTRATION MySQL) Failed to get MySQL connection for isDataExist.',
        );
        return null;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "SELECT COUNT(id) as count FROM t_deodorizing_filtration WHERE DATE(posting_date) = :date AND company = :company AND plant = :plant AND refinery_machine = :work_center AND time = :time",
        {
          'date': DateFormat('yyyy-MM-dd').format(date),
          'company': company,
          'plant': plant,
          'work_center': workCenter,
          'time': time,
        },
      );

      if (result.rows.isNotEmpty) {
        final count = int.parse(result.rows.first.assoc()['count']!);
        return count > 0;
      } else {
        return false;
      }
    } catch (e) {
      log(
        "(DEODORIZING FILTRATION MySQL) Error validating Deodorizing filtration tickets: $e",
      );
      return null;
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
