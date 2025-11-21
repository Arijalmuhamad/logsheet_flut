import 'package:logsheet_app/data/remote/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/data/remote/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/data/services/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_mysql_service.dart';

class AnalyticalResultIncomingMaterialByVesselRepository {
  final AnalyticalResultIncomingMaterialByVesselMySQLService _mySQLService;

  AnalyticalResultIncomingMaterialByVesselRepository(this._mySQLService);

  Future<bool> insertAnalyticalResultIncomingMaterialByVessel({
    required AnalyticalResultIncomingMaterialByVesselHeaderEntity header,
    required List<AnalyticalResultIncomingMaterialByVesselDetailEntity> details,
  }) async {
    return await _mySQLService.insertAnalyticalResultIncomingMaterialByVessel(
      header: header,
      details: details,
    );
  }

  Future<String?> getLatestId(String plantCode) async {
    return await _mySQLService.getLatestId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }
}
