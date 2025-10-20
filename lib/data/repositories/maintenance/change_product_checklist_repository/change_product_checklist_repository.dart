import 'dart:developer';

import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/change_product_checklist_entity.dart';
import 'package:logsheet_app/data/services/maintenance/change_product_checklist/change_product_checklist_mysql_service.dart';

class ChangeProductChecklistRepository {
  final ChangeProductChecklistMySQLService _mySQLService;

  ChangeProductChecklistRepository(this._mySQLService);

  Future<List<ChangeProductChecklistEntity>> getLangkahKerja() async {
    final List<Map<String, dynamic>> langkahKerja =
        await _mySQLService.getLangkahKerja();

    final List<ChangeProductChecklistEntity> mapToList =
        langkahKerja
            .map((maps) => ChangeProductChecklistEntity.fromMap(maps))
            .toList();

    log('converted ${mapToList.length}');

    return mapToList;
  }
}
