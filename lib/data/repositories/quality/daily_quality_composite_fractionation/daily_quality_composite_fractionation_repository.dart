import 'dart:developer';

import 'package:logsheet_app/data/remote/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:logsheet_app/data/services/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_mysql_service.dart';

class DailyQualityCompositeFractionationRepository {
  final DailyQualityCompositeFractionationMysqlService _mySQLService;

  DailyQualityCompositeFractionationRepository(this._mySQLService);

  Future<bool> insertDailyQualityCompositeFractionation({
    required DailyQualityCompositeFractionationEntity report,
  }) async {
    return await _mySQLService.insertDailyQualityCompositeFractionationReport(
      report: report,
    );
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<String?> getLatestId(String plantCode) async {
    return await _mySQLService.getLatestId(plantCode);
  }

  Future<List<DailyQualityCompositeFractionationEntity>>
  getAllDailyQualityCompositeReport(String date, String role) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllDailyQualityCompositeReport(date, role);

    log('converting to list...');

    final List<DailyQualityCompositeFractionationEntity> mapToList = [];

    for (final maps in reportsData) {
      try {
        log("Converting: $maps");
        final entity = DailyQualityCompositeFractionationEntity.fromMap(maps);
        mapToList.add(entity);
      } catch (e, st) {
        log("❌ Error converting map: $e\n$st");
      }
    }

    log('converted ${mapToList.length}');
    return mapToList;
  }

  Future<bool> deletedailyQualityCompositeFractionationReport(String id) async {
    return await _mySQLService.deleteDailyStorageTankAnalyticalReport(id);
  }

  Future<bool> updateDailyQualityCompositeFractionationReport(
    DailyQualityCompositeFractionationEntity entity,
    String id,
  ) async {
    return await _mySQLService.updateDailyQualityCompositeFractionationReport(
      report: entity,
      id: id,
    );
  }

  Future<List<DailyQualityCompositeFractionationEntity>> getAllDailyQualityCompositeApprovalReport(
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllDailyQualityCompositeApprovalReport();

    log('converting to list...');

    final List<DailyQualityCompositeFractionationEntity> mapToList = [];

    for (final maps in reportsData) {
      try {
        log("Converting: $maps");
        final entity = DailyQualityCompositeFractionationEntity.fromMap(maps);
        mapToList.add(entity);
      } catch (e, st) {
        log("❌ Error converting map: $e\n$st");
      }
    }

    log('converted ${mapToList.length}');
    return mapToList;
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
}
