import 'dart:developer';

import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_header_entity.dart';
import 'package:logsheet_app/data/services/maintenance/start_up_produksi_checklist/start_up_produksi_checklist_mysql_service.dart';

class StartUpProduksiChecklistRepository {
  final StartUpProduksiChecklistMySQLService _mySQLService;

  StartUpProduksiChecklistRepository(this._mySQLService);

  Future<List<MaintenanceStartUpProduksiChecklistEntity>>
  getLangkahKerja() async {
    final List<Map<String, dynamic>> langkahKerja =
        await _mySQLService.getLangkahKerja();

    final List<MaintenanceStartUpProduksiChecklistEntity> mapToList =
        langkahKerja
            .map(
              (maps) => MaintenanceStartUpProduksiChecklistEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length}');

    return mapToList;
  }

  Future<List<MaintenanceStartUpProduksiChecklistReportEntity>>
  getAllReportsFromDate(String date, String role) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllReportsFromDate(date, role);

    log('converting to list...');

    final List<MaintenanceStartUpProduksiChecklistReportEntity> mapToList =
        reportsData
            .map(
              (maps) =>
                  MaintenanceStartUpProduksiChecklistReportEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }

  Future<bool> insertReportsChecklist({
    required MaintenanceStartUpProduksiHeaderEntity header,
    required List<MaintenanceStartUpProduksiChecklistDetailEntity> details,
  }) async {
    return await _mySQLService.insertReportChecklist(
      header: header,
      details: details,
    );
  }

  Future<bool> deleteReportChecklist(String id) async {
    return await _mySQLService.deleteReportChecklist(id);
  }

  Future<bool> updateReportChecklist({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required String updatedBy,
    required DateTime updatedAt,
    required List<MaintenanceStartUpProduksiChecklistDetailEntity> details,
  }) async {
    return await _mySQLService.updateReport(
      id: id,
      company: company,
      plant: plant,
      workCenter: workCenter,
      checkDate: checkDate,
      remarks: remarks,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
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
    String? remarks,
  }) async {
    return await _mySQLService.updateApproveRejectToHeader(
      id: id,
      approvedBy: approvedBy,
      status: status,
      role: role,
      remarks: remarks,
    );
  }

  Future<List<MaintenanceStartUpProduksiChecklistReportEntity>>
  getAllApprovalHeaderAndDetail() async {
    final List<Map<String, dynamic>> reportsData =
        await _mySQLService.getAllApprovalHeaderAndDetail();

    log('converting to list...');

    final List<MaintenanceStartUpProduksiChecklistReportEntity> mapToList =
        reportsData
            .map(
              (maps) =>
                  MaintenanceStartUpProduksiChecklistReportEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }
}
