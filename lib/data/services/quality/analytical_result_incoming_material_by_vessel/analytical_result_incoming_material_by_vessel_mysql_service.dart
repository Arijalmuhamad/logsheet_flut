import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/data/remote/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class AnalyticalResultIncomingMaterialByVesselMySQLService {
  final String analyticalResultIncomingMaterialByVesselHeaderTable =
      "t_analytical_result_incoming_material_by_vessel";
  final String analyticalResultIncomingMaterialByVesselDetailTable =
      "t_analytical_result_incoming_material_by_vessel_detail";

  Future<bool> insertAnalyticalResultIncomingMaterialByVessel({
    required AnalyticalResultIncomingMaterialByVesselHeaderEntity header,
    required List<AnalyticalResultIncomingMaterialByVesselDetailEntity> details,
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
            'INSERT INTO $analyticalResultIncomingMaterialByVesselHeaderTable (${headerColumns.join(', ')}) VALUES (${headerParams.join(', ')})';
        await connection!.execute(headerSql, headerSqlParams);

        // 2. Insert the Details (if any)
        if (details.isNotEmpty) {
          final values = details
              .map(
                (detail) => '''
                ('${detail.id}', 
                '${detail.idHdr}', 
                '${detail.palkaSNo}', 
                '${detail.palkaSFfa}', 
                '${detail.palkaSIv}', 
                '${detail.palkaSDobi}', 
                '${detail.palkaSMni}', 
                '${detail.palkaCNo}', 
                '${detail.palkaCFfa}', 
                '${detail.palkaCIv}', 
                '${detail.palkaCDobi}', 
                '${detail.palkaCMni}',
                '${detail.palkaPNo}', 
                '${detail.palkaPFfa}', 
                '${detail.palkaPIv}', 
                '${detail.palkaPDobi}', 
                '${detail.palkaPMni}')
                ''',
              )
              .join(', ');

          final String detailSql = '''
          INSERT INTO $analyticalResultIncomingMaterialByVesselDetailTable (
            `id`,
            `id_hdr`,
            `palka_s_no`,
            `palka_s_ffa`,
            `palka_s_iv`,
            `palka_s_dobi`,
            `palka_s_mni`,
            `palka_c_no`,
            `palka_c_ffa`,
            `palka_c_iv`,
            `palka_c_dobi`,
            `palka_c_mni`,
            `palka_p_no`,
            `palka_p_ffa`,
            `palka_p_iv`,
            `palka_p_dobi`,
            `palka_p_mni`
          ) VALUES $values
        ''';
          await connection.execute(detailSql);
        }
      });

      log(
        'Successfully inserted analytical result incoming material by vessel with transaction.',
      );
      return true;
    } catch (e) {
      log(
        'Error during analytical result incoming material by vessel transaction: $e',
      );
      return false;
    } finally {
      await closeMySQLConnection(connection);
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
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as id FROM m_controlnumber WHERE plantid = :plant AND prefix = 'Q09'",
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
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'Q09'";
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
}
