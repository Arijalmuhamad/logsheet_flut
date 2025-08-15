class MasterValueEntity {
  final String id;
  final String code;
  final String name;
  final String group;
  final int number;
  final String isActive;
  final String entryBy;
  final DateTime entryDate;

  MasterValueEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.group,
    required this.number,
    required this.isActive,
    required this.entryBy,
    required this.entryDate,
  });
  factory MasterValueEntity.fromMap(Map<String, dynamic> map) {
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

    return MasterValueEntity(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      group: map['group'],
      number: parseInt(map['number']) ?? 0,
      isActive: map['isactive'],
      entryBy: map['entry_by'],
      entryDate: parseDateTime(map['entry_date']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'group': group,
      'number': number,
      'isactive': isActive,
      'entry_by': entryBy,
      'entry_date': entryDate,
    };
  }
}
