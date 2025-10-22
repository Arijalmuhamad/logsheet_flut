  class MaintenanceChangeProductChecklistDetailEntity {
    final String id;
    String idHdr;
    final String checkItem;
    final String statusItem;

  MaintenanceChangeProductChecklistDetailEntity({
    required this.id,
    required this.idHdr,
    required this.checkItem,
    required this.statusItem,
  });

  factory MaintenanceChangeProductChecklistDetailEntity.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceChangeProductChecklistDetailEntity(
      id: map['id'],
      idHdr: map['id_hdr'],
      checkItem: map['check_item'],
      statusItem: map['status_item'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_hdr': idHdr,
      'check_item': checkItem,
      'status_item': statusItem,
    };
  }

  MaintenanceChangeProductChecklistDetailEntity copyWith({
    String? id,
    String? idHdr,
    String? checkItem,
    String? statusItem,
  }) {
    return MaintenanceChangeProductChecklistDetailEntity(
      id: id ?? this.id,
      idHdr: idHdr ?? this.idHdr,
      checkItem: checkItem ?? this.checkItem,
      statusItem: statusItem ?? this.statusItem,
    );
  }
}
