import 'package:intl/intl.dart';

class PretreatmentBleachingFiltrationEntity {
  /// id number
  final String id;

  /// company
  final String? company;

  /// plant
  final String? plant;

  /// tanggal transaksi
  final DateTime? transactionDate;

  /// Jam 08:00 WIB Hari ini sd Jam 07:00, Esok Hari
  final DateTime? postingDate;

  /// mesin refinery
  final String? refineryMachine;

  /// time shift
  final DateTime? time;

  // Shift
  final int? shift;

  /// PreTreatment Oil Type
  final String? oilType;

  /// PreTreatment Oil Type ID
  final String? oilTypeId;

  /// PreTreatment Fit 001 (CPO) - Tph
  final double? ptFit001;

  /// PreTreatment E001A Inlet (CPO) - C
  final double? ptE001aInlet;

  /// PreTreatment F001/2 Str  - bar
  final double? ptF0012;

  /// PreTreatment H3PO4 - %  ( Dosing )
  final double? ptH3po4;

  /// PreTreatment BE - % ( Dosing )
  final double? ptBe;

  /// Bleaching Vacum - mmHg
  final String? blVacum;

  /// Bleaching T-Inlet - C
  final double? blTInlet;

  /// Bleaching T B602 - C
  final double? blTB602;

  /// Bleaching Spurge - Bar
  final double? blSpurge;

  /// Pump P602-A - Bar
  final double? pA;

  /// Pump P602-B - Bar
  final double? pB;

  /// Pump P602-C - Bar
  final double? pC;

  /// Niagara Filter - 601 - Bar
  final double? fnF601;

  /// Niagara Filter - 602 - Bar
  final double? fnF602;

  /// Niagara Filter - 603 - Bar
  final double? fnF603;

  /// Bag Filter - 604A - Bar
  final double? fb604a;

  /// Bag Filter - 604B - Bar
  final double? fb604b;

  /// Bag Filter - 604C - Bar
  final double? fb604c;

  /// Catridge Filter - 605 - Bar
  final double? fc605a;

  /// Catridge Filter - 605 - Bar
  final double? fc605b;

  /// Clarity
  final String? clarity;

  /// Remarks
  final String? remarks;

  // Flag
  final String? flag;

  /// nama yang input
  final String? entryBy;

  /// tanggal input
  final DateTime? entryDate;

  /// Nama Shift Leader
  final String? preparedBy;

  /// Tanggal Prepared
  final DateTime? preparedDate;

  /// Status Prepared
  final String? preparedStatus;

  /// Status Remark Prepared
  final String? preparedStatusRemarks;

  /// Nama Dept Head
  final String? checkedBy;

  /// Tanggal Checked
  final DateTime? checkedDate;

  /// Status Checked
  String? checkedStatus;

  /// Status Remark checked
  final String? checkedStatusRemarks;

  final String? updatedBy;
  final DateTime? updatedDate;

  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  PretreatmentBleachingFiltrationEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.postingDate,
    required this.refineryMachine,
    required this.time,
    required this.shift,

    this.oilType,
    required this.oilTypeId,

    required this.ptFit001,
    required this.ptE001aInlet,
    required this.ptF0012,
    required this.ptH3po4,
    required this.ptBe,

    required this.blVacum,
    required this.blTInlet,
    required this.blTB602,
    required this.blSpurge,

    required this.pA,
    required this.pB,
    required this.pC,

    required this.fnF601,
    required this.fnF602,
    required this.fnF603,

    required this.fb604a,
    required this.fb604b,
    required this.fb604c,

    required this.fc605a,
    required this.fc605b,

    required this.clarity,
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
    this.checkedStatus,
    required this.checkedStatusRemarks,

