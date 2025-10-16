class BusinessUnitEntity {
  final String buCode;
  final String buName;
  final String isActive;

  BusinessUnitEntity({
    required this.buCode,
    required this.buName,
    required this.isActive,
  });

  factory BusinessUnitEntity.fromMap(Map<String, dynamic> map) {
    return BusinessUnitEntity(
      buCode: map['bu_code'] as String,
      buName: map['bu_name'] as String,
      isActive: map['isactive'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'bu_code': buCode, 'bu_name': buName, 'isactive': isActive};
  }
}
