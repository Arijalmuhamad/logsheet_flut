import 'package:logsheet_app/data/remote/master/master_value_entity.dart';
import 'package:logsheet_app/data/services/master/value_mysql_service.dart';

class ValueRepository {
  final ValueMySQLService _mySQLService;

  ValueRepository({required ValueMySQLService mySQLService})
    : _mySQLService = mySQLService;

  Future<List<MasterValueEntity>> getAllOilTypes() async {
    final List<Map<String, dynamic>> oilTypeLists =
        await _mySQLService.getAllOilType();

    return oilTypeLists.map((map) => MasterValueEntity.fromMap(map)).toList();
  }

  Future<List<MasterValueEntity>> getAllToTankGroup() async {
    final List<Map<String, dynamic>> toTankGroupLists =
        await _mySQLService.getAllToTankGroup();

    return toTankGroupLists
        .map((map) => MasterValueEntity.fromMap(map))
        .toList();
  }

  Future<List<MasterValueEntity>> getAllTankSource() async {
    final List<Map<String, dynamic>> tankSourceLists =
        await _mySQLService.getAllTankSource();

    return tankSourceLists
        .map((map) => MasterValueEntity.fromMap(map))
        .toList();
  }

  Future<List<MasterValueEntity>> getAllWorkCenters() async {
    final List<Map<String, dynamic>> workCenterLists =
        await _mySQLService.getAllWorkCenters();

    return workCenterLists
        .map((map) => MasterValueEntity.fromMap(map))
        .toList();
  }
}
