import 'package:intl/intl.dart';

class QualityReportRefineryEntity {
  // Parameter
  final String id;
  final String? company;
  final String? plant;

  final DateTime? transactionDate;
  final DateTime? postingDate; // postingDate
  final String? workCenter;

  final String? oilType;
  final DateTime? time;
  final int? shift;

  final String? rmTankSource; // rmTankSource
  final double rmTemp;
  final double rmFFA; //rmFFA
  final double rmIV; //rmIV
  final double rmDobi; //rmDobi
  final double rmAV; //rmAV
  final double rmMNI; // rmMNI
  final double rmPV; // rmPV

  // BPO / BPKO
  final String? boColor; // boColor
  final String? boBreakTest; //boBreakTest

  // RPO
  final double fgFFA; // fgFFA
  final double fgIV; // fgIV
  final double fgPV; // fgPV
  final double fgMNI; //fgMNI
  final double fgColorR; //fgColorR
  final double fgColorY; //fgColorY
  final String? fgTankTo; //fgTankTo

  // PFAD
  final double bpFFA; //bpFFA
  final double bpMNI; //bgMNI
  final double wSBEQC; //wSBEQC

  // Remark
  final String? remarks;
  final String? entryBy;
  final DateTime? entryDate;

  final String? preparedByShift1;
  final DateTime? preparedDateShift1;
  final String? preparedStatusShift1;

  final String? preparedByShift2;
  final DateTime? preparedDateShift2;
  final String? preparedStatusShift2;

  final String? preparedByShift3;
  final DateTime? preparedDateShift3;
  final String? preparedStatusShift3;
  final String? preparedStatusRemarksShift;

  final String? checkedBy;
  final DateTime? checkedDate;
  String? checkedStatus;
  final String? checkedStatusRemarks;

  final String? updatedBy;
  final DateTime? updatedDate;

