import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_production_checklist_header_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class ChangeProductChecklistMySQLService {
  final String langkahKerjaTable = "m_langkahkerja";
  final String changeProductChecklistHeader = "t_change_product_checklist";
  final String changeProductChecklistDetail =
      "t_change_product_checklist_detail";

  /// Fetches all active "langkah kerja" (work steps) from the database.
  ///
  /// This method connects to the MySQL database, queries the `m_langkahkerja` table
  /// for entries where `isactive` is 'T' (true), and returns them as a list of
  /// maps. Each map represents a row from the database.
  ///
  /// Returns:
  /// - A `Future<List<Map<String, dynamic>>>` containing a list of maps,
  ///   where each map is a row from the `m_langkahkerja` table.
  /// - An empty list if there's an error during connection or fetching,
  ///   or if no active "langkah kerja" are found.
  ///
  /// Errors are logged to the console.
  Future<List<Map<String, dynamic>>> getLangkahKerja() async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      final String sql =
          "SELECT * FROM $langkahKerjaTable WHERE isactive = :isactive";
      final Map<String, String> parameter = {"isactive": "T"};

      final result = await connection!.execute(sql, parameter);

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

  /// Fetches all change product checklist records for a specific date.
  ///
  /// This method connects to the MySQL database, queries the `t_change_product_checklist`
  /// and `t_change_product_checklist_detail` tables, joining them to retrieve
  /// header and detail information for records matching the provided `date`.
  ///
  /// Parameters:
  /// - [date]: The date string (e.g., 'YYYY-MM-DD') to filter the records.
  ///
  /// Returns:
  /// - A `Future<List<Map<String, dynamic>>>` containing a list of maps,
  ///   where each map represents a joined row from the header and detail tables.
  /// - An empty list if there's an error during connection or fetching,
  ///   or if no records are found for the specified date.
  ///
  /// Errors are logged to the console.
  Future<List<Map<String, dynamic>>> getAllChangeProductFromDate(
    String date,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for getAllChangeProductFromDate.');
        return [];
      }
      connection = connResult.connection;
      final result = await connection!.execute(
        """
          SELECT 
          h.id, 
          h.company, 
          h.plant, 
          h.transaction_date, 
          h.transaction_time,
          h.first_product AS first_product_id,
          p1.raw_material AS first_product,
          h.next_product AS next_product_id,
          p2.raw_material AS next_product,
          h.work_center, 
          h.remarks, 
          h.flag,
          h.entry_by,
          h.entry_date,
          h.prepared_by,
          h.prepared_date,
          h.prepared_status,
          h.prepared_status_remarks,
          h.checked_by,
          h.checked_date,
          h.checked_status,
          h.checked_status_remarks,
          h.updated_by,
          h.updated_date,
          h.form_no,
          h.date_issued,
          h.revision_no,
          h.revision_date,
          d.id AS detail_id, 
          d.check_item, 
          d.status_item 
      FROM 
          t_change_product_checklist h
      INNER JOIN 
          t_change_product_checklist_detail d 
          ON h.id = d.id_hdr
      LEFT JOIN 
          m_product p1 
          ON h.first_product = p1.id
      LEFT JOIN 
          m_product p2 
          ON h.next_product = p2.id
      WHERE 
          DATE(h.transaction_date) = :date
      ORDER BY 
          h.id ASC;
        """,
        {"date": date},
      );
      log(
        'Fetched ${result.rows.length} Change Product Checklists for date $date.',
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all Change Product Checklists based on date: $e');
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

  /// Inserts a change product checklist (header and details) within a single database transaction.
  ///
  /// This method ensures that both the header and its corresponding detail records are
  /// inserted successfully. If any part of the operation fails, the entire transaction
  /// is rolled back, preventing orphaned header records.
  ///
  /// Parameters:
  /// - [header]: The [MaintenanceChangeProductionChecklistHeaderEntity] object for the header.
  /// - [details]: A list of [MaintenanceChangeProductChecklistDetailEntity] objects for the details.
  ///
  /// Returns:
  /// - A `Future<bool>` which is `true` if the entire transaction was successful, `false` otherwise.
  ///
  /// Errors are logged to the console.
  Future<bool> insertChangeProductChecklist({
    required MaintenanceChangeProductionChecklistHeaderEntity header,
    required List<MaintenanceChangeProductChecklistDetailEntity> details,
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
        final Map<String, dynamic> headerMap = header.toMap();
        final List<String> headerColumns = [];
        final List<String> headerParams = [];
        final Map<String, dynamic> headerSqlParams = {};

        headerMap.forEach((key, value) {
          headerColumns.add('`$key`');
          headerParams.add(':$key');
          headerSqlParams[key] = value;
        });

        final String headerSql =
            'INSERT INTO $changeProductChecklistHeader (${headerColumns.join(', ')}) VALUES (${headerParams.join(', ')})';
        await connection!.execute(headerSql, headerSqlParams);

        // 2. Insert the Details (if any)
        if (details.isNotEmpty) {
          final values = details
              .map(
                (detail) =>
                    "('${detail.id}', '${detail.idHdr}', '${detail.checkItem}', '${detail.statusItem}')",
              )
              .join(', ');

          final String detailSql =
              "INSERT INTO $changeProductChecklistDetail (`id`, `id_hdr`, `check_item`, `status_item`) VALUES $values";
          await connection.execute(detailSql);
        }
      });

      log('Successfully inserted change product checklist with transaction.');
      return true;
    } catch (e) {
      log('Error during change product checklist transaction: $e');
      return false;
    } finally {
      await closeMySQLConnection(connection);
    }
  }

  /// Deletes a change product checklist record by setting its 'flag' to 'D' (deleted).
  ///
  /// This method connects to the MySQL database and updates the `flag` column
  /// of the `t_change_product_checklist` table for the specified `id`.
  ///
  /// Parameters:
  /// - [id]: The unique identifier of the change product checklist header to be deleted.
  ///
  /// Returns:
  /// - A `Future<bool>` which is `true` if the update was successful (i.e., one or more rows were affected), `false` otherwise.
  ///
  /// Errors are logged to the console.
  Future<bool> deleteChangeProductChecklist(String id) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for deleteChangeProductChecklist.');
        return false;
      }
      connection = connResult.connection!;

      final String sql =
          "UPDATE $changeProductChecklistHeader SET flag = 'D' WHERE id = :id";
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

  /// Updates an existing change product checklist (header and details) within a single database transaction.
  ///
  /// This method ensures that both the header and its corresponding detail records are
  /// updated successfully. If any part of the operation fails, the entire transaction
  /// is rolled back.
  ///
  /// Parameters:
  /// - [id]: The unique identifier of the change product checklist header to be updated.
  /// - [company]: The updated company name.
  /// - [plant]: The updated plant name.
  /// - [workCenter]: The updated work center reference.
  /// - [checkDate]: The updated check date.
  /// - [remarks]: The updated remarks.
  /// - [details]: A list of [MaintenanceChangeProductChecklistDetailEntity] objects for the updated details.
  ///
  /// Returns:
  /// - A `Future<bool>` which is `true` if the entire transaction was successful, `false` otherwise.
  ///
  /// Errors are logged to the console.
  Future<bool> updateChangeProduct({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required String updatedBy,
    required DateTime updatedAt,
    required List<MaintenanceChangeProductChecklistDetailEntity> details,
  }) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return false;
      }
      connection = connResult.connection!;

      final sqlHeader =
          "UPDATE $changeProductChecklistHeader SET company = :company, plant =:plant, work_center = :work_center, checked_date = :check_date, remarks = :remarks, updated_by = :updated_by, updated_date = :updated_date WHERE id = :id";
      final paramsHeader = {
        "id": id,
        "company": company,
        "plant": plant,
        "work_center": workCenter,
        "check_date": checkDate,
        "remarks": remarks,
        "updated_by": updatedBy,
        "updated_date": updatedAt,
      };

      final sqlDetail =
          "DELETE FROM $changeProductChecklistDetail WHERE id_hdr = :id_hdr";

      final paramsDetail = {"id_hdr": id};

      await connection.transactional((conn) async {
        // 1. update Change Product Header
        await connection!.execute(sqlHeader, paramsHeader);

        // 3. Insert new detail records (if any)
        if (details.isNotEmpty) {
          // 2. Delete all existing detail record.
          await connection.execute(sqlDetail, paramsDetail);

          final values = details
              .map(
                (e) =>
                    "('${e.id}', '${e.idHdr}', '${e.checkItem}', '${e.statusItem}')",
              )
              .join(', ');

          final String sql =
              "INSERT INTO $changeProductChecklistDetail VALUES $values";

          await connection.execute(sql);
        }
      });
      log('Successfully updated Change Product Checklist record ID $id');
      return true;
    } catch (e) {
      log('Error updating Change Product Checklist record: $e');
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

  /// Fetches the latest ID for a change product checklist based on the plant code.
  ///
  /// This method connects to the MySQL database and queries the `m_controlnumber` table
  /// to construct the latest ID using `prefix`, `plantid`, `accountingyear`, and `autonumber`.
  /// The prefix used for change product checklist is 'CPM'.
  ///
  /// Parameters:
  /// - [plantCode]: The plant code to filter the control number.
  ///
  /// Returns:
  /// - A `Future<String?>` containing the latest generated ID if successful, `null` otherwise.
  ///
  /// Errors are logged to the console.
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
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as id FROM m_controlnumber WHERE plantid = :plant AND prefix = 'CPC'",
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

  /// Updates the `autonumber` field in the `m_controlnumber` table for a specific plant and prefix.
  ///
  /// This method connects to the MySQL database and updates the `autonumber`
  /// for entries where `plantid` matches [plantCode] and `prefix` is 'CPM'.
  ///
  /// Parameters:
  /// - [plantCode]: The plant code to identify the control number record.
  /// - [newAutoNumber]: The new autonumber value to set.
  ///
  /// Returns:
  /// - A `Future<bool>` which is `true` if the update was successful (i.e., one or more rows were affected), `false` otherwise.
  ///
  /// Errors are logged to the console.
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
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'CPC'";
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

  /// Updates the approval/rejection status for a change product checklist header.
  ///
  /// This method allows different roles (LEAD, MGR) to update specific fields
  /// related to the approval process.
  /// - 'LEAD' role updates `prepared_by`, `prepared_date`, `prepared_status`, and `prepared_status_remarks`.
  /// - 'MGR' role updates `checked_by`, `checked_date`, `checked_status`, and `checked_status_remarks`.
  ///
  /// Parameters:
  /// - [id]: The unique identifier of the change product checklist header.
  /// - [approvedBy]: The user ID of the person performing the approval/rejection.
  /// - [status]: The status ('A' for approved, 'R' for rejected).
  /// - [role]: The role of the user performing the action ('LEAD' or 'MGR').
  /// - [remark]: Optional remarks for the approval/rejection.
  ///
  /// Returns:
  /// - A `Future<bool>` which is `true` if the update was successful, `false` otherwise.
  ///
  /// Errors are logged to the console.
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

      if (AppRoles.leadProd.contains(role)) {
        query = """
          UPDATE $changeProductChecklistHeader
          SET prepared_status = :status, prepared_by = :approvedBy, prepared_date = :approvedDate, prepared_status_remarks = :remark
          WHERE id = :id
        """;
      } else if (AppRoles.managerProd.contains(role)) {
        query = """
          UPDATE $changeProductChecklistHeader
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

  /// Fetches all change product checklist records that are awaiting approval.
  ///
  /// This method connects to the MySQL database, queries the `t_change_product_checklist`
  /// and `t_change_product_checklist_detail` tables, joining them to retrieve
  /// header and detail information for records where `prepared_status` is not NULL
  /// (meaning it has been prepared/approved by a lead) and `checked_status` is NULL
  /// (meaning it is awaiting manager approval).
  ///
  /// Returns:
  /// - A `Future<List<Map<String, dynamic>>>` containing a list of maps,
  ///   where each map represents a joined row from the header and detail tables.
  /// - An empty list if there's an error during connection or fetching,
  ///   or if no records are found awaiting approval.
  ///
  /// Errors are logged to the console.
  Future<List<Map<String, dynamic>>> getAllApprovalHeaderAndDetail() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for getAllApprovalHeaderAndDetail.',
        );
        return [];
      }
      connection = connResult.connection;
      // final result = await connection!.execute("""
      //     SELECT
      //         h.id,
      //         h.company,
      //         h.plant,
      //         h.transaction_date,
      //         h.transaction_time,
      //         h.first_product AS first_product_id,
      //         p1.raw_material AS first_product,
      //         h.next_product AS next_product_id,
      //         p2.raw_material AS next_product,
      //         h.work_center,
      //         h.remarks,
      //         h.flag,
      //         h.entry_by,
      //         h.entry_date,
      //         h.prepared_by,
      //         h.prepared_date,
      //         h.prepared_status,
      //         h.prepared_status_remarks,
      //         h.checked_by,
      //         h.checked_date,
      //         h.checked_status,
      //         h.checked_status_remarks,
      //         h.updated_by,
      //         h.updated_date,
      //         h.form_no,
      //         h.date_issued,
      //         h.revision_no,
      //         h.revision_date,
      //         d.id AS detail_id,
      //         d.check_item,
      //         d.status_item
      //     FROM
      //         t_change_product_checklist h
      //     INNER JOIN
      //         t_change_product_checklist_detail d
      //         ON h.id = d.id_hdr
      //     LEFT JOIN
      //         m_product p1
      //         ON h.first_product = p1.id
      //     LEFT JOIN
      //         m_product p2
      //         ON h.next_product = p2.id
      //     WHERE
      //         DATE(h.transaction_date) = :date AND  h.prepared_status IS NOT NULL AND h.checked_status IS NULL
      //     ORDER BY
      //         h.id ASC;
      //   """);
      final result = await connection!.execute("""
          SELECT 
              h.id, 
              h.company, 
              h.plant, 
              h.transaction_date, 
              h.transaction_time,
              h.first_product AS first_product_id,
              p1.raw_material AS first_product,
              h.next_product AS next_product_id,
              p2.raw_material AS next_product,
              h.work_center, 
              h.remarks, 
              h.flag,
              h.entry_by,
              h.entry_date,
              h.prepared_by,
              h.prepared_date,
              h.prepared_status,
              h.prepared_status_remarks,
              h.checked_by,
              h.checked_date,
              h.checked_status,
              h.checked_status_remarks,
              h.updated_by,
              h.updated_date,
              h.form_no,
              h.date_issued,
              h.revision_no,
              h.revision_date,
              d.id AS detail_id, 
              d.check_item, 
              d.status_item 
          FROM 
              t_change_product_checklist h
          INNER JOIN 
              t_change_product_checklist_detail d 
              ON h.id = d.id_hdr
          LEFT JOIN 
              m_product p1 
              ON h.first_product = p1.id
          LEFT JOIN 
              m_product p2 
              ON h.next_product = p2.id
          WHERE 
              h.prepared_status IS NOT NULL OR h.checked_status IS NOT NULL
          ORDER BY 
              h.id ASC;
        """);
      log(
        'Fetched ${result.rows.length} Change Product Checklists for approval.',
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching Change Product Checklists for approval: $e');
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
