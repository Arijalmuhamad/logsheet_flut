import 'dart:developer';

import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/services/daily_production/daily_production_refinery_mysql_service.dart';

class DailyProductionRefineryRepository {
  final DailyProductionRefineryMySQLService _mySQLService;

  DailyProductionRefineryRepository(this._mySQLService);

  // Insert Ticket
  Future<bool> insert(DailyProductionRefineryEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  Future<bool> deleteTicket(String id) async {
    return await _mySQLService.deleteTicket(id);
  }

  // Fetch all Quality Refinery Report
  Future<List<DailyProductionRefineryEntity>> getAllTickets(
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

    final List<DailyProductionRefineryEntity> mapToList =
        reportsData
            .map((maps) => DailyProductionRefineryEntity.fromMap(maps))
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<bool> updateReportTicket(DailyProductionRefineryEntity report) async {
    return await _mySQLService.updateTicket(report);
  }

  Future<List<DailyProductionRefineryEntity>> getReportsForManager(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getReportsForManager(plantCode);

    log('converting to list...');
    return reportsData
        .map((maps) => DailyProductionRefineryEntity.fromMap(maps))
        .toList();
  }

  Future<bool> sendApproveRejectTicket(
    String username,
    String status,
    String userRole,
    int shift,
    String? remark,
    String id,
  ) async {
    return await _mySQLService.sendApproveRejectTicket(
      username,
      status,
      userRole,
      shift,
      remark,
      id,
    );
  }

  // Future<List<int>> getReportedHours(
  //   DateTime dateFilter,
  //   String plantCode,
  // ) async {
  //   return await _mySQLService.getReportedHours(dateFilter, plantCode);
  // }

  // Future<List<DailyProductionRefineryEntity>>
  // getReadyForManagerApprovalReports() async {
  //   log("In the Repository calling the mysql service");
  //   final List<Map<String, dynamic>> reportData =
  //       await _mySQLService.getReadyForManagerApprovalReports();
  //   log("Done calling the mysql service, list length is ${reportData.length}");
  //   return reportData
  //       .map((maps) => DailyProductionRefineryEntity.fromMap(maps))
  //       .toList();
  // }

  Future<List<DailyProductionRefineryEntity>> getFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getTickets(dateFilter, plantCode, shift: shift);

    List<DailyProductionRefineryEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => DailyProductionRefineryEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }
}
