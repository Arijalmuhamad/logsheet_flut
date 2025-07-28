class PlantEntity {
  final String code;
  final String name;
  final String buCode;
  final String isActive;

  PlantEntity({
    required this.code,
    required this.name,
    required this.buCode,
    required this.isActive,
  });

  factory PlantEntity.fromMap(Map<String, dynamic> map) {
    return PlantEntity(
      code: map['plant_code'] as String,
      name: map['plant_name'] as String,
      buCode: map['bu_code'] as String,
      isActive: map['isactive'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plant_code': code,
      'plant_name': name,
      'bu_code': buCode,
      'is_active': isActive,
    };
  }
}
