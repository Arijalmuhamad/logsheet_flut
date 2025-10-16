import 'dart:developer';

import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:logsheet_app/data/services/logsheet/deodorizing_filtration_mysql_service.dart';

class DeodorizingFiltrationRepository {
  final DeodorizingFiltrationMySQLService _mySQLService;

  DeodorizingFiltrationRepository(this._mySQLService);

  Future<bool> insert(DeodorizingFiltrationEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  Future<List<DeodorizingFiltrationEntity>> getAllTicket(
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
    final List<DeodorizingFiltrationEntity> listFromMap =
        logsheetData
            .map((map) => DeodorizingFiltrationEntity.fromMap(map))
            .toList();

    log("converted: ${listFromMap.length.toString()}");
    return listFromMap;
  }

  Future<bool> update(DeodorizingFiltrationEntity entity) async {
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

  Future<List<DeodorizingFiltrationEntity>> getReportsForManager(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> logsheetData = await _mySQLService
        .getReportsForManager(plantCode);
    final List<DeodorizingFiltrationEntity> listFromMap =
        logsheetData
            .map((map) => DeodorizingFiltrationEntity.fromMap(map))
            .toList();
    return listFromMap;
  }

  Future<List<DeodorizingFiltrationEntity>> getFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getTickets(dateFilter, plantCode, shift: shift);

    List<DeodorizingFiltrationEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => DeodorizingFiltrationEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }
}
