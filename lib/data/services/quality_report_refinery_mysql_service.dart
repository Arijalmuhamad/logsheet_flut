import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class QualityReportRefineryMysqlService {
  Future<bool> insertQualityReportRefinery(
    QualityReportRefineryEntity entity,
  ) async {
    try {
      final conn = await getMySQLConnection();

      if (conn == null) {
        log('Failed to get MySQL connection for business unit registration.');
        return false;
      }

      List<String> columns = [];
      List<String> params = [];
      final Map<String, dynamic> entityData = entity.toMap();
      final Map<String, dynamic> sqlExecuteParams = {};

      entityData.forEach((keyInEntityMap, value) {
        String actualDbColumnName = keyInEntityMap;
        String safeParameterName = keyInEntityMap;

        if (keyInEntityMap == 'p_m&i') {
          actualDbColumnName = 'p_m&i'; // Database column name
          safeParameterName = 'p_mni_param';
        } else if (keyInEntityMap == 'r_m&i') {
          actualDbColumnName = 'r_m&i';
          safeParameterName = 'r_mni_param';
        }

        columns.add('`$actualDbColumnName`');
        params.add(':$safeParameterName');
        sqlExecuteParams[safeParameterName] = value;
      });

      final String sql = '''
      INSERT INTO t_quality_report_refinery (${columns.join(', ')})
      VALUES
      (${params.join(', ')});
      ''';

      log('Generated SQL: $sql');
      log('Data for SQL: $sqlExecuteParams');

      final result = await conn.execute(sql, sqlExecuteParams);

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error inserting Quality Report Refinery Report: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllReports(
    DateTime? dateFilter,
    String? time,
  ) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for get all reports.');
      return [];
    }

    try {
      IResultSet? result;
      if (dateFilter != null && time != null) {
        result = await conn.execute(
          "SELECT * FROM t_quality_report_refinery WHERE time = :time AND report_date = :dateFilter ORDER BY report_date DESC",
          {"time": time, "dateFilter": dateFilter},
        );
      } else if (dateFilter != null && time == null) {
        result = await conn.execute(
          "SELECT * FROM t_quality_report_refinery WHERE report_date = :dateFilter ORDER BY report_date DESC",
          {"dateFilter": dateFilter},
        );
      } else if (dateFilter == null && time != null) {
        result = await conn.execute(
          "SELECT * FROM t_quality_report_refinery WHERE time = :time ORDER BY report_date DESC",
          {"time": time},
        );
      } else {
        result = await conn.execute(
          "SELECT * FROM t_quality_report_refinery ORDER BY report_date DESC",
        );
      }

      log('Fetched ${result.rows.length}');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all reports: $e');
      return [];
    }
  }
}
