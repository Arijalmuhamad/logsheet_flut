class QualityReportRefineryEntity {
  // Parameter
  final String id;
  final DateTime reportDate;
  final String time;

  final String? pCat;
  final int? pTankSource;
  final int? pFlowRate;
  final double? pFFA;
  final double? pIV;
  final double? pPV;
  final double? pANV;
  final double? pDobi;
  final double? pCarotene;
  final double? pMNI;
  final String? pColor;

  // Chemical
  final String? cCat;
  final double? cPA;
  final double? cBE;

  // BPO / BPKO
  final String? bCat;
  final int? bColorR;
  final int? bColorY;
  final String? bBreakTest;

  // RPO
  final String? rCat;
  final double? rFFA;
  final int? rColorR;
  final int? rColorY;
  final int? rColorB;
  final int? rPV;
  final int? rMNI;
  final int? rProductTankNo;

  // PFAD
  final double? fpCat;
  final double? fpPurity;
  final int? fpProductTankNumber;

  final String pic;

  // Spent Earth & Remark
  final double? spentEarthOIC;
  final String? remarks;

  final String? checkedBy;
  final DateTime? checkedDate;
  final DateTime? checkedTime;

  final String? approvedBy;
  final DateTime? approvedDate;
  final DateTime? approvedTime;

  final String flag;
  final String? company;
  final String? plant;
  final String? entryBy;
  final DateTime entryDate;

  QualityReportRefineryEntity({
    required this.id,
    required this.reportDate,
    required this.time,
    required this.pCat,
    required this.pTankSource,
    required this.pFlowRate,
    required this.pFFA,
    required this.pIV,
    required this.pPV,
    required this.pANV,
    required this.pDobi,
    required this.pCarotene,
    required this.pMNI,
    required this.pColor,
    required this.cCat,
    required this.cPA,
    required this.cBE,
    required this.bCat,
    required this.bColorR,
    required this.bColorY,
    required this.bBreakTest,
    required this.rCat,
    required this.rFFA,
    required this.rColorR,
    required this.rColorY,
    required this.rColorB,
    required this.rPV,
    required this.rMNI,
    required this.rProductTankNo,
    required this.fpCat,
    required this.fpPurity,
    required this.fpProductTankNumber,
    required this.pic,
    required this.spentEarthOIC,
    required this.remarks,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedTime,
    required this.approvedBy,
    required this.approvedDate,
    required this.approvedTime,
    required this.flag,
    required this.company,
    required this.plant,
    required this.entryBy,
    required this.entryDate,
  });

  factory QualityReportRefineryEntity.fromMap(Map<String, dynamic> map) {
    return QualityReportRefineryEntity(
      id: map['id'] as String,
      reportDate: map['report_date'] as DateTime,
      time: map['time'] as String,
      pCat: map['p_cat'] as String,
      pTankSource: map['p_tank_source'] as int,
      pFlowRate: map['p_flow_rate'] as int,
      pFFA: map['p_ffa'] as double,
      pIV: map['p_iv'] as double,
      pANV: map['p_anv'] as double,
      pDobi: map['p_dobi'] as double,
      pPV: map['p_pv'] as double,
      pCarotene: map['p_carotene'] as double,
      pMNI: map['p_m&i'] as double,
      pColor: map['p_color'] as String,
      cCat: map['c_cat'] as String,
      cPA: map['c_pa'] as double,
      cBE: map['c_be'] as double,
      bCat: map['b_cat'] as String,
      bColorR: map['b_color_r'] as int,
      bColorY: map['b_color_y'] as int,
      bBreakTest: map['b_break_test'] as String,
      rCat: map['r_cat'] as String,
      rFFA: map['r_ffa'] as double,
      rColorR: map['r_color_r'] as int,
      rColorY: map['r_color_y'] as int,
      rColorB: map['r_color_b'] as int,
      rPV: map['r_pv'] as int,
      rMNI: map['r_m&i'] as int,
      rProductTankNo: map['r_product_tank_no'] as int,
      fpCat: map['fp_cat'] as double,
      fpPurity: map['fp_purity'] as double,
      fpProductTankNumber: map['fp_product_tank_number'] as int,
      pic: map['pic'] as String,
      spentEarthOIC: map['spent_earth_oic'] as double,
      remarks: map['remarks'] as String,
      checkedBy: map['check_by'] as String,
      checkedDate: map['checked_date'] as DateTime,
      checkedTime: map['checked_time'] as DateTime,
      approvedBy: map['approved_by'] as String,
      approvedDate: map['approved_date'] as DateTime,
      approvedTime: map['approved_time'] as DateTime,
      flag: map['flag'] as String,
      company: map['company'] as String,
      plant: map['plant'] as String,
      entryBy: map['entry_by'] as String,
      entryDate: map['entry_date'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'report_date': reportDate.toIso8601String(),
      'time': time,
      'p_cat': pCat,
      'p_tank_source': pTankSource,
      'p_flowrate': pFlowRate,
      'p_ffa': pFFA,
      'p_iv': pIV,
      'p_pv': pPV,
      'p_anv': pANV,
      'p_dobi': pDobi,
      'p_carotene': pCarotene,
      'p_m&i': pMNI,
      'p_color': pColor,
      'c_cat': cCat,
      'c_pa': cPA,
      'c_be': cBE,
      'b_cat': bCat,
      'b_color_r': bColorR,
      'b_color_y': bColorY,
      'b_break_test': bBreakTest,
      'r_cat': rCat,
      'r_ffa': rFFA,
      'r_color_r': rColorR,
      'r_color_y': rColorY,
      'r_color_b': rColorB,
      'r_pv': rPV,
      'r_m&i': rMNI,
      'r_product_tank_no': rProductTankNo,
      'fp_cat': fpCat,
      'fp_purity': fpPurity,
      'fp_product_tank_no': fpProductTankNumber,
      'pic': pic,
      'spent_earth_oic': spentEarthOIC,
      'remarks': remarks,
      'checked_by': checkedBy,
      'checked_date': checkedDate,
      'checked_time': checkedTime,
      'approved_by': approvedBy,
      'approved_date': approvedDate,
      'approved_time': approvedTime,
      'flag': flag,
      'company': company,
      'plant': plant,
      'entry_by': entryBy,
      'entry_date': entryDate.toIso8601String(),
    };
  }
}
