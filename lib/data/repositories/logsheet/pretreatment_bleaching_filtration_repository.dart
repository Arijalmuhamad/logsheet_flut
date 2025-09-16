import 'dart:developer';

import 'package:logsheet_app/data/remote/logsheet/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/data/services/logsheet/pretreatment_bleaching_filtration_mysql_service.dart';

class PretreatmentBleachingFiltrationRepository {
  final PretreatmentBleachingFiltrationMySQLService _mySQLService;

  PretreatmentBleachingFiltrationRepository(this._mySQLService);

  Future<bool> insert(PretreatmentBleachingFiltrationEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  Future<List<PretreatmentBleachingFiltrationEntity>> getAllTicket(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    log("repository getAllLogsheet");
    final List<Map<String, dynamic>> logsheetData = await _mySQLService
        .getAllTickets(dateFilter, time, username, role, plantCode);

    log("fetched from mysql: ${logsheetData.length}");
    final List<PretreatmentBleachingFiltrationEntity> listFromMap =
        logsheetData
            .map((map) => PretreatmentBleachingFiltrationEntity.fromMap(map))
            .toList();

    log("converted: ${listFromMap.length.toString()}");
    return listFromMap;
  }

  Future<bool> update(PretreatmentBleachingFiltrationEntity entity) async {
    return await _mySQLService.updateTicket(entity);
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<bool> deleteTicket(String id, String username) async {
    return await _mySQLService.deleteTicket(id, username);
  }

  Future<bool> sendApproveRejectReport(
    String username,
    String status,
    String userRole,
    int shift,
    String? remark,
    String id,
  ) async {
    return await _mySQLService.sendApproveRejectReport(
      username,
      status,
      userRole,
      shift,
      remark,
      id,
    );
  }

  Future<List<PretreatmentBleachingFiltrationEntity>> getReportsForManager(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> logsheetData = await _mySQLService
        .getReportsForManager(plantCode);
    final List<PretreatmentBleachingFiltrationEntity> listFromMap =
        logsheetData
            .map((map) => PretreatmentBleachingFiltrationEntity.fromMap(map))
            .toList();
    return listFromMap;
  }

  Future<List<PretreatmentBleachingFiltrationEntity>> getFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getTickets(dateFilter, plantCode, shift: shift);

    List<PretreatmentBleachingFiltrationEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => PretreatmentBleachingFiltrationEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }
}
