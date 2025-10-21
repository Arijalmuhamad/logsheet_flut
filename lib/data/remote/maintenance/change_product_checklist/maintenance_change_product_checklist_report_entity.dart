class MaintenanceChangeProductChecklistReportEntity {
  final String id;
  final String company;
  final String plant;
  final String transactionDateRef;
  final String transactionTimeRef;
  final String? firstProductRef;
  final String? nextProductRef;
  final String? workCenterRef;
  final String? remarks;
  final String? flag;
  final String? entryBy;
  final String? entryDate;
  final String? preparedBy;
  final String? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? checkedBy;
  final String? checkedDate;
  final String? checkedStatus;
  final String? checkedStatusRemarks;
  final String? updatedBy;
  final String? updatedDate;
  final String? formNo;
  final String? dateIssued;
  final String? revisionNo;
  final String? revisionDate;
  final String detailId;
  final String checkItem;
  final String statusItem;

  MaintenanceChangeProductChecklistReportEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDateRef,
    required this.transactionTimeRef,
    this.firstProductRef,
    this.nextProductRef,
    this.workCenterRef,
    this.remarks,
    this.flag,
    this.entryBy,
    this.entryDate,
    this.preparedBy,
    this.preparedDate,
    this.preparedStatus,
    this.preparedStatusRemarks,
    this.checkedBy,
    this.checkedDate,
    this.checkedStatus,
    this.checkedStatusRemarks,
    this.updatedBy,
    this.updatedDate,
    this.formNo,
    this.dateIssued,
    this.revisionNo,
    this.revisionDate,
    required this.detailId,
    required this.checkItem,
    required this.statusItem,
  });

  factory MaintenanceChangeProductChecklistReportEntity.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceChangeProductChecklistReportEntity(
      id: map['id'] as String,
      company: map['company'] as String,
      plant: map['plant'] as String,
      transactionDateRef: map['transaction_date'] as String,
      transactionTimeRef: map['transaction_time'] as String,
      firstProductRef: map['first_product'] as String?,
      nextProductRef: map['next_product'] as String?,
      workCenterRef: map['work_center'] as String?,
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: map['entry_date'] as String?,
      preparedBy: map['prepared_by'] as String?,
      preparedDate: map['prepared_date'] as String?,
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      checkedBy: map['checked_by'] as String?,
      checkedDate: map['checked_date'] as String?,
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      updatedBy: map['updated_by'] as String?,
      updatedDate: map['updated_date'] as String?,
      formNo: map['form_no'] as String?,
      dateIssued: map['date_issued'] as String?,
      revisionNo: map['revision_no'] as String?,
      revisionDate: map['revision_date'] as String?,
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
      'transaction_date': transactionDateRef,
      'transaction_time': transactionTimeRef,
      'first_product': firstProductRef,
      'next_product': nextProductRef,
      'work_center': workCenterRef,
      'remarks': remarks,
      'flag': flag,
      'entry_by': entryBy,
      'entry_date': entryDate,
      'prepared_by': preparedBy,
      'prepared_date': preparedDate,
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'checked_by': checkedBy,
      'checked_date': checkedDate,
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
      'detail_id': detailId,
      'check_item': checkItem,
      'status_item': statusItem,
    };
  }

  MaintenanceChangeProductChecklistReportEntity copyWith({
    String? id,
    String? company,
    String? plant,
    String? transactionDateRef,
    String? transactionTimeRef,
    String? firstProductRef,
    String? nextProductRef,
    String? workCenterRef,
    String? remarks,
    String? flag,
    String? entryBy,
    String? entryDate,
    String? preparedBy,
    String? preparedDate,
    String? preparedStatus,
    String? preparedStatusRemarks,
    String? checkedBy,
    String? checkedDate,
    String? checkedStatus,
    String? checkedStatusRemarks,
    String? updatedBy,
    String? updatedDate,
    String? formNo,
    String? dateIssued,
    String? revisionNo,
    String? revisionDate,
    String? detailId,
    String? checkItem,
    String? statusItem,
  }) {
    return MaintenanceChangeProductChecklistReportEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDateRef: transactionDateRef ?? this.transactionDateRef,
      transactionTimeRef: transactionTimeRef ?? this.transactionTimeRef,
      firstProductRef: firstProductRef ?? this.firstProductRef,
      nextProductRef: nextProductRef ?? this.nextProductRef,
      workCenterRef: workCenterRef ?? this.workCenterRef,
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
      detailId: detailId ?? this.detailId,
      checkItem: checkItem ?? this.checkItem,
      statusItem: statusItem ?? this.checkItem,
    );
  }
}
