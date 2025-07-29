import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/master/business_unit_entity.dart';

class BusinessUnitMySQLService {
  Future<bool> registerBusinessUnit(BusinessUnitEntity businessUnit) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for business unit registration.');
      return false;
    }

    try {
      final result = await conn.execute(
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
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error registering business unit: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllBusinessUnit() async {
    final conn = await getMySQLConnection();

    if (conn == null) {
      log('Failed to get MySQL connection for get all business unit.');
      return [];
    }

    try {
      final result = await conn.execute("SELECT * FROM m_business_unit");
      log('Fetched ${result.affectedRows} Business Units');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Gagal mengambil semua business units: $e');
      return [];
    }
  }

  Future<bool> updateBusinessUnit(BusinessUnitEntity businessUnit) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for updating Business Unit.');
      return false;
    }

    try {
      final result = await conn.execute(
        "UPDATE m_business_unit SET isactive = :isactive WHERE bu_code = :bu_code",
        {"isactive": businessUnit.isActive, "bu_code": businessUnit.buCode},
      );

      log('Business Unit updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating business unit: $e');
      return false;
    }
  }

  Future<bool> deleteBusinessUnit(String buCode) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for delete business unit.');
      return false;
    }

    try {
      final result = await conn.execute(
        "DELETE FROM m_business_unit WHERE bu_code = :bu_code",
        {"bu_code": buCode},
      );

      log('Business unit terhapus: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting business unit: $e');
      return false;
    }
  }
}
