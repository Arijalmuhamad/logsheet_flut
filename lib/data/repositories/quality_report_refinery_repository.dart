import 'dart:developer';

import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/data/services/quality_report_refinery_mysql_service.dart';

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
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllReports(dateFilter, time);

    log(reportsData.length.toString());

    log('converting to list...');

    final List<QualityReportRefineryEntity> mapToList =
        reportsData
            .map((maps) => QualityReportRefineryEntity.fromMap(maps))
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }
}
