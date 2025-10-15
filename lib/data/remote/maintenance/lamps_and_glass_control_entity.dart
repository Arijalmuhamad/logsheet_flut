import 'package:logsheet_app/core/utils/parser_utils.dart';

class LampsAndGlassControlEntity {
  final String id;
  final String company;
  final String plant;
  final String workCenter;
  final DateTime? checkDate; // originally just date
  final String remarks;
  final String entryBy;
  final DateTime entryDate;
  final String? checkedBy;
  final DateTime? checkedDate;
  final String? checkedStatus;
  final String? checkedStatusRemarks;
  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  LampsAndGlassControlEntity({
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
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  factory LampsAndGlassControlEntity.fromMap(Map<String, dynamic> map) {
    return LampsAndGlassControlEntity(
      id: map['id'] as String,
      company: map['company'] as String,
      plant: map['plant'] as String,
      workCenter: map['work_center'] as String,
      checkDate: map['check_date'] as DateTime, // must use parsing
      remarks: map['remarks'] as String,
      entryBy: map['entry_by'] as String,
      entryDate: map['entry_date'] as DateTime, // must use parsing
      checkedBy: map['checked_by'] as String?,
      checkedDate: map['checked_date'] as DateTime?,
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      formNo: map['form_no'] as String?,
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: parseDateTime(map['revision_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'plant': plant,
      'work_center': workCenter,
      'check_date': checkDate,
      'remarks': remarks,
      'entry_by': entryBy,
      'entry_date': entryDate,
      'checked_by': checkedBy,
      'checked_date': checkedDate,
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
    };
  }
}
