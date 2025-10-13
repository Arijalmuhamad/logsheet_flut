import 'dart:developer';

import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_approval_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_report_entity.dart';
import 'package:logsheet_app/data/services/maintenance/maintenance_lamps_and_glass_mysql_service.dart';

class MaintenanceLampsAndGlassRepository {
  final MaintenanceLampsAndGlassMySQLService _mySQLService;

  MaintenanceLampsAndGlassRepository(this._mySQLService);

  Future<List<LampsAndGlassEntity>> getAllLampsAndGlass() async {
    final List<Map<String, dynamic>> lampsAndGlassLists =
        await _mySQLService.getAllLampsAndGlass();

    return lampsAndGlassLists
        .map((map) => LampsAndGlassEntity.fromMap(map))
        .toList();
  }

  Future<List<LampsAndGlassReportEntity>> getAllLampsAndGlassFromDate(
    String time,
  ) async {
    final List<Map<String, dynamic>> lampsAndGlassLists = await _mySQLService
        .getAllLampsAndGlassFromDate(time);

    log("Passed the repository function.");

    return lampsAndGlassLists
        .map((map) => LampsAndGlassReportEntity.fromMap(map))
        .toList();
  }

  Future<List<LampsAndGlassApprovalEntity>> getAllLampsAndGlassFromMonth({
    required int year,
    required int month,
  }) async {
    final List<Map<String, dynamic>> lampsAndGlassBasedOnMonthLists =
        await _mySQLService.getAllLampsAndGlassFromMonth(year, month);

    log("Passed the repository function.");

    return lampsAndGlassBasedOnMonthLists
        .map((map) => LampsAndGlassApprovalEntity.fromMap(map))
        .toList();
  }

  Future<bool> updateApproveRejectToHeader({
    required String checkedBy,
    required String status,
    required int month,
    required int year,
    required String? remark,
  }) async {
    return await _mySQLService.updateApproveRejectToHeader(
      checkedBy: checkedBy,
      status: status,
      month: month,
      year: year,
      remark: remark,
    );
  }

  Future<bool> isDataExistForDate({
    required String workCenter,
    required String date,
  }) async {
    return await _mySQLService.isDataExistForDate(workCenter, date);
  }

  Future<bool> insertToControl(LampsAndGlassControlEntity entity) async {
    return await _mySQLService.insertLampsAndGlassToControl(entity);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<String?> getLatestId(String plantCode) async {
    return await _mySQLService.getLatestId(plantCode);
  }

  Future<bool> insertToControlDetail(
    List<LampsAndGlassControlDetailEntity> entityList,
  ) async {
    return await _mySQLService.insertLampsAndGlassToControlDetail(entityList);
  }

  Future<bool> deleteLampsAndGlass(String id) async {
    return await _mySQLService.deleteLampsAndGlass(id);
  }
}
