import 'package:intl/intl.dart';

class DailyProductionFractionationEntity {
  // General Information
  final String id;
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? workCenter;
  final String? shift;
  final String? cpoTank;

  final String? oilTypeRm;
  final String? oilTypeRmAwalJam;
  final int? oilTypeRmAwalFlowmeter;
  final String? oilTypeRmAkhirJam;
  final int? oilTypeRmAkhirFlowmeter;
  final int? oilTypeRmTotal;
  final String? oilTypeFg;
  final String? oilTypeFgAwalJam;
  final int? oilTypeFgAwalFlowmeter;
  final String? oilTypeFgAkhirJam;
  final int? oilTypeFgAkhirFlowmeter;
  final int? oilTypeFgTotal;
  final String? oilTypeFgToTank;

  final String? bpAwalJam;
  final int? bpAwalFlowmeter;
  final String? bpAkhirJam;
  final int? bpAkhirFlowmeter;
  final int? bpTotal;
  final int? bpToTank;

  final String? beRefTank;
  final String? beRefQty;
  final String? beTotalBag;
  final String? beTotalJenis;
  final int? beLotBatchNumber;
  final double? beYieldPercent;

  final String? paRefTank;
  final String? paRefQty;
  final String? paTotal;
  final int? paLotBatchNumber;
  final double? paYieldPercent;

  final String? uuItem;
  final String? uuBudgetRefTank;
  final String? uuBudgetQty;
  final int? uuTotalCPO;
  final int? uuTotalSteam;
  final String? uuSteamCPO;
  final double? uuYieldPercent;

  final String? remarks;
  final String? flag;

  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;

  final String? verifiedBy;
  final DateTime? verifiedDate;
  final String? verifiedStatus;
  final String? verifiedStatusRemarks;

