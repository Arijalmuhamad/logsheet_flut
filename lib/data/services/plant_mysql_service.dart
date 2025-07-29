import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/master/plant_entity.dart';

class PlantMySQLService {
  // Create Plant
  Future<bool> createPlant(PlantEntity plant) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for plant registration.');
      return false;
    }

    try {
      final result = await conn.execute(
        "INSERT INTO m_plant (plant_code, plant_name, bu_code, isactive) VALUES (:plant_code, :plant_name, :bu_code, :isactive)",
        {
          "plant_code": plant.code,
          "plant_name": plant.name,
          "bu_code": plant.buCode,
          "isactive": plant.isActive,
        },
      );

      log(
        "Plant ${plant.name} teregistrasi: ${result.affectedRows} row(s) affected.",
      );
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error registering plant: $e');
      return false;
    }
  }

  // Get All Plants
  Future<List<Map<String, dynamic>>> getAllPlants() async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for get all plants.');
      return [];
    }
    try {
      final result = await conn.execute("SELECT * FROM m_plant");
      log('Fetched ${result.rows.length} plants');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all plants: $e');
      return [];
    }
  }

  // Update Plant
  Future<bool> updatePlant(PlantEntity plant) async {
    final conn = await getMySQLConnection();
    if (conn == null) {
      log('Failed to get MySQL connection for updating plant.');
      return false;
    }

    try {
      final result = await conn.execute(
        "UPDATE m_plant SET bu_code = :bu_code, isactive = :isactive WHERE plant_code = :plant_code",
        {
          "bu_code": plant.buCode,
          "isactive": plant.isActive,
          "plant_code": plant.code,
        },
      );
      log('Plant updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating plant: $e');
      return false;
    }
  }

  // Delete Plant
  Future<bool> deletePlant(String plantCode) async {
    final conn = await getMySQLConnection();

    if (conn == null) {
      log('Failed to get MySQL connection for deleting plant.');
      return false;
    }

    try {
      final result = await conn.execute(
        "DELETE FROM m_plant WHERE plant_code = :plant_code",
        {"plant_code": plantCode},
      );
      log('Plant terhapus: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log("Error deleting plant: $e");
      return false;
    }
  }
}
