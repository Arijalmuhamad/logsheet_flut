class TankEntity {
  final String code;
  final String name;
  final String capacity;
  final String isActive;

  TankEntity({
    required this.code,
    required this.name,
    required this.capacity,
    required this.isActive,
  });

  factory TankEntity.fromMap(Map<String, dynamic> map) {
    return TankEntity(
      code: map['code'],
      name: map['name'],
      capacity: map['capacity'],
      isActive: map['isactive'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'capacity': capacity,
      'isactive': isActive,
    };
  }
}
