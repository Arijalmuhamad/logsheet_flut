import 'dart:developer';

import 'package:logsheet_app/data/remote/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/data/remote/transactions/report_notification_data_entity.dart';
import 'package:logsheet_app/data/services/quality_report/quality_report_qc_mysql_service.dart';

class QualityReportQCRepository {
  final QualityReportQCMySQLService _mySQLService;

  QualityReportQCRepository(this._mySQLService);

  // Insert Quality Refinery Report
  Future<bool> insert(QualityReportQcEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  Future<bool> deleteTicket(String id) async {
    return await _mySQLService.deleteTicket(id);
  }

  // Fetch all Quality Refinery Report
  Future<List<QualityReportQcEntity>> getAllTickets(
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

    final List<QualityReportQcEntity> mapToList =
        reportsData.map((maps) => QualityReportQcEntity.fromMap(maps)).toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<bool> updateReportTicket(QualityReportQcEntity report) async {
    return await _mySQLService.updateTicket(report);
  }

  Future<List<QualityReportQcEntity>> getReportsForManager(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getReportsForManager(plantCode);

    log('converting to list...');
    return reportsData
        .map((maps) => QualityReportQcEntity.fromMap(maps))
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

  Future<List<int>> getReportedHours(
    DateTime dateFilter,
    String plantCode,
  ) async {
    return await _mySQLService.getReportedHours(dateFilter, plantCode);
  }

  Future<List<ReportNotificationDataEntity>>
  getReadyForManagerApprovalReports() async {
    log("In the Repository calling the mysql service");
    final List<Map<String, dynamic>> reportData =
        await _mySQLService.getReadyForManagerApprovalReports();
    log("Done calling the mysql service, list length is ${reportData.length}");
    return reportData
        .map((maps) => ReportNotificationDataEntity.fromMap(maps))
        .toList();
  }

  Future<List<QualityReportQcEntity>> getFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getTickets(dateFilter, plantCode, shift: shift);

    List<QualityReportQcEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => QualityReportQcEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }
}
