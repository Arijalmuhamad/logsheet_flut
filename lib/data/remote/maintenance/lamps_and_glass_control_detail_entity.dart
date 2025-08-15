class LampsAndGlassControlDetailEntity {
  final String id;
  final String idHdr;
  final String checkItem;
  final String statusItem;

  LampsAndGlassControlDetailEntity({
    required this.id,
    required this.idHdr,
    required this.checkItem,
    required this.statusItem,
  });

  factory LampsAndGlassControlDetailEntity.fromMap(Map<String, dynamic> map) {
    return LampsAndGlassControlDetailEntity(
      id: map['id'] as String,
      idHdr: map['id_hdr'] as String,
      checkItem: map['check_item'] as String,
      statusItem: map['status_item'] as String,
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
}
