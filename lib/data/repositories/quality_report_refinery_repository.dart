import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/data/services/quality_report_refinery_mysql_service.dart';

class QualityReportRefineryRepository {
  final QualityReportRefineryMysqlService _mySQLService;

  QualityReportRefineryRepository(this._mySQLService);

  // Insert Quality Refinery Report
  Future<bool> insert(QualityReportRefineryEntity entity) async {
    return await _mySQLService.insertQualityReportRefinery(entity);
  }
}
