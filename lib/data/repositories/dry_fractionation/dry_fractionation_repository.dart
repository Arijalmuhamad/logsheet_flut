import 'dart:developer';

import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/services/dry_fractionation/dry_fractionation_mysql_service.dart';

class DryFractionationRepository {
  final DryFractionationMySQLService _mySQLService;

  DryFractionationRepository(this._mySQLService);

  // Insert Ticket
  Future<bool> insert(DryFractionationEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  // Get Latest Ticket
  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  // Update Auto Number
  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  // Get All Tickets
  Future<List<DryFractionationEntity>> getAllTickets(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllTickets(dateFilter, time, username, role, plantCode);

    log(reportsData.length.toString());

    log('converting to list...');

    final List<DryFractionationEntity> mapToList =
        reportsData
            .map((maps) => DryFractionationEntity.fromMap(maps))
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }
}
