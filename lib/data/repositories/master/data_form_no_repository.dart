import 'dart:developer';

import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/services/master/data_form_no_mysql_service.dart';

class DataFormNoRepository {
  final DataFormNoMySQLService _mysql;

  DataFormNoRepository(this._mysql);

  Future<List<DataFormNoEntity>> getAllDataFormNo() async {
    log("in DataFormNoRepository getAllDataFormNo function");

    List<Map<String, dynamic>> list = await _mysql.getAllDataFormNo();
    return list.map((map) => DataFormNoEntity.fromMap(map)).toList();
  }
}