  QualityReportRefineryEntity({
    required this.oilType,
    required this.transactionDate,
    required this.id,
    required this.postingDate,
    required this.time,
    required this.shift,

    required this.rmTankSource,

    required this.rmTemp,
    required this.rmFFA,
    required this.rmIV,
    required this.rmPV,
    required this.rmAV,
    required this.rmDobi,

    required this.rmMNI,
    required this.boColor,

    required this.boBreakTest,

    required this.fgFFA,
    required this.fgColorR,
    required this.fgColorY,
    required this.fgIV,
    required this.fgPV,
    required this.fgTankTo,
    required this.fgMNI,

    required this.bpFFA,
    required this.bpMNI,
    required this.wSBEQC,

    required this.remarks,
    required this.checkedBy,
    required this.checkedDate,
    required this.preparedByShift1,
    required this.preparedDateShift1,

    required this.company,
    required this.plant,
    required this.entryBy,
    required this.entryDate,

    required this.preparedStatusShift1,
    required this.preparedByShift2,
    required this.preparedDateShift2,
    required this.preparedStatusShift2,
    required this.preparedByShift3,
    required this.preparedDateShift3,
    required this.preparedStatusShift3,
    required this.preparedStatusRemarksShift,
    required this.checkedStatus,
    required this.checkedStatusRemarks,

    required this.workCenter,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory QualityReportRefineryEntity.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic value) {
      if (value == null) {
        return 0.0;
      } else if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
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
      if (value is String) return DateFormat('HH:mm:ss').parse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    return QualityReportRefineryEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'],
      oilType: map['oil_type'] as String?,
      time: parseTime(map['time']),
      shift: parseInt(map['shift']),
      rmTankSource: map['rm_tank_source'] as String?,
      rmTemp: parseDouble(map['rm_temp']),
      rmFFA: parseDouble(map['rm_ffa']),
      rmIV: parseDouble(map['rm_iv']),
      rmDobi: parseDouble(map['rm_dobi']),
      rmAV: parseDouble(map['rm_av']),
      rmMNI: parseDouble(map['rm_m&i']),
      rmPV: parseDouble(map['rm_pv']),
      boColor: map['bo_color'] as String?,
      boBreakTest: map['bo_break_test'] as String?,
      fgFFA: parseDouble(map['fg_ffa']),
      fgIV: parseDouble(map['fg_iv']),
      fgPV: parseDouble(map['fg_pv']),
      fgMNI: parseDouble(map['fg_m&i']),
      fgColorR: parseDouble(map['fg_color_r']),
      fgColorY: parseDouble(map['fg_color_y']),
      fgTankTo: map['fg_tank_to'] as String?,
      bpFFA: parseDouble(map['bp_ffa']),
      bpMNI: parseDouble(map['bp_m&i']),
      wSBEQC: parseDouble(map['w_sbe_qc']),
      remarks: map['remarks'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedByShift1: map['prepared_by_shift1'] as String?,
      preparedDateShift1: parseDateTime(map['prepared_date_shift1']),
      preparedStatusShift1: map['prepared_status_shift1'],
      preparedByShift2: map['prepared_by_shift2'],
      preparedDateShift2: parseDateTime(map['prepared_date_shift2']),
      preparedStatusShift2: map['prepared_status_shift2'],
      preparedByShift3: map['prepared_by_shift3'],
      preparedDateShift3: parseDateTime(map['prepared_date_shift3']),
      preparedStatusShift3: map['prepared_status_shift3'],
      preparedStatusRemarksShift: map['status_remarks_shift'],
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'],
      checkedStatusRemarks: map['checked_status_remarks'],
      updatedBy: map['updated_by'] as String?,
      updatedDate: parseDateTime(map['updated_date']),
    );
  }

  Map<String, dynamic> toMap() {
    String? formatDate(DateTime? date) => date?.toIso8601String();
    // Helper for formatting Time (DateTime) to HH:mm:ss string, or null if the time is null
    String? formatTime(DateTime? time) =>
        time != null ? DateFormat('HH:mm:ss').format(time) : null;

    return {
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': formatDate(transactionDate),
      'posting_date': formatDate(postingDate),
      'work_center': workCenter,
      'oil_type': oilType,
      'time': formatTime(time), // Format time as HH:mm:ss string
      'shift': shift,
      'rm_tank_source': rmTankSource,
      'rm_temp': rmTemp,
      'rm_ffa': rmFFA,
      'rm_iv': rmIV,
      'rm_dobi': rmDobi,
      'rm_av': rmAV,
      'rm_mni': rmMNI,
      'rm_pv': rmPV,
      'bo_color': boColor,
      'bo_break_test': boBreakTest,
      'fg_ffa': fgFFA,
      'fg_iv': fgIV,
      'fg_pv': fgPV,
      'fg_mni': fgMNI,
      'fg_color_r': fgColorR,
      'fg_color_y': fgColorY,
      'fg_tank_to': fgTankTo,
      'bp_ffa': bpFFA,
      'bp_mni': bpMNI,
      'w_sbe_qc': wSBEQC,
      'remarks': remarks,
      'entry_by': entryBy,
      'entry_date': formatDate(entryDate),
      'prepared_by_shift1': preparedByShift1,
      'prepared_date_shift1': formatDate(preparedDateShift1),
      'prepared_status_shift1': preparedStatusShift1,
      'prepared_by_shift2': preparedByShift2,
      'prepared_date_shift2': formatDate(preparedDateShift2),
      'prepared_status_shift2': preparedStatusShift2,
      'prepared_by_shift3': preparedByShift3,
      'prepared_date_shift3': formatDate(preparedDateShift3),
      'prepared_status_shift3': preparedStatusShift3,
      'prepared_status_remarks_shift': preparedStatusRemarksShift,
      'checked_by': checkedBy,
      'checked_date': formatDate(checkedDate),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
    };
  }
}
