class LampsAndGlassApprovalEntity {
  final String id;
  final String company;
  final String plant;
  final String workCenter;
  final DateTime? checkDate; // originally just date
  final String? remarks;
  final String entryBy;
  final DateTime entryDate;
  final String? checkedBy;
  final DateTime? checkedDate;
  final String? checkedStatus;
  final String? checkedStatusRemarks;

  final String detailId;
  final String checkItem;
  final String statusItem;

  LampsAndGlassApprovalEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.workCenter,
    required this.checkDate,
    required this.remarks,
    required this.entryBy,
    required this.entryDate,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.detailId,
    required this.checkItem,
    required this.statusItem,
  });

  factory LampsAndGlassApprovalEntity.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic value) {
      if (value is String) return DateTime.tryParse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    return LampsAndGlassApprovalEntity(
      id: map['id'] as String,
      company: map['company'] as String,
      plant: map['plant'] as String,
      workCenter: map['work_center'] as String,
      checkDate: parseDateTime(map['check_date']) as DateTime,
      remarks: map['remarks'] as String?,
      entryBy: map['entry_by'] as String,
      entryDate: parseDateTime(map['entry_date']) as DateTime,
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      detailId: map['detail_id'] as String,
      checkItem: map['check_item'] as String,
      statusItem: map['status_item'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'plant': plant,
      'work_center': workCenter,
      'check_date': checkDate?.toIso8601String(),
      'remarks': remarks,
      'entry_by': entryBy,
      'entry_date': entryDate.toIso8601String(),
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'detail_id': detailId,
      'check_item': checkItem,
      'status_item': statusItem,
    };
  }
}
