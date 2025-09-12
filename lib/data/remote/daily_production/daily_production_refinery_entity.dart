import 'package:intl/intl.dart';

class DailyProductionRefineryEntity {
  // General Information
  final String id;
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? refineryMachine;
  final String? shift;
  final String? cpoTank;

  // Raw Material (RM)
  final String? oilTypeRm;
  final String? oilTypeRmAwalJam;
  final int? oilTypeRmAwalFlowmeter;
  final String? oilTypeRmAkhirJam;
  final int? oilTypeRmAkhirFlowmeter;
  final int? oilTypeRmTotal;

  // Finished Goods (FG)
  final String? oilTypeFg;
  final String? oilTypeFgAwalJam;
  final int? oilTypeFgAwalFlowmeter;
  final String? oilTypeFgAkhirJam;
  final int? oilTypeFgAkhirFlowmeter;
  final int? oilTypeFgTotal;
  final String? oilTypeFgToTank;

  // By Product (BP) / PFAD
  final String? bpAwalJam;
  final int? bpAwalFlowmeter;
  final String? bpAkhirJam;
  final int? bpAkhirFlowmeter;
  final int? bpTotal;
  final int? bpToTank;

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

  //  Remarks
  final String? remarks;

  // Utility Usage (UU)
  final String? uuItem;
  final String? uuBudgetRefTank;
  final String? uuBudgetQty;
  final int? uuTotalCpo;
  final int? uuTotalSteam;
  final String? uuSteamCpo;
  final double? uuYieldPercent;

  // Approval & Tracking
  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? verifiedBy;
  final DateTime? verifiedDate;
  final String? verifiedStatus;
  final String? checkedBy;
  final DateTime? checkedDate;
  final String? checkedStatus;

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
    required this.refineryMachine,
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

    return DailyProductionRefineryEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      refineryMachine: map['refinery_machine'],
      shift: map['shift'] as String?,
      cpoTank: map['cpo_tank'] as String?,
      oilTypeRm: map['oil_type_rm'] as String?,
      oilTypeRmAwalJam: parseTime(map['oil_type_rm_awal_jam']).toString(),
      oilTypeRmAwalFlowmeter: parseInt(map['oil_type_rm_awal_flowmeter']),
      oilTypeRmAkhirJam: parseTime(map['oil_type_rm_akhir_jam']).toString(),
      oilTypeRmAkhirFlowmeter: parseInt(map['oil_type_rm_akhir_flowmeter']),
      oilTypeRmTotal: parseInt(map['oil_type_rm_total']),
      oilTypeFg: map['oil_type_fg'] as String?,
      oilTypeFgAwalJam: parseTime(map['oil_type_fg_awal_jam']).toString(),
      oilTypeFgAwalFlowmeter: parseInt(map['oil_type_fg_awal_flowmeter']),
      oilTypeFgAkhirJam: parseTime(map['oil_type_fg_akhir_jam']).toString(),
      oilTypeFgAkhirFlowmeter: parseInt(map['oil_type_rm_akhir_flowmeter']),
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
      remarks: map['remarks'] as String?,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'refinery_machine': refineryMachine,
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
      'remarks': remarks,
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
      'verified_by': verifiedBy,
      'verified_date': verifiedDate?.toIso8601String(),
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
    };
  }
}

