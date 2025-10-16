import 'package:flutter/material.dart';

class DailyProductionRefineryEntity {
  // General Information
  final String id;
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? workCenter;
  final String? shift;
  final String? cpoTank;

  // Raw Material (RM)
  final String? oilTypeRm;
  final TimeOfDay? oilTypeRmAwalJam;
  final int? oilTypeRmAwalFlowmeter;
  final TimeOfDay? oilTypeRmAkhirJam;
  final int? oilTypeRmAkhirFlowmeter;
  final int? oilTypeRmTotal;

  // Finished Goods (FG)
  final String? oilTypeFg;
  final TimeOfDay? oilTypeFgAwalJam;
  final int? oilTypeFgAwalFlowmeter;
  final TimeOfDay? oilTypeFgAkhirJam;
  final int? oilTypeFgAkhirFlowmeter;
  final int? oilTypeFgTotal;
  final String? oilTypeFgToTank;

  // By Product (BP) / PFAD
  final TimeOfDay? bpAwalJam;
  final int? bpAwalFlowmeter;
  final TimeOfDay? bpAkhirJam;
  final int? bpAkhirFlowmeter;
  final int? bpTotal;
  final String? bpToTank;

  // Bleaching Earth (BE)
  final String? beRefTank;
  final String? beRefQty;
  final String? beTotalBag;
  final String? beTotalJenis;
  final int? beLotBatchNumber;
  final double? beYieldPercent;

  // Phosphoric Acid (PA)
  final String? paRefTank;
  final String? paRefQty;
  final String? paTotal;
  final int? paLotBatchNumber;
  final double? paYieldPercent;

  // Remarks & Flag
  final String? remarks;
  final String? flag;

  // Utility Usage (UU)
  final String? uuItem;
  final String? uuBudgetRefTank;
  final String? uuBudgetQty;
  final int? uuTotalCpo;
  final int? uuTotalSteam;
  final String? uuSteamCpo;
  final double? uuYieldPercent;

  // Approval & Tracking
  String? entryBy;
  DateTime? entryDate;
  String? preparedBy;
  DateTime? preparedDate;
  String? preparedStatus;
  String? verifiedBy;
  DateTime? verifiedDate;
  String? verifiedStatus;
  String? checkedBy;
  DateTime? checkedDate;
  String? checkedStatus;
  String? checkedStatusRemarks;

