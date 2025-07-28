import 'dart:developer';

import 'package:logsheet_app/data/remote/plant_entity.dart';
import 'package:logsheet_app/data/services/plant_mysql_service.dart';

class PlantRepository {
  final PlantMySQLService _plantMySQLService;

  PlantRepository(this._plantMySQLService);

  // CREATE PLANT
  Future<bool> createPlant(PlantEntity plant) async {
    return await _plantMySQLService.createPlant(plant);
  }

  // READ ALL PLANTS
  Future<List<PlantEntity>> getAllPlants() async {
    final plantMaps = await _plantMySQLService.getAllPlants();

    log(plantMaps.length.toString());

    return plantMaps.map((map) => PlantEntity.fromMap(map)).toList();
  }

  // UPDATE PLANT
  Future<bool> updatePlant(PlantEntity plant) async {
    return await _plantMySQLService.updatePlant(plant);
  }

  // DELETE PLANT
  Future<bool> deletePlant(String plantCode) async {
    return await _plantMySQLService.deletePlant(plantCode);
  }
}
