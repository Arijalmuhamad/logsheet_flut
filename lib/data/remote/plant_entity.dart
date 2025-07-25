class PlantEntity {
  final String plantCode;
  final String? plantName;
  final String buCode;
  final String? isActive;

  PlantEntity({
    required this.plantCode,
    required this.plantName,
    required this.buCode,
    required this.isActive,
  });

  factory PlantEntity.fromMap(Map<String, dynamic> map) {
    return PlantEntity(
      plantCode: map['plant_code'] as String,
      plantName: map['plant_name'] as String?,
      buCode: map['bu_code'] as String,
      isActive: map['is_active'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plant_code': plantCode,
      'plant_name': plantName,
      'bu_code': buCode,
      'is_active': isActive,
    };
  }
}
