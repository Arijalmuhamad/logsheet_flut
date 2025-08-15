import 'dart:developer';

import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/data/services/transaction/quality_report_refinery_mysql_service.dart';

class QualityReportRefineryRepository {
  final QualityReportRefineryMysqlService _mySQLService;

  QualityReportRefineryRepository(this._mySQLService);

  // Insert Quality Refinery Report
  Future<bool> insert(QualityReportRefineryEntity entity) async {
    return await _mySQLService.insertQualityReportRefinery(entity);
  }

  // Fetch all Quality Refinery Report
  Future<List<QualityReportRefineryEntity>> getAllReports(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllReports(dateFilter, time, username, role, plantCode);

    log(reportsData.length.toString());

    log('converting to list...');

    final List<QualityReportRefineryEntity> mapToList =
        reportsData
            .map((maps) => QualityReportRefineryEntity.fromMap(maps))
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

  Future<bool> updateReport(QualityReportRefineryEntity report) async {
    return await _mySQLService.updateReportQualityRefinery(report);
  }

  Future<List<QualityReportRefineryEntity>> getAllPreparedTransactions(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllPreparedTransactions(plantCode);

    log('converting to list...');
    return reportsData
        .map((maps) => QualityReportRefineryEntity.fromMap(maps))
        .toList();
  }

  Future<bool> sendApproveRejectReport(
    String username,
    String status,
    String userRole,
    int shift,
    String remark,
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
}
