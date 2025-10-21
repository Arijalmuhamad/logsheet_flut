import 'dart:developer';

import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_production_checklist_header_entity.dart';
import 'package:logsheet_app/data/services/maintenance/change_product_checklist/change_product_checklist_mysql_service.dart';

class ChangeProductChecklistRepository {
  final ChangeProductChecklistMySQLService _mySQLService;

  ChangeProductChecklistRepository(this._mySQLService);

  Future<List<MaintenanceChangeProductChecklistEntity>>
  getLangkahKerja() async {
    final List<Map<String, dynamic>> langkahKerja =
        await _mySQLService.getLangkahKerja();

    final List<MaintenanceChangeProductChecklistEntity> mapToList =
        langkahKerja
            .map(
              (maps) => MaintenanceChangeProductChecklistEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length}');

    return mapToList;
  }

  Future<List<MaintenanceChangeProductChecklistReportEntity>>
  getAllChangeProductFromDate(String date) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllChangeProductFromDate(date);

    log('converting to list...');

    final List<MaintenanceChangeProductChecklistReportEntity> mapToList =
        reportsData
            .map(
              (maps) =>
                  MaintenanceChangeProductChecklistReportEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }

  Future<bool> insertChangeProductChecklist({
    required MaintenanceChangeProductionChecklistHeaderEntity header,
    required List<MaintenanceChangeProductChecklistDetailEntity> details,
  }) async {
    return await _mySQLService.insertChangeProductChecklist(
      header: header,
      details: details,
    );
  }

  Future<bool> deleteChangeProductChecklist(String id) async {
    return await _mySQLService.deleteChangeProductChecklist(id);
  }

  Future<bool> updateChangeProduct({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required List<MaintenanceChangeProductChecklistDetailEntity> details,
  }) async {
    return await _mySQLService.updateChangeProduct(
      id: id,
      company: company,
      plant: plant,
      workCenter: workCenter,
      checkDate: checkDate,
      remarks: remarks,
      details: details,
    );
  }

  Future<String?> getLatestId(String plantCode) async {
    return await _mySQLService.getLatestId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<bool> updateApproveRejectToHeader({
    required String id,
    required String approvedBy,
    required String status,
    required String role,
  }) async {
    return await _mySQLService.updateApproveRejectToHeader(
      id: id,
      approvedBy: approvedBy,
      status: status,
      role: role,
    );
  }

  Future<List<MaintenanceChangeProductChecklistReportEntity>>
  getAllApprovalHeaderAndDetail() async {
    final List<Map<String, dynamic>> reportsData =
        await _mySQLService.getAllApprovalHeaderAndDetail();

    log('converting to list...');

    final List<MaintenanceChangeProductChecklistReportEntity> mapToList =
        reportsData
            .map(
              (maps) =>
                  MaintenanceChangeProductChecklistReportEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }
}