///
///CREATE TABLE `t_daily_production_refinery` (
//   `id` varchar(16) NOT NULL COMMENT 'id number',
//   `company` varchar(2) DEFAULT NULL COMMENT 'company',
//   `plant` varchar(4) DEFAULT NULL COMMENT 'plant',
//   `transaction_date` datetime DEFAULT NULL COMMENT 'tanggal transaksi',
//   `posting_date` datetime DEFAULT NULL COMMENT 'Jam 08:00 WIB Hari ini sd Jam 07:00, Esok Hari',
//   `refinery_machine` varchar(10) DEFAULT NULL COMMENT 'mesin refinery',
//   `shift` varchar(1) DEFAULT NULL COMMENT 'Shift',
//   `cpo_tank` varchar(5) DEFAULT NULL COMMENT 'CPO Tank',
//   `oil_type_rm` varchar(10) DEFAULT NULL COMMENT 'CPO/RPA/RPS  - Raw Material',
//   `oil_type_rm_awal_jam` time DEFAULT NULL COMMENT 'Awal Jam',
//   `oil_type_rm_awal_flowmeter` int(11) DEFAULT NULL COMMENT 'Awal Flowmeter',
//   `oil_type_rm_akhir_jam` time DEFAULT NULL COMMENT 'Akhir Jam',
//   `oil_type_rm_akhir_flowmeter` int(11) DEFAULT NULL COMMENT 'Akhir Flowmeter',
//   `oil_type_rm_total` int(11) DEFAULT NULL COMMENT 'Oil Type Total',
//   `oil_type_fg` varchar(10) DEFAULT NULL COMMENT 'RBDPO/RRBDPO/RRPS - Finish Good',
//   `oil_type_fg_awal_jam` time DEFAULT NULL COMMENT 'Awal Jam',
//   `oil_type_fg_awal_flowmeter` int(11) DEFAULT NULL COMMENT 'Awal Flowmeter',
//   `oil_type_fg_akhir_jam` time DEFAULT NULL COMMENT 'Akhir Jam',
//   `oil_type_fg_akhir_flowmeter` int(11) DEFAULT NULL COMMENT 'Akhir Flowmeter',
//   `oil_type_fg_total` int(11) DEFAULT NULL COMMENT 'Oil Type Total',
//   `oil_type_fg_to_tank` varchar(10) DEFAULT NULL COMMENT 'Oil Type FG To Tank',
//   `bp_awal_jam` time DEFAULT NULL COMMENT 'By Product / Product Sampingan / PFAD Jam awal',
//   `bp_awal_flowmeter` int(11) DEFAULT NULL COMMENT 'By Product / Product Sampingan / PFAD Flowmeter',
//   `bp_akhir_jam` time DEFAULT NULL COMMENT 'By Product / Product Sampingan / PFAD Jam akhir',
//   `bp_akhir_flowmeter` int(11) DEFAULT NULL COMMENT 'By Product / Product Sampingan / PFAD Flowmeter',
//   `bp_total` int(11) DEFAULT NULL COMMENT 'By Product / Product Sampingan / PFAD Total',
//   `bp_to_tank` int(11) DEFAULT NULL COMMENT 'By Product / Product Sampingan / PFAD To Tank',
//   `be_ref_tank` varchar(10) DEFAULT NULL COMMENT 'Bleaching Earth Refinery Tank ( 500 / 150 )',
//   `be_ref_qty` varchar(20) DEFAULT NULL COMMENT 'Bleaching Earth Refinery Qty ( 1 bag 1000 Kg )',
//   `be_total_bag` varchar(10) DEFAULT NULL COMMENT 'Total Bag',
//   `be_total_jenis` varchar(10) DEFAULT NULL COMMENT 'Jenis ',
//   `be_lot_batch_number` int(11) DEFAULT NULL COMMENT 'Lot Batch Number',
//   `be_yield_percent` decimal(3,2) DEFAULT NULL COMMENT 'Yield %',
//   `pa_ref_tank` varchar(10) DEFAULT NULL COMMENT 'PHOSPHORIC ACID Ref ( 500/150 )',
//   `pa_ref_qty` varchar(20) DEFAULT NULL COMMENT 'PHOSPHORIC ACID Qty',
//   `pa_total` varchar(10) DEFAULT NULL COMMENT 'Total',
//   `pa_lot_batch_number` int(11) DEFAULT NULL COMMENT 'Lot Batch Number',
//   `pa_yield_percent` decimal(3,2) DEFAULT NULL COMMENT 'Yield %',
//   `remarks` varchar(255) DEFAULT NULL COMMENT 'remarks',
//   `uu_item` varchar(10) DEFAULT NULL COMMENT 'Utility Usage - Item',
//   `uu_budget_ref_tank` varchar(10) DEFAULT NULL COMMENT 'Utility Usage - Budget Ref 500 / 150',
//   `uu_budget_qty` varchar(20) DEFAULT NULL COMMENT 'Utility Usage - Qty',
//   `uu_total_cpo` int(11) DEFAULT NULL COMMENT 'Utility Usage - Total CPO',
//   `uu_total_steam` int(11) DEFAULT NULL COMMENT 'Utility Usage - Total Steam',
//   `uu_steam_cpo` varchar(10) DEFAULT NULL COMMENT 'Utility Usage - Steam CPO',
//   `uu_yield_percent` decimal(3,2) DEFAULT NULL COMMENT 'Utility Usage - Yield %',
//   `entry_by` varchar(50) DEFAULT NULL COMMENT 'nama yang input',
//   `entry_date` datetime DEFAULT NULL COMMENT 'tanggal input',
//   `prepared_by` varchar(50) DEFAULT NULL COMMENT 'Nama Shift Leader',
//   `prepared_date` datetime DEFAULT NULL COMMENT 'Tanggal Prepared',
//   `verified_by` varchar(50) DEFAULT NULL COMMENT 'Nama Dept Head',
//   `verified_date` datetime DEFAULT NULL COMMENT 'Tanggal Checked',
//   `checked_by` varchar(50) DEFAULT NULL COMMENT 'Nama Dept Head',
//   `checked_date` datetime DEFAULT NULL COMMENT 'Tanggal Checked',
//   `form_no` varchar(15) DEFAULT NULL COMMENT 'Form No Cth : F/RFA-002',
//   `date_issued` datetime DEFAULT NULL COMMENT 'Date Issued Form No',
//   `revision_no` int(11) DEFAULT NULL COMMENT 'Revision Form No',
//   `revision_date` datetime DEFAULT NULL COMMENT 'Revision Date Form No',
//   PRIMARY KEY (`id`) USING BTREE
// ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
