import 'package:intl/intl.dart';

class DeodorizingFiltrationEntity {
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

  /// Oil Type
  final String? oilType;

  // Shift
  final int? shift;

  /// FIT 701 - tph
  final double? fit701;

  /// D701 - Vacum - cmHg
  final double? d701Vacum;

  /// D701 - T D701 - c
  final double? d701Td701;

  /// E702 - c
  final double? e702;

  /// Thermopac - Inlet
  final double? thermopacInlet;

  /// Thermopac - Outlet
  final double? thermopacOutlet;

  /// D702 - Inlet - c
  final double? d702Inlet;

  /// D702 - Outlet - c
  final double? d702Outlet;

  /// D702 - Vacum - mbar
  final double? d702Vacum;

  /// Sparging A - bar
  final String? spargingA;

  /// Sparging B - bar
  final String? spargingB;

  /// E 730 Inlet - c
  final String? e730Inlet;

  /// Steam Inlet - bar
  final String? steamInlet;

  /// Pish 706 - bar
  final String? pish706;

  /// TIWH 706 - c
  final String? tiwh706;

  /// F702 A - bar
  final double? f702A;

  /// F702 B - bar
  final double? f702B;

  /// F702 C - bar
  final double? f702C;

  /// Oil Type Finished Goods
  final String? oilTypeFg;

  /// FIT 704 - tph
  final double? fit704;

  /// E 704 - c
  final double? e704;

  /// Oil Type By Product
  final String? oilTypeBp;

  /// FIT 705 - bar
  final double? fit705;

  /// E705 - c
  final double? e705;

  /// Clarity
  final String? clarity;

  /// Remarks
  final String? remarks;

  /// Flag
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

  /// Status Prepared Remarks
  final String? preparedStatusRemarks;

  /// Nama Dept Head
  final String? checkedBy;

  /// Tanggal Checked
  final DateTime? checkedDate;

  /// Status Checked
  String? checkedStatus;

  /// Status Checked Remarks;
  final String? checkedStatusRemarks;

  /// Tanggal update
  final DateTime? updatedDate;

  /// Nama yang Update
  final String? updatedBy;

  /// Form No Cth : F/RFA-002
  final String? formNo;

  /// Date Issued Form No
  final DateTime? dateIssued;

  /// Revision Form No
  final int? revisionNo;

  /// Revision Date Form No
  final DateTime? revisionDate;

  DeodorizingFiltrationEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.postingDate,
    required this.refineryMachine,
    required this.time,
    required this.oilType,
    required this.shift,
    required this.fit701,
    required this.d701Vacum,
    required this.d701Td701,
    required this.e702,
    required this.thermopacInlet,
    required this.thermopacOutlet,
    required this.d702Inlet,
    required this.d702Outlet,
    required this.d702Vacum,
    required this.spargingA,
    required this.spargingB,
    required this.e730Inlet,
    required this.steamInlet,
    required this.pish706,
    required this.tiwh706,
    required this.f702A,
    required this.f702B,
    required this.f702C,
    required this.oilTypeFg,
    required this.fit704,
    required this.e704,
    required this.oilTypeBp,
    required this.fit705,
    required this.e705,
    required this.clarity,
    required this.remarks,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.checkedBy,
    required this.checkedDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
    required this.flag,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.updatedDate,
    required this.updatedBy,
  });

  /// Creates a [DeodorizingFiltrationEntity] instance from a map.
  factory DeodorizingFiltrationEntity.fromMap(Map<String, dynamic> map) {
    double? tryParseDouble(dynamic value) {
      if (value == null) return null;
      return double.tryParse(value.toString());
    }

    DateTime? tryParseDateTime(dynamic value) {
      if (value == null) return null;
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

    /// Determines the shift number based on the provided date and time.
    int getShift(DateTime dateTime) {
      int day = dateTime.weekday; // Monday = 1, Sunday = 7
      int hour = dateTime.hour; // 0 - 23

      // Check for Friday-Sunday rules
      if (day >= DateTime.friday) {
        if (hour >= 8 && hour < 20) {
          // Shift 4 runs from 08:00 to 19:59
          return 4;
        } else {
          // Shift 5 covers the remaining time (20:00 to 07:59)
          return 5;
        }
      }
      // Default to Monday-Thursday rules
      else {
        if (hour >= 8 && hour < 16) {
          // Shift 1 runs from 08:00 to 15:59
          return 1;
        } else if (hour >= 16 && hour < 24) {
          // Shift 2 runs from 16:00 to 23:59
          return 2;
        } else {
          // Shift 3 covers the remaining time (00:00 to 07:59)
          return 3;
        }
      }
    }

    final postingDate = tryParseDateTime(map['posting_date']);
    final time = parseTime(map['time']);
    DateTime? combinedDateTime;
    if (postingDate != null && time != null) {
      combinedDateTime = DateTime(
        postingDate.year,
        postingDate.month,
        postingDate.day,
        time.hour,
        time.minute,
        time.second,
      );
    }

    return DeodorizingFiltrationEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: tryParseDateTime(map['transaction_date']),
      postingDate: tryParseDateTime(map['posting_date']),
      refineryMachine: map['refinery_machine'] as String?,
      time: parseTime(map['time']),
      oilType: map['oil_type'] as String?,
      shift: parseInt(map['shift']),
      fit701: tryParseDouble(map['fit701_bpo']),
      d701Vacum: tryParseDouble(map['d701_vacum']),
      d701Td701: tryParseDouble(map['d701_td701']),
      e702: tryParseDouble(map['e702']),
      thermopacInlet: tryParseDouble(map['thermopac_inlet']),
      thermopacOutlet: tryParseDouble(map['thermopac_outlet']),
      d702Inlet: tryParseDouble(map['d702_inlet']),
      d702Outlet: tryParseDouble(map['d702_outlet']),
      d702Vacum: tryParseDouble(map['d702_vacum']),
      spargingA: map['sparging_a'] as String?,
      spargingB: map['sparging_b'] as String?,
      e730Inlet: map['e730_inlet'] as String?,
      steamInlet: map['steam_inlet'] as String?,
      pish706: map['pish_706'] as String?,
      tiwh706: map['tiwh_706'] as String?,
      f702A: tryParseDouble(map['f702_a']),
      f702B: tryParseDouble(map['f702_b']),
      f702C: tryParseDouble(map['f702_c']),
      oilTypeFg: map['oil_type_fg'] as String?,
      fit704: tryParseDouble(map['fit704_rpo']),
      e704: tryParseDouble(map['e704']),
      oilTypeBp: map['oil_type_bp'] as String?,
      fit705: tryParseDouble(map['fit_705_pfad']),
      e705: tryParseDouble(map['e705']),
      clarity: map['clarity'] as String?,
      remarks: map['remarks'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: tryParseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: tryParseDateTime(map['prepared_date']),
      checkedBy: map['checked_by'] as String?,
      checkedDate: tryParseDateTime(map['checked_date']),
      formNo: map['form_no'] as String?,
      dateIssued: tryParseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: tryParseDateTime(map['revision_date']),
      flag: map['flag'] as String?,
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      updatedDate: tryParseDateTime(map['updated_date']),
      updatedBy: map['updated_by'] as String?,
    );
  }

  /// Converts the [DeodorizingFiltrationEntity] instance to a map.
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
      'oil_type': oilType,
      'shift': shift,
      'fit701_bpo': fit701,
      'd701_vacum': d701Vacum,
      'd701_td701': d701Td701,
      'e702': e702,
      'thermopac_inlet': thermopacInlet,
      'thermopac_outlet': thermopacOutlet,
      'd702_inlet': d702Inlet,
      'd702_outlet': d702Outlet,
      'd702_vacum': d702Vacum,
      'sparging_a': spargingA,
      'sparging_b': spargingB,
      'e730_inlet': e730Inlet,
      'steam_inlet': steamInlet,
      'pish_706': pish706,
      'tiwh_706': tiwh706,
      'f702_a': f702A,
      'f702_b': f702B,
      'f702_c': f702C,
      'oil_type_fg': oilTypeFg,
      'fit704_rpo': fit704,
      'e704': e704,
      'oil_type_bp': oilTypeBp,
      'fit_705_pfad': fit705,
      'e705': e705,
      'clarity': clarity,
      'remarks': remarks,
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
      'flag': flag,
    };
  }
}
