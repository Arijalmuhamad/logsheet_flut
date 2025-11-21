class DailyStorageTankAnalyticalFromDbEntity {
  final String? id;
  final String? company;
  final String? plant;
  final String? transactionDate;
  final String? postingDate;
  final String? tankNo;
  final String? oilType;
  final String? kapasitasTanki;
  final String? quantity;
  final String? emptySpace;
  final String? suhu;
  final String? qpFFA; // fgFFA
  final String? qpMoisture;
  final String? qpColorR; //qpColorR
  final String? qpColorY; //qpColorY
  final String? qpIV;
  final String? qpPV;
  final String? qpSlipMeltingPoint;
  final String? qpCloudPoint;
  final String? qpANV;
  final String? betaCarotene;
  final String? qpP;
  final String? qpDobi;
  final String? qpTotox;
  final String? qpOdor;
  final String? remarks;
  final String? flag;
  final String? entryBy;
  final String? entryDate;
  final String? preparedBy;
  final String? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? approvedBy;
  final String? approvedDate;
  final String? approvedStatus;
  final String? approvedStatusRemarks;
  final String? updatedBy;
  final String? updatedDate;
  final String? formNo;
  final String? dateIssued;
  final String? revisionNo;
  final String? revisionDate;

  DailyStorageTankAnalyticalFromDbEntity({
    required this.id,
    required this.transactionDate,
    required this.postingDate,
    required this.tankNo,
    required this.oilType,
    required this.kapasitasTanki,
    required this.quantity,
    required this.emptySpace,
    required this.suhu,
    required this.qpFFA,
    required this.qpMoisture,
    required this.qpColorR,
    required this.qpColorY,

    required this.qpIV,
    required this.qpPV,
    required this.qpSlipMeltingPoint,
    required this.qpCloudPoint,
    required this.qpANV,
    required this.betaCarotene,
    required this.qpP,
    required this.qpDobi,
    required this.qpTotox,
    required this.qpOdor,
    required this.remarks,
    required this.company,
    required this.plant,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.approvedBy,
    required this.approvedDate,
    required this.approvedStatus,
    required this.approvedStatusRemarks,
    required this.updatedBy,
    required this.updatedDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  // 🔹 FROM MAP
  factory DailyStorageTankAnalyticalFromDbEntity.fromMap(Map<String, dynamic> map) {
    return DailyStorageTankAnalyticalFromDbEntity(
      id: map['id'] as String?,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: map['transaction_date'] as String?,
      postingDate: map['posting_date'] as String?,
      tankNo: map['tank_no'] as String?,
      oilType: map['oil_type'] as String?,
      kapasitasTanki: map['kapasitas_tanki'] as String?,
      quantity: map['quantity'] as String?,
      emptySpace: map['empty_space'] as String?,
      suhu: map['suhu'] as String?,
      qpFFA: map['qp_ffa'] as String?,
      qpMoisture: map['qp_moisture'] as String?,
      qpColorR: map['qp_lovibond_color_r'] as String?,
      qpColorY: map['qp_lovibond_color_y'] as String?,
      qpIV: map['qp_iv'] as String?,
      qpPV: map['qp_pv'] as String?,
      qpSlipMeltingPoint: map['qp_slip_melting_point'] as String?,
      qpCloudPoint: map['qp_cloud_point'] as String?,
      qpANV: map['qp_anv'] as String?,
      betaCarotene: map['qp_beta_carotene'] as String?,
      qpP: map['qp_p'] as String?,
      qpDobi: map['qp_dobi'] as String?,
      qpTotox: map['qp_totox'] as String?,
      qpOdor: map['qp_odor'] as String?,
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: map['entry_date'] as String?,
      preparedBy: map['prepared_by'] as String?,
      preparedDate: map['prepared_date'] as String?,
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      approvedBy: map['approved_by'] as String?,
      approvedDate: map['approved_date'] as String?,
      approvedStatus: map['approved_status'] as String?,
      approvedStatusRemarks: map['approved_status_remarks'] as String?,
      updatedBy: map['updated_by'] as String?,
      updatedDate: map['updated_date'] as String?,
      formNo: map['form_no'] as String?,
      dateIssued: map['date_issued'] as String?,
      revisionNo: map['revision_no'] as String?,
      revisionDate: map['revision_date'] as String?,
    );
  }

  // 🔹 TO MAP
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate,
      'posting_date': postingDate,
      'tank_no': tankNo,
      'oil_type': oilType,
      'kapasitas_tanki': kapasitasTanki,
      'quantity': quantity,
      'empty_space': emptySpace,
      'suhu': suhu,
      'qp_ffa': qpFFA,
      'qp_moisture': qpMoisture,
      'qp_lovibond_color_r': qpColorR,
      'qp_lovibond_color_y': qpColorY,
      'qp_iv': qpIV,
      'qp_pv': qpPV,
      'qp_slip_melting_point': qpSlipMeltingPoint,
      'qp_cloud_point': qpCloudPoint,
      'qp_anv': qpANV,
      'qp_beta_carotene': betaCarotene,
      'qp_p': qpP,
      'qp_dobi': qpDobi,
      'qp_totox': qpTotox,
      'qp_odor': qpOdor,
      'remarks': remarks,
      'flag': flag,
      'entry_by': entryBy,
      'entry_date': entryDate,
      'prepared_by': preparedBy,
      'prepared_date': preparedDate,
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'approved_by': approvedBy,
      'approved_date': approvedDate,
      'approved_status': approvedStatus,
      'approved_status_remarks': approvedStatusRemarks,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
    };
  }

  // 🔹 COPYWITH
  DailyStorageTankAnalyticalFromDbEntity copyWith({
    String? id,
    String? company,
    String? plant,
    String? transactionDate,
    String? postingDate,
    String? tankNo,
    String? oilType,
    String? kapasitasTanki,
    String? quantity,
    String? emptySpace,
    String? suhu,
    String? qpFFA,
    String? qpMoisture,
    String? qpColorR,
    String? qpColorY,
    String? qpIV,
    String? qpPV,
    String? qpSlipMeltingPoint,
    String? qpCloudPoint,
    String? qpANV,
    String? betaCarotene,
    String? qpP,
    String? qpDobi,
    String? qpTotox,
    String? qpOdor,
    String? remarks,
    String? flag,
    String? entryBy,
    String? entryDate,
    String? preparedBy,
    String? preparedDate,
    String? preparedStatus,
    String? preparedStatusRemarks,
    String? approvedBy,
    String? approvedDate,
    String? approvedStatus,
    String? approvedStatusRemarks,
    String? updatedBy,
    String? updatedDate,
    String? formNo,
    String? dateIssued,
    String? revisionNo,
    String? revisionDate,
  }) {
    return DailyStorageTankAnalyticalFromDbEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      tankNo: tankNo ?? this.tankNo,
      oilType: oilType ?? this.oilType,
      kapasitasTanki: kapasitasTanki ?? this.kapasitasTanki,
      quantity: quantity ?? this.quantity,
      emptySpace: emptySpace ?? this.emptySpace,
      suhu: suhu ?? this.suhu,
      qpFFA: qpFFA ?? this.qpFFA,
      qpMoisture: qpMoisture ?? this.qpMoisture,
      qpColorR: qpColorR ?? this.qpColorR,
      qpColorY: qpColorY ?? this.qpColorY,
      qpIV: qpIV ?? this.qpIV,
      qpPV: qpPV ?? this.qpPV,
      qpSlipMeltingPoint: qpSlipMeltingPoint ?? this.qpSlipMeltingPoint,
      qpCloudPoint: qpCloudPoint ?? this.qpCloudPoint,
      qpANV: qpANV ?? this.qpANV,
      betaCarotene: betaCarotene ?? this.betaCarotene,
      qpP: qpP ?? this.qpP,
      qpDobi: qpDobi ?? this.qpDobi,
      qpTotox: qpTotox ?? this.qpTotox,
      qpOdor: qpOdor ?? this.qpOdor,
      remarks: remarks ?? this.remarks,
      flag: flag ?? this.flag,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      preparedStatus: preparedStatus ?? this.preparedStatus,
      preparedStatusRemarks:
          preparedStatusRemarks ?? this.preparedStatusRemarks,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedStatus: approvedStatus ?? this.approvedStatus,
      approvedStatusRemarks:
          approvedStatusRemarks ?? this.approvedStatusRemarks,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
    );
  }
}
