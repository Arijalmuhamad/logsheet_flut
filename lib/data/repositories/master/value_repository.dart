import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
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

  Future<List<TankEntity>> getAllToTankGroup() async {
    final List<Map<String, dynamic>> toTankGroupLists =
        await _mySQLService.getAllToTankGroup();

    return toTankGroupLists.map((map) => TankEntity.fromMap(map)).toList();
  }

  Future<List<TankEntity>> getAllTankSource() async {
    final List<Map<String, dynamic>> tankSourceLists =
        await _mySQLService.getAllToTankGroup();

    return tankSourceLists.map((map) => TankEntity.fromMap(map)).toList();
  }

  Future<List<MasterValueEntity>> getAllWorkCenters() async {
    final List<Map<String, dynamic>> workCenterLists =
        await _mySQLService.getAllWorkCenters();

    return workCenterLists
        .map((map) => MasterValueEntity.fromMap(map))
        .toList();
  }

  Future<List<MasterValueEntity>> getAllFractWorkCenters() async {
    final List<Map<String, dynamic>> workCenterLists =
        await _mySQLService.getAllFractlWorkCenters();

    return workCenterLists
        .map((map) => MasterValueEntity.fromMap(map))
        .toList();
  }
}
