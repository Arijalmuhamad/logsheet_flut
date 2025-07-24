import 'package:logsheet_app/data/remote/business_unit_entity.dart';
import 'package:logsheet_app/data/services/business_unit_mysql_service.dart';

class BusinessUnitRepository {
  final BusinessUnitMySQLService _businessUnitMySQLService;

  BusinessUnitRepository(this._businessUnitMySQLService);

  // -- CRUD OPERATIONS, FETCH DATA FROM THE MYSQL DATABASE
  //CREATE BUSINESS UNIT
  Future<bool> registerBusinessUnit(BusinessUnitEntity businessUnit) async {
    return await _businessUnitMySQLService.registerBusinessUnit(businessUnit);
  }

  //READ BUSINESS UNIT
  Future<List<BusinessUnitEntity>> getAllBusinessUnits() async {
    final List<Map<String, dynamic>> businessUnitLists =
        await _businessUnitMySQLService.getAllBusinessUnit();

    return businessUnitLists
        .map((map) => BusinessUnitEntity.fromMap(map))
        .toList();
  }

  //UPDATE BUSINESS UNIT

  //DELETE BUSINESS UNIT
  Future<bool> deleteBusinessUnit(String buCode) async {
    return await _businessUnitMySQLService.deleteBusinessUnit(buCode);
  }
}
