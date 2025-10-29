import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';

class MaintenanceStartUpProduksiHeaderEntity {
  final String id;
  final String company;
  final String plant;
  final DateTime? transactionDate;
  final TimeOfDay? transactionTime;
  final String? product;
  final String? workCenter;
  final String? remarks;
  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? checkedBy;
  final DateTime? checkedDate;
  final String? checkedStatus;
  final String? checkedStatusRemarks;
  final String? updatedBy;
  final DateTime? updatedDate;
  final String? formNo;
  final DateTime? dateIssued;
  final String? revisionNo;
  final DateTime? revisionDate;

  // Constructor
  MaintenanceStartUpProduksiHeaderEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.transactionTime,
    required this.product,
    required this.workCenter,
    required this.remarks,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.updatedBy,
    required this.updatedDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  //  factory fromMap, use this to convert map to an object
  factory MaintenanceStartUpProduksiHeaderEntity.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceStartUpProduksiHeaderEntity(
      id: map['id'] as String,
      company: map['company'] as String,
      plant: map['plant'] as String,
      transactionDate: parseDateTime(map['transaction_date']),
      transactionTime: parseTimeOfDay(map['transaction_time']),
      product: map['product'] as String?,
      workCenter: map['work_center'] as String?,
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: parseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      updatedBy: map['updated_by'] as String?,
      updatedDate: parseDateTime(map['updated_date']),
      formNo: map['form_no'] as String?,
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: map['revision_no'] as String?,
      revisionDate: parseDateTime(map['revision_date']),
    );
  }

  //  function toMap, use this to convert the object to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'transaction_time': formatTimeOfDay(transactionTime),
      'product': product,
      'work_center': workCenter,
      'remarks': remarks,
      'flag': flag,
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'updated_by': updatedBy,
      'updated_date': updatedDate?.toIso8601String(),
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
    };
  }

  // copyWith function, use this for updating the object
  MaintenanceStartUpProduksiHeaderEntity copyWith({
    String? id,
    String? company,
    String? plant,
    DateTime? transactionDate,
    TimeOfDay? transactionTime,
    String? product,
    String? workCenter,
    String? remarks,
    String? flag,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? preparedStatus,
    String? preparedStatusRemarks,
    String? checkedBy,
    DateTime? checkedDate,
    String? checkedStatus,
    String? checkedStatusRemarks,
    String? updatedBy,
    DateTime? updatedDate,
    String? formNo,
    DateTime? dateIssued,
    String? revisionNo,
    DateTime? revisionDate,
  }) {
    return MaintenanceStartUpProduksiHeaderEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDate: transactionDate ?? this.transactionDate,
      transactionTime: transactionTime ?? this.transactionTime,
      product: product ?? this.product,
      workCenter: workCenter ?? this.workCenter,
      remarks: remarks ?? this.remarks,
      flag: flag ?? this.flag,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      preparedStatus: preparedStatus ?? this.preparedStatus,
      preparedStatusRemarks:
          preparedStatusRemarks ?? this.preparedStatusRemarks,
      checkedBy: checkedBy ?? this.checkedBy,
      checkedDate: checkedDate ?? this.checkedDate,
      checkedStatus: checkedStatus ?? this.checkedStatus,
      checkedStatusRemarks: checkedStatusRemarks ?? this.checkedStatusRemarks,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
    );
  }
}
