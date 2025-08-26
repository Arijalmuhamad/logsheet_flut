import 'dart:developer';

import 'package:logsheet_app/data/remote/transactions/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/data/services/logsheet/pretreatment_bleaching_filtration_mysql_service.dart';

class PretreatmentBleachingFiltrationRepository {
  final PretreatmentBleachingFiltrationMySQLService _mySQLService;

  PretreatmentBleachingFiltrationRepository(this._mySQLService);

  Future<bool> insert(PretreatmentBleachingFiltrationEntity entity) async {
    return await _mySQLService.insert(entity);
  }

  Future<List<PretreatmentBleachingFiltrationEntity>> getAllLogsheet() async {
    log("repository getAllLogsheet");
    final List<Map<String, dynamic>> logsheetData =
        await _mySQLService.getAllLogsheet();

    log("fetched from mysql: ${logsheetData.length}");
    final List<PretreatmentBleachingFiltrationEntity> listFromMap =
        logsheetData
            .map((map) => PretreatmentBleachingFiltrationEntity.fromMap(map))
            .toList();

    log("converted: ${listFromMap.length.toString()}");
    return listFromMap;
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }
}
