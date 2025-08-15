import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/master/business_unit_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class BusinessUnitMySQLService {
  Future<bool> registerBusinessUnit(BusinessUnitEntity businessUnit) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for business unit registration.');
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "INSERT INTO m_business_unit (bu_code, bu_name, isactive) VALUES (:bu_code, :bu_name, :isactive)",
        {
          "bu_code": businessUnit.buCode,
          "bu_name": businessUnit.buName,
          "isactive": businessUnit.isActive,
        },
      );
      log(
        'Business unit ${businessUnit.buName} teregistrasi: ${result.affectedRows} row(s) affected.',
      );
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error registering business unit: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllBusinessUnit() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all business unit.');
        return [];
      }

      connection = connResult.connection!;

      final result = await connection.execute("SELECT * FROM m_business_unit");
      log('Fetched ${result.numOfRows} Business Units');
      // connResult.connection?.close();
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Gagal mengambil semua business units: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> updateBusinessUnit(BusinessUnitEntity businessUnit) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating Business Unit.');
        return false;
      }

      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE m_business_unit SET isactive = :isactive WHERE bu_code = :bu_code",
        {"isactive": businessUnit.isActive, "bu_code": businessUnit.buCode},
      );

      log('Business Unit updated: ${result.affectedRows} row(s) affected.');
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating business unit: $e');
      return false;
    }
  }

  Future<bool> deleteBusinessUnit(String buCode) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for delete business unit.');
        // connResult.connection?.close();

        return false;
      }

      connection = connResult.connection!;
      final result = await connection.execute(
        "DELETE FROM m_business_unit WHERE bu_code = :bu_code",
        {"bu_code": buCode},
      );

      log('Business unit terhapus: ${result.affectedRows} row(s) affected.');
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting business unit: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection();
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }
}
