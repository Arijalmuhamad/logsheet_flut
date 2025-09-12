import 'package:intl/intl.dart';

class QualityReportProductionEntity {
  // Parameter
  String id;
  String? idFk;
  final String? company;
  final String? plant;

  final DateTime? transactionDate;
  final DateTime? postingDate; // postingDate
  final String? workCenter;

  final String? oilType;
  final DateTime? time;
  final int? shift;

  final double? rmFlowRate;
  final String? rmTankSource; // rmTankSource
  final double? rmTemp;
  final double? rmFFA; //rmFFA
  final double? rmIV; //rmIV
  final double? rmDobi; //rmDobi
  final double? rmAV; //rmAV
  final double? rmMNI; // rmMNI
  final double? rmPV; // rmPV
  final double? rmToTox;
  final double? rmColorR; // boColorR
  final double? rmColorY; // boColorY
  final double? rmColorB; // boColorY

  // BPO / BPKO
  final double? boColorR; // boColorR
  final double? boColorY; // boColorY
  final double? boColorB; // boColorY
  final String? boBreakTest; //boBreakTest

  // RPO
  final double? fgFFA; // fgFFA
  final double? fgIV; // fgIV
  final double? fgPV; // fgPV
  final double? fgMoisture; //fgMNI
  final double? fgImpurities; //fgMNI
  final double? fgColorR; //fgColorR
  final double? fgColorY; //fgColorY
  final double? fgColorB; //fgColorB
  final String? fgTankTo; //fgTankTo
  final String? fgTankToOthersRemarks;

  // PFAD
  final double? bpFFA; //bpFFA
  final double? bpMNI; //bgMNI
  final String? bpToTank;

  final double? wSBEQC; //wSBEQC
  final double? wasteMNI;

  // Remark
  String? remarks;
  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;

  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;

  final String? checkedBy;
  final DateTime? checkedDate;
  String? checkedStatus;
  final String? checkedStatusRemarks;

  final String? updatedBy;
  final DateTime? updatedDate;

  String? formNo;
  DateTime? dateIssued;
  int? revisionNo;
  DateTime? revisionDate;

