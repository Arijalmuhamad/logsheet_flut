import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/master/plant_entity.dart';

class PlantMySQLService {
  // Create Plant
  Future<bool> createPlant(PlantEntity plant) async {
    final connResult = await getMySQLConnection();
    if (connResult.connection == null) {
      log('Failed to get MySQL connection for plant registration.');
      return false;
    }

    try {
      final result = await connResult.connection!.execute(
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
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error registering plant: $e');
      return false;
    }
  }

  // Get All Plants
  Future<List<Map<String, dynamic>>> getAllPlants() async {
    final connResult = await getMySQLConnection();
    if (connResult.connection == null) {
      log('Failed to get MySQL connection for get all plants.');
      return [];
    }
    try {
      final result = await connResult.connection!.execute(
        "SELECT * FROM m_plant",
      );
      log('Fetched ${result.rows.length} plants');
      // connResult.connection?.close();
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all plants: $e');
      return [];
    }
  }

  // Get Plants based on Business Units Code
  Future<List<Map<String, dynamic>>> getPlantsByBusinessUnits(
    String buCode,
  ) async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for get plants by business units code',
        );
        connResult.connection?.close();
        return [];
      }
      final result = await connResult.connection!.execute(
        "SELECT * FROM m_plant WHERE bu_code = :bu_code",
        {"bu_code": buCode},
      );
      // connResult.connection?.close();
      log('Fetched ${result.rows.map((row) => row.assoc()).toList()} Plants');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all plants by business units code: $e');
      return [];
    }
  }

  // Update Plant
  Future<bool> updatePlant(PlantEntity plant) async {
    final connResult = await getMySQLConnection();
    if (connResult.connection == null) {
      log('Failed to get MySQL connection for updating plant.');
      return false;
    }

    try {
      final result = await connResult.connection!.execute(
        "UPDATE m_plant SET bu_code = :bu_code, isactive = :isactive WHERE plant_code = :plant_code",
        {
          "bu_code": plant.buCode,
          "isactive": plant.isActive,
          "plant_code": plant.code,
        },
      );
      // connResult.connection?.close();
      log('Plant updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating plant: $e');
      return false;
    }
  }

  // Delete Plant
  Future<bool> deletePlant(String plantCode) async {
    final connResult = await getMySQLConnection();

    if (connResult.connection == null) {
      log('Failed to get MySQL connection for deleting plant.');
      return false;
    }

    try {
      final result = await connResult.connection!.execute(
        "DELETE FROM m_plant WHERE plant_code = :plant_code",
        {"plant_code": plantCode},
      );
      // connResult.connection?.close();
      log('Plant terhapus: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log("Error deleting plant: $e");
      return false;
    }
  }
}
