import 'package:logsheet_app/core/utils/parser_utils.dart';

class ChangeProductChecklistEntity {
  final String code;
  final String? name;
  final int? sortNo;
  final String? category;
  final String? workCenter;
  final String? workCenterGroup;
  final String? isActive;

  ChangeProductChecklistEntity({
    required this.code,
    required this.name,
    required this.sortNo,
    required this.category,
    required this.workCenter,
    required this.workCenterGroup,
    required this.isActive,
  });

  factory ChangeProductChecklistEntity.fromMap(Map<String, dynamic> map) {
    return ChangeProductChecklistEntity(
      code: map['code'] as String,
      name: map['name'] as String?,
      sortNo: parseInt(map['sort_no']),
      category: map['category'],
      workCenter: map['work_center'],
      workCenterGroup: map['work_center_group'],
      isActive: map['isactive'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'sort_no': sortNo,
      'category': category,
      'work_center': workCenter,
      'work_center_group': workCenterGroup,
      'is_active': isActive,
    };
  }

  ChangeProductChecklistEntity copyWith({
    String? code,
    String? name,
    int? sortNo,
    String? category,
    String? workCenter,
    String? workCenterGroup,
    String? isActive,
  }) {
    return ChangeProductChecklistEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      sortNo: sortNo ?? this.sortNo,
      category: category ?? this.category,
      workCenter: workCenter ?? this.workCenter,
      workCenterGroup: workCenterGroup ?? this.workCenterGroup,
      isActive: isActive ?? this.isActive,
    );
  }
}