  // Form Information
  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  DailyProductionRefineryEntity({
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
    required this.remarks,
    required this.flag,
    required this.uuItem,
    required this.uuBudgetRefTank,
    required this.uuBudgetQty,
    required this.uuTotalCpo,
    required this.uuTotalSteam,
    required this.uuSteamCpo,
    required this.uuYieldPercent,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.verifiedBy,
    required this.verifiedDate,
    required this.verifiedStatus,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  factory DailyProductionRefineryEntity.fromMap(Map<String, dynamic> map) {
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
      return null;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    TimeOfDay? parseTimeOfDay(dynamic value) {
      if (value == null) return null;
      if (value is String && value.isNotEmpty) {
        final parts = value.split(':');
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      return null;
    }

    return DailyProductionRefineryEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'] as String?,
      shift: map['shift'] as String?,
      cpoTank: map['cpo_tank'] as String?,
      oilTypeRm: map['oil_type_rm'] as String?,
      oilTypeRmAwalJam: parseTimeOfDay(map['oil_type_rm_awal_jam']),
      oilTypeRmAwalFlowmeter: parseInt(map['oil_type_rm_awal_flowmeter']),
      oilTypeRmAkhirJam: parseTimeOfDay(map['oil_type_rm_akhir_jam']),
      oilTypeRmAkhirFlowmeter: parseInt(map['oil_type_rm_akhir_flowmeter']),
      oilTypeRmTotal: parseInt(map['oil_type_rm_total']),
      oilTypeFg: map['oil_type_fg'] as String?,
      oilTypeFgAwalJam: parseTimeOfDay(map['oil_type_fg_awal_jam']),
      oilTypeFgAwalFlowmeter: parseInt(map['oil_type_fg_awal_flowmeter']),
      oilTypeFgAkhirJam: parseTimeOfDay(map['oil_type_fg_akhir_jam']),
      oilTypeFgAkhirFlowmeter: parseInt(map['oil_type_fg_akhir_flowmeter']),
      oilTypeFgTotal: parseInt(map['oil_type_fg_total']),
      oilTypeFgToTank: map['oil_type_fg_to_tank'] as String?,
      bpAwalJam: parseTimeOfDay(map['bp_awal_jam']),
      bpAwalFlowmeter: parseInt(map['bp_awal_flowmeter']),
      bpAkhirJam: parseTimeOfDay(map['bp_akhir_jam']),
      bpAkhirFlowmeter: parseInt(map['bp_akhir_flowmeter']),
      bpTotal: parseInt(map['bp_total']),
      bpToTank: map['bp_to_tank'] as String?,
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
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      uuItem: map['uu_item'] as String?,
      uuBudgetRefTank: map['uu_budget_ref_tank'] as String?,
      uuBudgetQty: map['uu_budget_qty'] as String?,
      uuTotalCpo: parseInt(map['uu_total_cpo']),
      uuTotalSteam: parseInt(map['uu_total_steam']),
      uuSteamCpo: map['uu_steam_cpo'] as String?,
      uuYieldPercent: parseDouble(map['uu_yield_percent']),
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: parseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'] as String?,
      verifiedBy: map['verified_by'] as String?,
      verifiedDate: parseDateTime(map['verified_date']),
      verifiedStatus: map['verified_status'] as String?,
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'] as String?,
      formNo: map['form_no'] as String?,
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: parseDateTime(map['revision_date']),
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    String? formatTimeOfDay(TimeOfDay? time) {
      if (time == null) {
        return null;
      }
      // padLeft ensures that single-digit hours/minutes get a leading zero (e.g., 9 becomes '09')
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute:00'; // We add ':00' for seconds to match the standard TIME format
    }

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
      'oil_type_rm_awal_jam': formatTimeOfDay(oilTypeRmAwalJam),
      'oil_type_rm_awal_flowmeter': oilTypeRmAwalFlowmeter,
      'oil_type_rm_akhir_jam': formatTimeOfDay(oilTypeRmAkhirJam),
      'oil_type_rm_akhir_flowmeter': oilTypeRmAkhirFlowmeter,
      'oil_type_rm_total': oilTypeRmTotal,
      'oil_type_fg': oilTypeFg,
      'oil_type_fg_awal_jam': formatTimeOfDay(oilTypeFgAwalJam),
      'oil_type_fg_awal_flowmeter': oilTypeFgAwalFlowmeter,
      'oil_type_fg_akhir_jam': formatTimeOfDay(oilTypeFgAkhirJam),
      'oil_type_fg_akhir_flowmeter': oilTypeFgAkhirFlowmeter,
      'oil_type_fg_total': oilTypeFgTotal,
      'oil_type_fg_to_tank': oilTypeFgToTank,
      'bp_awal_jam': formatTimeOfDay(bpAwalJam),
      'bp_awal_flowmeter': bpAwalFlowmeter,
      'bp_akhir_jam': formatTimeOfDay(bpAkhirJam),
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
      'remarks': remarks,
      'flag': flag,
      'uu_item': uuItem,
      'uu_budget_ref_tank': uuBudgetRefTank,
      'uu_budget_qty': uuBudgetQty,
      'uu_total_cpo': uuTotalCpo,
      'uu_total_steam': uuTotalSteam,
      'uu_steam_cpo': uuSteamCpo,
      'uu_yield_percent': uuYieldPercent,
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'verified_by': verifiedBy,
      'verified_date': verifiedDate?.toIso8601String(),
      'verified_status': verifiedStatus,
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
    };
  }

  DailyProductionRefineryEntity copyWith({
    String? id,
    String? company,
    String? plant,
    DateTime? transactionDate,
    DateTime? postingDate,
    String? workCenter,
    String? shift,
    String? cpoTank,
    String? oilTypeRm,
    TimeOfDay? oilTypeRmAwalJam,
    int? oilTypeRmAwalFlowmeter,
    TimeOfDay? oilTypeRmAkhirJam,
    int? oilTypeRmAkhirFlowmeter,
    int? oilTypeRmTotal,
    String? oilTypeFg,
    TimeOfDay? oilTypeFgAwalJam,
    int? oilTypeFgAwalFlowmeter,
    TimeOfDay? oilTypeFgAkhirJam,
    int? oilTypeFgAkhirFlowmeter,
    int? oilTypeFgTotal,
    String? oilTypeFgToTank,
    TimeOfDay? bpAwalJam,
    int? bpAwalFlowmeter,
    TimeOfDay? bpAkhirJam,
    int? bpAkhirFlowmeter,
    int? bpTotal,
    String? bpToTank,
    String? beRefTank,
    String? beRefQty,
    String? beTotalBag,
    String? beTotalJenis,
    int? beLotBatchNumber,
    double? beYieldPercent,
    String? paRefTank,
    String? paRefQty,
    String? paTotal,
    int? paLotBatchNumber,
    double? paYieldPercent,
    String? remarks,
    String? flag,
    String? uuItem,
    String? uuBudgetRefTank,
    String? uuBudgetQty,
    int? uuTotalCpo,
    int? uuTotalSteam,
    String? uuSteamCpo,
    double? uuYieldPercent,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? preparedStatus,
    String? verifiedBy,
    DateTime? verifiedDate,
    String? verifiedStatus,
    String? checkedBy,
    DateTime? checkedDate,
    String? checkedStatus,
    String? checkedStatusRemarks,
    String? formNo,
    DateTime? dateIssued,
    int? revisionNo,
    DateTime? revisionDate,
  }) {
    return DailyProductionRefineryEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      workCenter: workCenter ?? this.workCenter,
      shift: shift ?? this.shift,
      cpoTank: cpoTank ?? this.cpoTank,
      oilTypeRm: oilTypeRm ?? this.oilTypeRm,
      oilTypeRmAwalJam: oilTypeRmAwalJam ?? this.oilTypeRmAwalJam,
      oilTypeRmAwalFlowmeter:
          oilTypeRmAwalFlowmeter ?? this.oilTypeRmAwalFlowmeter,
      oilTypeRmAkhirJam: oilTypeRmAkhirJam ?? this.oilTypeRmAkhirJam,
      oilTypeRmAkhirFlowmeter:
          oilTypeRmAkhirFlowmeter ?? this.oilTypeRmAkhirFlowmeter,
      oilTypeRmTotal: oilTypeRmTotal ?? this.oilTypeRmTotal,
      oilTypeFg: oilTypeFg ?? this.oilTypeFg,
      oilTypeFgAwalJam: oilTypeFgAwalJam ?? this.oilTypeFgAwalJam,
      oilTypeFgAwalFlowmeter:
          oilTypeFgAwalFlowmeter ?? this.oilTypeFgAwalFlowmeter,
      oilTypeFgAkhirJam: oilTypeFgAkhirJam ?? this.oilTypeFgAkhirJam,
      oilTypeFgAkhirFlowmeter:
          oilTypeFgAkhirFlowmeter ?? this.oilTypeFgAkhirFlowmeter,
      oilTypeFgTotal: oilTypeFgTotal ?? this.oilTypeFgTotal,
      oilTypeFgToTank: oilTypeFgToTank ?? this.oilTypeFgToTank,
      bpAwalJam: bpAwalJam ?? this.bpAwalJam,
      bpAwalFlowmeter: bpAwalFlowmeter ?? this.bpAwalFlowmeter,
      bpAkhirJam: bpAkhirJam ?? this.bpAkhirJam,
      bpAkhirFlowmeter: bpAkhirFlowmeter ?? this.bpAkhirFlowmeter,
      bpTotal: bpTotal ?? this.bpTotal,
      bpToTank: bpToTank ?? this.bpToTank,
      beRefTank: beRefTank ?? this.beRefTank,
      beRefQty: beRefQty ?? this.beRefQty,
      beTotalBag: beTotalBag ?? this.beTotalBag,
      beTotalJenis: beTotalJenis ?? this.beTotalJenis,
      beLotBatchNumber: beLotBatchNumber ?? this.beLotBatchNumber,
      beYieldPercent: beYieldPercent ?? this.beYieldPercent,
      paRefTank: paRefTank ?? this.paRefTank,
      paRefQty: paRefQty ?? this.paRefQty,
      paTotal: paTotal ?? this.paTotal,
      paLotBatchNumber: paLotBatchNumber ?? this.paLotBatchNumber,
      paYieldPercent: paYieldPercent ?? this.paYieldPercent,
      remarks: remarks ?? this.remarks,
      flag: flag ?? this.flag,
      uuItem: uuItem ?? this.uuItem,
      uuBudgetRefTank: uuBudgetRefTank ?? this.uuBudgetRefTank,
      uuBudgetQty: uuBudgetQty ?? this.uuBudgetQty,
      uuTotalCpo: uuTotalCpo ?? this.uuTotalCpo,
      uuTotalSteam: uuTotalSteam ?? this.uuTotalSteam,
      uuSteamCpo: uuSteamCpo ?? this.uuSteamCpo,
      uuYieldPercent: uuYieldPercent ?? this.uuYieldPercent,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      preparedStatus: preparedStatus ?? this.preparedStatus,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedDate: verifiedDate ?? this.verifiedDate,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      checkedBy: checkedBy ?? this.checkedBy,
      checkedDate: checkedDate ?? this.checkedDate,
      checkedStatus: checkedStatus ?? this.checkedStatus,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
      checkedStatusRemarks: checkedStatusRemarks ?? this.checkedStatusRemarks,
    );
  }
}
