import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class MaintenanceLampsAndGlassMySQLService {
  Future<List<Map<String, dynamic>>> getAllLampsAndGlass() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all users.');
        return [];
      }
      connection = connResult.connection;
      final result = await connection!.execute("SELECT * FROM  m_glass_lamp");
      log('Fetched ${result.rows.length} Lamps and Glass.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all Lamps and Glass: $e');
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

  Future<List<Map<String, dynamic>>> getAllLampsAndGlassFromDate(
    String date,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all users.');
        return [];
      }
      connection = connResult.connection;
      final result = await connection!.execute(
        "SELECT h.*, d.id as detail_id, d.check_item, d.status_item FROM t_checklist_lamps_glass_control h INNER JOIN t_checklist_lamps_glass_control_detail d ON h.id = d.id_hdr AND h.check_date = :date ORDER BY h.id ASC;",
        {"date": date},
      );
      log('Fetched ${result.rows.length} Lamps and Glass.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all Lamps and Glass based on date: $e');
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

  Future<List<Map<String, dynamic>>> getAllLampsAndGlassFromMonth(
    int year,
    int month,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection.');
        return [];
      }
      connection = connResult.connection;

      // Using the new query with named parameters for year and month
      final result = await connection!.execute(
        """
      SELECT 
        h.id, 
        h.company, 
        h.plant, 
        h.work_center, 
        h.remarks, 
        h.entry_by, 
        h.entry_date, 
        h.checked_by, 
        h.checked_date, 
        h.checked_status, 
        h.checked_status_remarks, 
        h.verified_by, 
        h.verified_date, 
        h.verified_status, 
        d.id AS detail_id, 
        d.check_item, 
        d.status_item 
      FROM 
        t_checklist_lamps_glass_control h 
      INNER JOIN 
        t_checklist_lamps_glass_control_detail d ON h.id = d.id_hdr 
      WHERE 
        YEAR(h.check_date) = :year AND MONTH(h.check_date) = :month 
      ORDER BY 
        h.check_date ASC;
      """,
        {"year": year, "month": month},
      );

      log(
        'Fetched ${result.rows.length} Lamps and Glass for month $year-$month.',
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching Lamps and Glass based on month: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Connection closed. Still connected: ${connection?.connected}");
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
        log('Failed to get MySQL connection for get all reports.');
        return null;
      }

      connection = connResult.connection!;
      final result = await connection.execute(
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as id FROM m_controlnumber WHERE plantid = :plant AND prefix = 'LGM'",
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

  Future<bool> updateApproveRejectToHeader({
    required String checkedBy,
    required String status,
    required int month,
    required int year,
    required String? remark,
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updateApproveRejectToHeader.');
        return false;
      }
      connection = connResult.connection!;
      String query = """
                     UPDATE t_checklist_lamps_glass_control
                     SET verified_status = :status, verified_by = :verifiedBy, verified_date = :verifiedDate
                     WHERE YEAR(entry_date) = :year AND MONTH(entry_date) = :month""";
      final result = await connection.execute(query, {
        "verifiedBy": checkedBy,
        "verifiedDate": DateTime.now(),
        "status": status,
        "year": year,
        "month": month,
        "remarks": remark,
      });

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating lamps and glass for approval: $e');
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
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'LGM'";
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

  Future<bool> insertLampsAndGlassToControl(
    LampsAndGlassControlEntity entity,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all users.');
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "INSERT INTO t_checklist_lamps_glass_control (`id`, `company`, `plant`, `work_center`, `check_date`, `remarks`, `entry_by`, `entry_date`, `checked_by`, `checked_date`, `checked_status`, `checked_status_remarks`) VALUES (:id, :company, :plant, :work_center, :check_date, :remarks, :entry_by, :entry_date, :checked_by, :checked_date, :checked_status, :checked_status_remarks)",
        {
          "id": entity.id,
          "company": entity.company,
          "plant": entity.plant,
          "work_center": entity.workCenter,
          "check_date": entity.checkDate,
          "remarks": entity.remarks,
          "entry_by": entity.entryBy,
          "entry_date": entity.entryDate,
          "checked_by": entity.checkedBy,
          "checked_date": entity.checkedDate,
          "checked_status": entity.checkedStatus,
          "checked_status_remarks": entity.checkedStatusRemarks,
        },
      );
      log("submitted to control");
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error submitting to control: $e');
      return false;
    } finally {
      await closeMySQLConnection(connection);
      log(connection!.connected ? "Connected" : "Disconnected");
    }
  }

  Future<bool> insertLampsAndGlassToControlDetail(
    List<LampsAndGlassControlDetailEntity> entityList,
  ) async {
    if (entityList.isEmpty) {
      log('Entity list is empty, no data to insert.');
      return false;
    }

    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all users.');
        return false;
      }
      connection = connResult.connection!;

      final values = List.generate(
        entityList.length,
        (index) =>
            "('${entityList[index].id}', '${entityList[index].idHdr}', '${entityList[index].checkItem}', '${entityList[index].statusItem}')",
      ).join(', ');

      final String sql = """
      INSERT INTO t_checklist_lamps_glass_control_detail (`id`, `id_hdr`, `check_item`, `status_item`) VALUES $values
      """;

      final result = await connection.execute(sql);
      log("submitted to control detail");
      return result.affectedRows == BigInt.from(entityList.length);
    } catch (e) {
      log('Error submitting to control detail: $e');
      return false;
    } finally {
      await closeMySQLConnection(connection);
      log(connection!.connected ? "Connected" : "Disconnected");
    }
  }

  Future<bool> isDataExistForDate(String workCenter, String date) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for data existence check.');
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "SELECT COUNT(*) as count FROM t_checklist_lamps_glass_control WHERE check_date= :date",
        {"date": date},
      );
      if (result.rows.isNotEmpty) {
        final count = int.parse(result.rows.first.assoc()['count']!);
        return count > 0;
      }
      return false;
    } catch (e) {
      log("Error Checking if data exists: $e");
      return false;
    } finally {
      await closeMySQLConnection(connection);
      log(connection!.connected ? "Connected" : "Disconnected");
    }
  }

  // Update Lamps and Glass
  Future<bool> updateLampsAndGlass({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required List<LampsAndGlassControlDetailEntity> details,
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
          "UPDATE t_checklist_lamps_glass_control SET company = :company, plant =:plant, work_center = :work_center, check_date = :check_date, remarks = :remarks WHERE id = :id";
      final paramsHeader = {
        "id": id,
        "company": company,
        "plant": plant,
        "work_center": workCenter,
        "check_date": checkDate,
        "remarks": remarks,
      };

      final sqlDetail =
          "DELETE FROM t_checklist_lamps_glass_control_detail WHERE id_hdr = :id_hdr";

      final paramsDetail = {"id_hdr": id};

      //ensure every query execute run
      await connection.transactional((_) async {
        // 1. update Lamps and Glass Header
        await connection!.execute(sqlHeader, paramsHeader);

        // 2. Delete all existing detail records.
        await connection.execute(sqlDetail, paramsDetail);

        if (details.isNotEmpty) {
          final values = details
              .map(
                (detail) =>
                    "('${detail.id}', '${detail.idHdr}', '${detail.checkItem}', '${detail.statusItem}')",
              )
              .join(', ');

          final String sql =
              "INSERT INTO t_checklist_lamps_glass_control_detail (`id`, `id_hdr`, `check_item`, `status_item`) VALUES $values";

          await connection.execute(sql);
        }
      });

      log('Successfully updated Lamps and Glass record with ID: $id');
      return true;
    } catch (e) {
      log('Error updating Lamps and Glass record: $e');
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

  // Delete Lamps and Glass
  Future<bool> deleteLampsAndGlass(String id) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for delete.');
        return false;
      }
      connection = connResult.connection!;

      final String deleteDetail =
          "DELETE FROM t_checklist_lamps_glass_control_detail WHERE id_hdr = :id";

      final Map<String, String> deleteDetailParams = {"id": id};

      final String deleteHeader =
          "DELETE FROM t_checklist_lamps_glass_control WHERE id = :id";

      final Map<String, String> deleteHeaderParams = {"id": id};

      await connection.transactional((_) async {
        //
        await connection!.execute(deleteDetail, deleteDetailParams);

        await connection.execute(deleteHeader, deleteHeaderParams);
      });

      log('Successfully deleted Lamps and Glass record with ID: $id');
      return true;
    } catch (e) {
      log('Error deleting Lamps and Glass record: $e');
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
