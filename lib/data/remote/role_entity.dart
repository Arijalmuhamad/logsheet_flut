class RoleEntity {
  final String code;
  final String name;

  RoleEntity({required this.code, required this.name});

  factory RoleEntity.fromMap(Map<String, dynamic> map) {
    return RoleEntity(code: map['role_code'], name: map['role_name']);
  }

  Map<String, dynamic> toMap() {
    return {'role_code': code, 'role_name': name};
  }
}