  final String? checkedBy;
  final DateTime? checkedDate;
  final String? checkedStatus;
  final String? checkedStatusRemarks;

  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  DailyProductionFractionationEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.postingDate,
    required this.workCenter,
    required this.shift,
    required this.cpoTank,
    required this.oilTypeRm,
    required this.oilTypeRmAwalJam,
    required this.oilTypeRmAwalFlowmeter,
    required this.oilTypeRmAkhirJam,
    required this.oilTypeRmAkhirFlowmeter,
    required this.oilTypeRmTotal,
    required this.oilTypeFg,
    required this.oilTypeFgAwalJam,
    required this.oilTypeFgAwalFlowmeter,
    required this.oilTypeFgAkhirJam,
    required this.oilTypeFgAkhirFlowmeter,
    required this.oilTypeFgTotal,
    required this.oilTypeFgToTank,
    required this.bpAwalJam,
    required this.bpAwalFlowmeter,
    required this.bpAkhirJam,
    required this.bpAkhirFlowmeter,
    required this.bpTotal,
    required this.bpToTank,
    required this.beRefTank,
    required this.beRefQty,
    required this.beTotalBag,
    required this.beTotalJenis,
    required this.beLotBatchNumber,
    required this.beYieldPercent,
    required this.paRefTank,
    required this.paRefQty,
    required this.paTotal,
    required this.paLotBatchNumber,
    required this.paYieldPercent,
    required this.uuItem,
    required this.uuBudgetRefTank,
    required this.uuBudgetQty,
    required this.uuTotalCPO,
    required this.uuTotalSteam,
    required this.uuSteamCPO,
    required this.uuYieldPercent,
    required this.remarks,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.verifiedBy,
    required this.verifiedDate,
    required this.verifiedStatus,
    required this.verifiedStatusRemarks,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  factory DailyProductionFractionationEntity.fromMap(Map<String, dynamic> map) {
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
      if (value is String) return DateFormat('HH:mm').tryParse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

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

    return DailyProductionFractionationEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'] as String?,
      shift: map['shift'] as String?,
      cpoTank: map['cpo_tank'] as String?,
      oilTypeRm: map['oil_type_rm'] as String?,
      oilTypeRmAwalJam: map['oil_type_rm_awal_jam'] as String?,
      oilTypeRmAwalFlowmeter: parseInt(map['oil_type_rm_awal_flowmeter']),
      oilTypeRmAkhirJam: map['oil_type_rm_akhir_jam'] as String?,
      oilTypeRmAkhirFlowmeter: parseInt(map['oil_type_rm_akhir_flowmeter']),
      oilTypeRmTotal: parseInt(map['oil_type_rm_total']),
      oilTypeFg: map['oil_type_fg'] as String?,
      oilTypeFgAwalJam: map['oil_type_fg_awal_jam'] as String?,
      oilTypeFgAwalFlowmeter: parseInt(map['oil_type_fg_awal_flowmeter']),
      oilTypeFgAkhirJam: map['oil_type_fg_akhir_jam'] as String?,
      oilTypeFgAkhirFlowmeter: parseInt(map['oil_type_fg_akhir_flowmeter']),
      oilTypeFgTotal: parseInt(map['oil_type_fg_total']),
      oilTypeFgToTank: map['oil_type_fg_to_tank'] as String?,
      bpAwalJam: map['bp_awal_jam'] as String?,
      bpAwalFlowmeter: parseInt(map['bp_awal_flowmeter']),
      bpAkhirJam: map['bp_akhir_jam'] as String?,
      bpAkhirFlowmeter: parseInt(map['bp_akhir_flowmeter']),
      bpTotal: parseInt(map['bp_total']),
      bpToTank: parseInt(map['bp_to_tank']),
      beRefTank: map['be_ref_tank'] as String?,
      beRefQty: map['be_ref_qty'] as String?,
      beTotalBag: map['be_total_bag'] as String?,
      beTotalJenis: map['be_total_jenis'] as String?,
      beLotBatchNumber: parseInt(map['be_lot_batch_number']),
      beYieldPercent: parseDouble(map['be_yield_percent']),
      paRefTank: map['pa_ref_tank'] as String?,
      paRefQty: map['pa_ref_qty'] as String?,
      paTotal: map['pa_total'] as String?,
      paLotBatchNumber: parseInt(map['pa_lot_batch_number']),
      paYieldPercent: parseDouble(map['pa_yield_percent']),
      uuItem: map['uu_item'] as String?,
      uuBudgetRefTank: map['uu_budget_ref_tank'] as String?,
      uuBudgetQty: map['uu_budget_qty'] as String?,
      uuTotalCPO: parseInt(map['uu_total_cpo']),
      uuTotalSteam: parseInt(map['uu_total_steam']),
      uuSteamCPO: map['uu_steam_cpo'] as String?,
      uuYieldPercent: parseDouble(map['uu_yield_percent']),
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: parseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      verifiedBy: map['verified_by'] as String?,
      verifiedDate: parseDateTime(map['verified_date']),
      verifiedStatus: map['verified_status'] as String?,
      verifiedStatusRemarks: map['verified_status_remarks'] as String?,
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
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
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'work_center': workCenter,
      'shift': shift,
      'cpo_tank': cpoTank,
      'oil_type_rm': oilTypeRm,
      'oil_type_rm_awal_jam': oilTypeRmAwalJam,
      'oil_type_rm_awal_flowmeter': oilTypeRmAwalFlowmeter,
      'oil_type_rm_akhir_jam': oilTypeRmAkhirJam,
      'oil_type_rm_akhir_flowmeter': oilTypeRmAkhirFlowmeter,
      'oil_type_rm_total': oilTypeRmTotal,
      'oil_type_fg': oilTypeFg,
      'oil_type_fg_awal_jam': oilTypeFgAwalJam,
      'oil_type_fg_awal_flowmeter': oilTypeFgAwalFlowmeter,
      'oil_type_fg_akhir_jam': oilTypeFgAkhirJam,
      'oil_type_fg_akhir_flowmeter': oilTypeFgAkhirFlowmeter,
      'oil_type_fg_total': oilTypeFgTotal,
      'oil_type_fg_to_tank': oilTypeFgToTank,
      'bp_awal_jam': bpAwalJam,
      'bp_awal_flowmeter': bpAwalFlowmeter,
      'bp_akhir_jam': bpAkhirJam,
      'bp_akhir_flowmeter': bpAkhirFlowmeter,
      'bp_total': bpTotal,
      'bp_to_tank': bpToTank,
      'be_ref_tank': beRefTank,
      'be_ref_qty': beRefQty,
      'be_total_bag': beTotalBag,
      'be_total_jenis': beTotalJenis,
      'be_lot_batch_number': beLotBatchNumber,
      'be_yield_percent': beYieldPercent,
      'pa_ref_tank': paRefTank,
      'pa_ref_qty': paRefQty,
      'pa_total': paTotal,
      'pa_lot_batch_number': paLotBatchNumber,
      'pa_yield_percent': paYieldPercent,
      'uu_item': uuItem,
      'uu_budget_ref_tank': uuBudgetRefTank,
      'uu_budget_qty': uuBudgetQty,
      'uu_total_cpo': uuTotalCPO,
      'uu_total_steam': uuTotalSteam,
      'uu_steam_cpo': uuSteamCPO,
      'uu_yield_percent': uuYieldPercent,
      'remarks': remarks,
      'flag': flag,
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'verified_by': verifiedBy,
      'verified_date': verifiedDate?.toIso8601String(),
      'verified_status': verifiedStatus,
      'verified_status_remarks': verifiedStatusRemarks,
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
    };
  }
}
