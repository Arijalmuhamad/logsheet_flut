/// Represents a record from the 't_pretreatment_bleaching_filtration' table.
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
  final String? time;

  /// PreTreatment Fit 001 (CPO) - Tph
  final String? ptFit001;

  /// PreTreatment E001A Inlet (CPO) - C
  final String? ptE001aInlet;

  /// PreTreatment F001/2 Str  - bar
  final String? ptF0012;

  /// PreTreatment H3PO4 - %  ( Dosing )
  final double? ptH3po4;

  /// PreTreatment BE - % ( Dosing )
  final double? ptBe;

  /// Bleaching Vacum - mmHg
  final double? blVacum;

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

  /// nama yang input
  final String? entryBy;

  /// tanggal input
  final DateTime? entryDate;

  /// Nama Shift Leader
  final String? preparedBy;

  /// Tanggal Prepared
  final DateTime? preparedDate;

  /// Nama Dept Head
  final String? checkedBy;

  /// Tanggal Checked
  final DateTime? checkedDate;

  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  const PretreatmentBleachingFiltrationEntity({
    required this.id,
    this.company,
    this.plant,
    this.transactionDate,
    this.postingDate,
    this.refineryMachine,
    this.time,
    this.ptFit001,
    this.ptE001aInlet,
    this.ptF0012,
    this.ptH3po4,
    this.ptBe,
    this.blVacum,
    this.blTInlet,
    this.blTB602,
    this.blSpurge,
    this.pA,
    this.pB,
    this.pC,
    this.fnF601,
    this.fnF602,
    this.fnF603,
    this.fb604a,
    this.fb604b,
    this.fb604c,
    this.fc605a,
    this.fc605b,
    this.clarity,
    this.remarks,
    this.entryBy,
    this.entryDate,
    this.preparedBy,
    this.preparedDate,
    this.checkedBy,
    this.checkedDate,
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

    return PretreatmentBleachingFiltrationEntity(
      id: map['id'] as String,
      company: map['company'] != null ? map['company'] as String : null,
      plant: map['plant'] != null ? map['plant'] as String : null,
      transactionDate: tryParseDateTime(map['transaction_date']),
      postingDate: tryParseDateTime(map['posting_date']),
      refineryMachine:
          map['refinery_machine'] != null
              ? map['refinery_machine'] as String
              : null,
      time: map['time'] != null ? map['time'] as String : null,
      ptFit001: map['pt_fit001'] != null ? map['pt_fit001'] as String : null,
      ptE001aInlet:
          map['pt_e001a_inlet'] != null
              ? map['pt_e001a_inlet'] as String
              : null,
      ptF0012: map['pt_f0012'] != null ? map['pt_f0012'] as String : null,
      ptH3po4: tryParseDouble(map['pt_h3po4']),
      ptBe: tryParseDouble(map['pt_be']),
      blVacum: tryParseDouble(map['bl_vacum']),
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
      clarity: map['clarity'] != null ? map['clarity'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      entryBy: map['entry_by'] != null ? map['entry_by'] as String : null,
      entryDate: tryParseDateTime(map['entry_date']),
      preparedBy:
          map['prepared_by'] != null ? map['prepared_by'] as String : null,
      preparedDate: tryParseDateTime(map['prepared_date']),
      checkedBy: map['checked_by'] != null ? map['checked_by'] as String : null,
      checkedDate: tryParseDateTime(map['checked_date']),
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
    return <String, dynamic>{
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'refinery_machine': refineryMachine,
      'time': time,
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
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
    };
  }
}
