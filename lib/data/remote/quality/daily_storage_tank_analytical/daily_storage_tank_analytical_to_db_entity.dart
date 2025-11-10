class DailyStorageTankAnalyticalToDbEntity {
  final String? id;
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? tankNo;
  final String? oilType;
  final int? kapasitasTanki;
  final int? quantity;
  final int? emptySpace;
  final int? suhu;
  final double? qpFFA; // fgFFA
  final String? qpMoisture;
  final int? qpColorR; //qpColorR
  final int? qpColorY; //qpColorY
  final double? qpIV;
  final double? qpPV;
  final String? qpSlipMeltingPoint;
  final double? qpCloudPoint;
  final double? qpANV;
  final double? betaCarotene;
  final double? qpP;
  final double? qpDobi;
  final double? qpTotox;
  final String? qpOdor;
  final String? remarks;
  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? approvedStatus;
  final String? approvedStatusRemarks;
  final String? updatedBy;
  final DateTime? updatedDate;
  final String? formNo;
  final DateTime? dateIssued;
  final String? revisionNo;
  final DateTime? revisionDate;

  DailyStorageTankAnalyticalToDbEntity({
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
  factory DailyStorageTankAnalyticalToDbEntity.fromMap(Map<String, dynamic> map) {
    return DailyStorageTankAnalyticalToDbEntity(
      id: map['id'] as String?,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate:
          map['transaction_date'] != null
              ? DateTime.parse(map['transaction_date'])
              : null,
      postingDate:
          map['posting_date'] != null
              ? DateTime.parse(map['posting_date'])
              : null,
      tankNo: map['tank_no'] as String?,
      oilType: map['oil_type'] as String?,
      kapasitasTanki: map['kapasitas_tanki'] as int?,
      quantity: map['quantity'] as int?,
      emptySpace: map['empty_space'] as int?,
      suhu: map['suhu'] as int?,
      qpFFA: (map['qp_ffa'] as num?)?.toDouble(),
      qpMoisture: map['qp_moisture'] as String?,
      qpColorR: map['qp_color_r'] as int?,
      qpColorY: map['qp_color_y'] as int?,
      qpIV: (map['qp_iv'] as num?)?.toDouble(),
      qpPV: (map['qp_pv'] as num?)?.toDouble(),
      qpSlipMeltingPoint: map['qp_slip_melting_point'] as String?,
      qpCloudPoint: (map['qp_cloud_point'] as num?)?.toDouble(),
      qpANV: (map['qp_anv'] as num?)?.toDouble(),
      betaCarotene: (map['beta_carotene'] as num?)?.toDouble(),
      qpP: (map['qp_p'] as num?)?.toDouble(),
      qpDobi: (map['qp_dobi'] as num?)?.toDouble(),
      qpTotox: (map['qp_totox'] as num?)?.toDouble(),
      qpOdor: map['qp_odor'] as String?,
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate:
          map['entry_date'] != null ? DateTime.parse(map['entry_date']) : null,
      preparedBy: map['prepared_by'] as String?,
      preparedDate:
          map['prepared_date'] != null
              ? DateTime.parse(map['prepared_date'])
              : null,
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      approvedBy: map['approved_by'] as String?,
      approvedDate:
          map['approved_date'] != null
              ? DateTime.parse(map['approved_date'])
              : null,
      approvedStatus: map['approved_status'] as String?,
      approvedStatusRemarks: map['approved_status_remarks'] as String?,
      updatedBy: map['updated_by'] as String?,
      updatedDate:
          map['updated_date'] != null
              ? DateTime.parse(map['updated_date'])
              : null,
      formNo: map['form_no'] as String?,
      dateIssued:
          map['date_issued'] != null
              ? DateTime.parse(map['date_issued'])
              : null,
      revisionNo: map['revision_no'] as String?,
      revisionDate:
          map['revision_date'] != null
              ? DateTime.parse(map['revision_date'])
              : null,
    );
  }

  // 🔹 TO MAP
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
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
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'approved_by': approvedBy,
      'approved_date': approvedDate?.toIso8601String(),
      'approved_status': approvedStatus,
      'approved_status_remarks': approvedStatusRemarks,
      'updated_by': updatedBy,
      'updated_date': updatedDate?.toIso8601String(),
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
    };
  }

  // 🔹 COPYWITH
  DailyStorageTankAnalyticalToDbEntity copyWith({
    String? id,
    String? company,
    String? plant,
    DateTime? transactionDate,
    DateTime? postingDate,
    String? tankNo,
    String? oilType,
    int? kapasitasTanki,
    int? quantity,
    int? emptySpace,
    int? suhu,
    double? qpFFA,
    String? qpMoisture,
    int? qpColorR,
    int? qpColorY,
    double? qpIV,
    double? qpPV,
    String? qpSlipMeltingPoint,
    double? qpCloudPoint,
    double? qpANV,
    double? betaCarotene,
    double? qpP,
    double? qpDobi,
    double? qpTotox,
    String? qpOdor,
    String? remarks,
    String? flag,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? preparedStatus,
    String? preparedStatusRemarks,
    String? approvedBy,
    DateTime? approvedDate,
    String? approvedStatus,
    String? approvedStatusRemarks,
    String? updatedBy,
    DateTime? updatedDate,
    String? formNo,
    DateTime? dateIssued,
    String? revisionNo,
    DateTime? revisionDate,
  }) {
    return DailyStorageTankAnalyticalToDbEntity(
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