  QualityReportProductionEntity({
    required this.oilType,
    required this.transactionDate,
    required this.id,
    this.idFk,
    required this.postingDate,
    required this.time,
    required this.shift,

    required this.rmFlowRate,
    required this.rmTankSource,
    required this.rmTemp,
    required this.rmFFA,
    required this.rmIV,
    required this.rmPV,
    required this.rmAV,
    required this.rmDobi,
    required this.rmMNI,
    required this.rmToTox,
    required this.rmColorR,
    required this.rmColorY,
    required this.rmColorB,

    required this.boColorR,
    required this.boColorY,
    required this.boColorB,
    required this.boBreakTest,

    required this.fgFFA,
    required this.fgColorR,
    required this.fgColorY,
    required this.fgColorB,
    required this.fgIV,
    required this.fgMoisture,
    required this.fgImpurities,
    required this.fgPV,
    required this.fgTankTo,
    this.fgTankToOthersRemarks,

    required this.bpFFA,
    required this.bpMNI,
    required this.bpToTank,
    required this.wSBEQC,
    required this.wasteMNI,

    required this.remarks,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,

    required this.company,
    required this.plant,
    required this.flag,
    required this.entryBy,
    required this.entryDate,

    required this.checkedStatus,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatusRemarks,

    required this.workCenter,
    required this.updatedBy,
    required this.updatedDate,

    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  factory QualityReportProductionEntity.fromMap(Map<String, dynamic> map) {
    double? parseDouble(dynamic value) {
      if (value == null) {
        return null;
      } else if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    DateTime? parseDateTime(dynamic value) {
      if (value is String) return DateTime.tryParse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    DateTime? parseTime(dynamic value) {
      if (value is String) return DateFormat('HH:mm:ss').tryParse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    return QualityReportProductionEntity(
      id: map['id'] as String,
      idFk: map['id_fk'] as String?,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'],
      oilType: map['oil_type'] as String?,
      time: parseTime(map['time']),
      shift: parseInt(map['shift']),
      rmFlowRate: parseDouble(map['rm_flowrate']),
      rmTankSource: map['rm_tank_source'] as String?,
      rmTemp: parseDouble(map['rm_temp']),
      rmFFA: parseDouble(map['rm_ffa']),
      rmIV: parseDouble(map['rm_iv']),
      rmDobi: parseDouble(map['rm_dobi']),
      rmAV: parseDouble(map['rm_av']),
      rmMNI: parseDouble(map['rm_m&i']),
      rmPV: parseDouble(map['rm_pv']),
      rmToTox: parseDouble(map['rm_totox']),
      rmColorR: parseDouble(map['rm_color_r']),
      rmColorY: parseDouble(map['rm_color_y']),
      rmColorB: parseDouble(map['rm_color_b']),
      boColorR: parseDouble(map['bo_color_r']),
      boColorY: parseDouble(map['bo_color_y']),
      boColorB: parseDouble(map['bo_color_b']),
      boBreakTest: map['bo_break_test'] as String?,
      fgFFA: parseDouble(map['fg_ffa']),
      fgIV: parseDouble(map['fg_iv']),
      fgPV: parseDouble(map['fg_pv']),
      fgMoisture: parseDouble(map['fg_moisture']),
      fgImpurities: parseDouble(map['fg_impurities']),
      fgColorR: parseDouble(map['fg_color_r']),
      fgColorY: parseDouble(map['fg_color_y']),
      fgColorB: parseDouble(map['fg_color_b']),
      fgTankTo: map['fg_tank_to'] as String?,
      fgTankToOthersRemarks: map['fg_tank_to_others_remarks'] as String?,
      bpFFA: parseDouble(map['bp_ffa']),
      bpMNI: parseDouble(map['bp_m&i']),
      bpToTank: map['bp_to_tank'] as String?,
      wSBEQC: parseDouble(map['w_sbe_qc']),
      wasteMNI: parseDouble(map['w_sbe_m&i']),
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
      checkedStatusRemarks: map['checked_status_remarks'],
      updatedBy: map['updated_by'] as String?,
      updatedDate: parseDateTime(map['updated_date']),
      formNo: map['form_no'] as String?,
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: parseDateTime(map['revision_date']),
    );
  }

  Map<String, dynamic> toMap() {
    String? formatDate(DateTime? date) => date?.toIso8601String();
    // Helper for formatting Time (DateTime) to HH:mm:ss string, or null if the time is null
    String? formatTime(DateTime? time) =>
        time != null ? DateFormat('HH:mm:ss').format(time) : null;

    return {
      'id': id,
      'id_fk': idFk,
      'company': company,
      'plant': plant,
      'transaction_date': formatDate(transactionDate),
      'posting_date': formatDate(postingDate),
      'work_center': workCenter,
      'oil_type': oilType,
      'time': formatTime(time), // Format time as HH:mm:ss string
      'shift': shift,
      'rm_flowrate': rmFlowRate,
      'rm_tank_source': rmTankSource,
      'rm_temp': rmTemp,
      'rm_ffa': rmFFA,
      'rm_iv': rmIV,
      'rm_dobi': rmDobi,
      'rm_av': rmAV,
      'rm_mni': rmMNI,
      'rm_pv': rmPV,
      'rm_totox': rmToTox,
      'rm_color_r': rmColorR,
      'rm_color_y': rmColorY,
      'rm_color_b': rmColorB,
      'bo_color_r': boColorR,
      'bo_color_y': boColorY,
      'bo_color_b': boColorB,
      'bo_break_test': boBreakTest,
      'fg_ffa': fgFFA,
      'fg_iv': fgIV,
      'fg_pv': fgPV,
      'fg_moisture': fgMoisture,
      'fg_impurities': fgImpurities,
      'fg_color_r': fgColorR,
      'fg_color_y': fgColorY,
      'fg_color_b': fgColorB,
      'fg_tank_to': fgTankTo,
      'fg_tank_to_others_remarks': fgTankToOthersRemarks,
      'bp_ffa': bpFFA,
      'bp_mni': bpMNI,
      'bp_to_tank': bpToTank,
      'w_sbe_qc': wSBEQC,
      'w_sbe_mni': wasteMNI,
      'remarks': remarks,
      'flag': flag,
      'entry_by': entryBy,
      'entry_date': formatDate(entryDate),
      'prepared_by': preparedBy,
      'prepared_date': formatDate(preparedDate),
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'checked_by': checkedBy,
      'checked_date': formatDate(checkedDate),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
    };
  }
}
