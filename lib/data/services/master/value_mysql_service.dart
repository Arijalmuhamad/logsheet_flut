import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';

class ValueMySQLService {
  Future<List<Map<String, dynamic>>> getAllOilType() async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all oil type.');
        return [];
      }
      final result = await connResult.connection!.execute(
        "SELECT * FROM m_mastervalue WHERE`group` = :oil_type",
        {"oil_type": "OIL_TYPE"},
      );
      log('Fetched ${result.rows.length} oil types from master value.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all oil types from master value table: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllToTankGroup() async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all tank group.');
        return [];
      }
      final result = await connResult.connection!.execute(
        "SELECT * FROM m_mastervalue WHERE`group` =:to_tank",
        {"to_tank": "TO_TANK"},
      );
      log('Fetched ${result.rows.length} tank group(s) from master value.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all tank groups from master value table: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllTankSource() async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all tank source.');
        return [];
      }
      final result = await connResult.connection!.execute(
        "SELECT * FROM m_mastervalue WHERE`group` =:source_tank",
        {"source_tank": "SOURCE_TANK"},
      );
      log('Fetched ${result.rows.length} tank source(s) from master value.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all tank sources from master value table: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllWorkCenters() async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all Work Centers.');
        return [];
      }
      final result = await connResult.connection!.execute(
        "SELECT * FROM m_mastervalue WHERE`group` =:refinery",
        {"refinery": "REFINERY"},
      );
      log(
        'Fetched ${result.rows.length} refinery machine(s) from master value.',
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all refinery machines from master value table: $e');
      return [];
    }
  }
}
