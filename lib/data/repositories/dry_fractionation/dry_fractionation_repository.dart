import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/services/dry_fractionation/dry_fractionation_mysql_service.dart';
import 'package:mysql_client/mysql_client.dart';

class DryFractionationRepository {
  final DryFractionationMySQLService _mySQLService;

  DryFractionationRepository(this._mySQLService);

  // Insert Ticket
  Future<bool> insert(DryFractionationEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  // Get Latest Ticket
  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  // Update Auto Number
  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  // Get All Tickets
  Future<List<DryFractionationEntity>> getAllTickets(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllTickets(dateFilter, time, username, role, plantCode);

    log(reportsData.length.toString());

    log('converting to list...');

    final List<DryFractionationEntity> mapToList =
        reportsData
            .map((maps) => DryFractionationEntity.fromMap(maps))
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }

  // Delete Ticket By ID
  Future<bool> deleteTicket(String id, String username) async {
    return await _mySQLService.deleteTicket(id, username);
  }

  // Update Ticket By ID
  Future<bool> update(DryFractionationEntity entity) async {
    return await _mySQLService.updateTicket(entity);
  }

  // Send Approve Reject Ticket
  Future<bool> sendApproveRejectTicket(
    String username,
    String status,
    String userRole,
    String? remark,
    String id,
  ) async {
    return await _mySQLService.sendApproveRejectTicket(
      username,
      status,
      userRole,
      remark,
      id,
    );
  }

  Future<List<DryFractionationEntity>> getFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getTickets(dateFilter, plantCode, shift: shift);

    List<DryFractionationEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => DryFractionationEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }

  Future<List<DryFractionationEntity>> getReportsForManager(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> logsheetData = await _mySQLService
        .getReportsForManager(plantCode);
    final List<DryFractionationEntity> listFromMap =
        logsheetData.map((map) => DryFractionationEntity.fromMap(map)).toList();
    return listFromMap;
  }
}
