class LampsAndGlassEntity {
  final String code;
  final String name;
  String isactive;
  bool statusItem;
  final String category;
  LampsAndGlassEntity({
    required this.code,
    required this.name,
    required this.isactive,
    required this.statusItem,
    required this.category,
  });

  factory LampsAndGlassEntity.fromMap(Map<String, dynamic> map) {
    return LampsAndGlassEntity(
      code: map['code'] as String,
      name: map['name'] as String,
      isactive: map['isactive'] as String,
      statusItem: false,
      category: map['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'isactive': isactive,
      'category': category,
    };
  }
}
