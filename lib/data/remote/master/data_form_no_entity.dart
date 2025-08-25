class DataFormNoEntity {
  final String id;
  final String? code;
  final String? name;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;
  final String? isActive;
  final String? isMenu;
  final String? entryBy;
  final DateTime? entryDate;

  DataFormNoEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
    required this.isActive,
    required this.isMenu,
    required this.entryBy,
    required this.entryDate,
  });

  factory DataFormNoEntity.fromMap(Map<String, dynamic> map) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    DateTime? parseDateTime(dynamic value) {
      if (value is String) return DateTime.tryParse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    return DataFormNoEntity(
      id: map['f_id'] as String,
      code: map['f_code'] as String?,
      name: map['f_name'] as String?,
      dateIssued: parseDateTime(map['f_date_issued']),
      revisionNo: parseInt(map['f_revision_no']) as int,
      revisionDate: parseDateTime(map['f_revision_date']),
      isActive: map['is_active'] as String?,
      isMenu: map['is_menu'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
    );
  }
}