    required this.updatedBy,
    required this.updatedDate,

    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  /// Creates a [PretreatmentBleachingFiltrationEntity] instance from a map.
  ///
  /// This factory is useful for deserializing data from a database or JSON.
  factory PretreatmentBleachingFiltrationEntity.fromMap(
    Map<String, dynamic> map,
  ) {
    /// Helper function to safely parse numeric values (int, double, String) to double.
    double? tryParseDouble(dynamic value) {
      if (value == null) return null;
      return double.tryParse(value.toString());
    }

    /// Helper function to safely parse string values to DateTime.
    DateTime? tryParseDateTime(dynamic value) {
      if (value == null) return null;
      // Database might return a Timestamp object or an ISO 8601 string.
      return DateTime.tryParse(value.toString());
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    DateTime? parseTime(dynamic value) {
      if (value is String) return DateFormat('HH:mm:ss').parse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    return PretreatmentBleachingFiltrationEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: tryParseDateTime(map['transaction_date']),
      postingDate: tryParseDateTime(map['posting_date']),
      refineryMachine: map['refinery_machine'] as String?,
      time: parseTime(map['time']),
      shift: parseInt(map['shift']),
      oilType: map['oil_type'] as String?,
      oilTypeId: map['oil_type_id'] as String?,
      ptFit001: tryParseDouble(map['pt_fit001']),
      ptE001aInlet: tryParseDouble(map['pt_e001a_inlet']),
      ptF0012: tryParseDouble(map['pt_f0012']),
      ptH3po4: tryParseDouble(map['pt_h3po4']),
      ptBe: tryParseDouble(map['pt_be']),

      blVacum: map['bl_vacum'] as String?,
      blTInlet: tryParseDouble(map['bl_t_inlet']),
      blTB602: tryParseDouble(map['bl_t_b602']),
      blSpurge: tryParseDouble(map['bl_spurge']),

      pA: tryParseDouble(map['p_a']),
      pB: tryParseDouble(map['p_b']),
      pC: tryParseDouble(map['p_c']),

      fnF601: tryParseDouble(map['fn_f601']),
      fnF602: tryParseDouble(map['fn_f602']),
      fnF603: tryParseDouble(map['fn_f603']),

      fb604a: tryParseDouble(map['fb_604a']),
      fb604b: tryParseDouble(map['fb_604b']),
      fb604c: tryParseDouble(map['fb_604c']),

      fc605a: tryParseDouble(map['fc_605a']),
      fc605b: tryParseDouble(map['fc_605b']),

      clarity: map['clarity'] as String?,
      remarks: map['remarks'] as String?,

      flag: map['flag'] as String?,

      entryBy: map['entry_by'] as String?,
      entryDate: tryParseDateTime(map['entry_date']),

      updatedBy: map['updated_by'] as String?,
      updatedDate: tryParseDateTime(map['updated_date']),

      preparedBy: map['prepared_by'] as String?,
      preparedDate: tryParseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,

      checkedBy: map['checked_by'] as String?,
      checkedDate: tryParseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,

      formNo: map['form_no'] as String?,
      dateIssued: tryParseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: tryParseDateTime(map['revision_date']),
    );
  }

  /// Converts the [PretreatmentBleachingFiltrationEntity] instance to a map.
  ///
  /// This is useful for serializing the object to be stored in a database or sent as JSON.
  Map<String, dynamic> toMap() {
    String? formatTime(DateTime? time) =>
        time != null ? DateFormat('HH:mm:ss').format(time) : null;
    return <String, dynamic>{
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'refinery_machine': refineryMachine,
      'time': formatTime(time),
      'shift': shift,
      'oil_type': oilTypeId,
      'pt_fit001': ptFit001,
      'pt_e001a_inlet': ptE001aInlet,
      'pt_f0012': ptF0012,
      'pt_h3po4': ptH3po4,
      'pt_be': ptBe,

      'bl_vacum': blVacum,
      'bl_t_inlet': blTInlet,
      'bl_t_b602': blTB602,
      'bl_spurge': blSpurge,

      'p_a': pA,
      'p_b': pB,
      'p_c': pC,

      'fn_f601': fnF601,
      'fn_f602': fnF602,
      'fn_f603': fnF603,

      'fb_604a': fb604a,
      'fb_604b': fb604b,
      'fb_604c': fb604c,

      'fc_605a': fc605a,
      'fc_605b': fc605b,

      'clarity': clarity,
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
      'updated_date': updatedDate,

      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
    };
  }
}
