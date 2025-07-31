class QualityReportRefineryEntity {
  // Parameter
  final String id;
  final DateTime? reportDate;
  final DateTime? time;

  final String? pCat;
  final double? pTankSource;
  final double? pFlowRate;
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
  final double? bColorR;
  final double? bColorY;
  final String? bBreakTest;

  // RPO
  final String? rCat;
  final double? rFFA;
  final double? rColorR;
  final double? rColorY;
  final double? rColorB;
  final double? rPV;
  final double? rMNI;
  final double? rProductTankNo;

  // PFAD
  final double? fpCat;
  final double? fpPurity;
  final double? fpProductTankNumber;

  final String? pic;

  // Spent Earth & Remark
  final double? spentEarthOIC;
  final String? remarks;

  final String? checkedBy;
  final DateTime? checkedDate;
  final DateTime? checkedTime;

  final String? approvedBy;
  final DateTime? approvedDate;
  final DateTime? approvedTime;

  final String? flag;
  final String? company;
  final String? plant;
  final String? entryBy;
  final DateTime? entryDate;

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
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    DateTime? parseDateTime(dynamic value) {
      if (value is String) return DateTime.tryParse(value);
      if (value is DateTime) return value;
      if (value == null) return null;
      return null;
    }

    return QualityReportRefineryEntity(
      id: map['id'] as String,
      reportDate: parseDateTime(map['report_date']),
      time: parseDateTime(map['time']),
      pCat: null,
      pTankSource: parseDouble(map['p_tank_source']),
      pFlowRate: parseDouble(map['p_flow_rate']),
      pFFA: parseDouble(map['p_ffa']),
      pIV: parseDouble(map['p_iv']),
      pPV: parseDouble(map['p_pv']),
      pANV: parseDouble(map['p_anv']),
      pDobi: parseDouble(map['p_dobi']),
      pCarotene: parseDouble(map['p_carotene']),
      pMNI: parseDouble(map['p_m&i']),
      pColor: map['p_color'] as String,
      cCat: null,
      cPA: parseDouble(map['c_pa']),
      cBE: parseDouble(map['c_be']),
      bCat: null,
      bColorR: parseDouble(map['b_color_r']),
      bColorY: parseDouble(map['b_color_y']),
      bBreakTest: map['b_break_test'] as String?,
      rCat: map['r_cat'] as String?,
      rFFA: parseDouble(map['r_ffa']),
      rColorR: parseDouble(map['r_color_r']),
      rColorY: parseDouble(map['r_color_y']),
      rColorB: parseDouble(map['r_color_b']),
      rPV: parseDouble(map['r_pv']),
      rMNI: parseDouble(map['r_m&i']),
      rProductTankNo: parseDouble(map['r_product_tank_no']),
      fpCat: parseDouble(map['fp_cat']),
      fpPurity: parseDouble(map['fp_purity']),
      fpProductTankNumber: parseDouble(map['fp_product_tank_no']),
      spentEarthOIC: parseDouble(map['spent_earth_oic']),
      pic: map['pic'] as String?,
      remarks: map['remarks'] as String?,
      checkedBy: map['check_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedTime: parseDateTime(map['checked_time']),
      approvedBy: map['approved_by'] as String?,
      approvedDate: parseDateTime(map['approved_date']),
      approvedTime: parseDateTime(map['approved_time']),
      flag: map['flag'] as String?,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),

      // pCat: map['p_cat'] as String?,
      // pTankSource: map['p_tank_source'] as double?,
      // pFlowRate: map['p_flowrate'] as double?,
      // pFFA: map['p_ffa'] as double?,
      // pIV: map['p_iv'] as double?,
      // pPV: map['p_pv'] as double?,
      // pANV: map['p_anv'] as double?,
      // pDobi: map['p_dobi'] as double?,
      // pCarotene: map['p_carotene'] as double?,
      // pMNI: map['p_m&i'] as double?,
      // pColor: map['p_color'] as String?,
      // cCat: map['c_cat'] as String?,
      // cPA: map['c_pa'] as double?,
      // cBE: map['c_be'] as double?,
      // bCat: map['b_cat'] as String?,
      // bColorR: map['b_color_r'] as double?,
      // bColorY: map['b_color_y'] as double?,
      // bBreakTest: map['b_break_test'] as String?,
      // rCat: map['r_cat'] as String?,
      // rFFA: map['r_ffa'] as double?,
      // rColorR: map['r_color_r'] as double?,
      // rColorY: map['r_color_y'] as double?,
      // rColorB: map['r_color_b'] as double?,
      // rPV: map['r_pv'] as double?,
      // rMNI: map['r_m&i'] as double?,
      // rProductTankNo: map['r_product_tank_no'] as double?,
      // fpCat: map['fp_cat'] as double?,
      // fpPurity: map['fp_purity'] as double?,
      // fpProductTankNumber: map['fp_product_tank_no'] as double?,
      // spentEarthOIC: map['spent_earth_oic'] as double?,
      // pic: map['pic'] as String?,
      // remarks: map['remarks'] as String?,
      // checkedBy: map['check_by'] as String?,
      // checkedDate: map['checked_date'] as DateTime?,
      // checkedTime: map['checked_time'] as DateTime?,
      // approvedBy: map['approved_by'] as String?,
      // approvedDate: map['approved_date'] as DateTime?,
      // approvedTime: map['approved_time'] as DateTime?,
      // flag: map['flag'] as String?,
      // company: map['company'] as String?,
      // plant: map['plant'] as String?,
      // entryBy: map['entry_by'] as String?,
      // entryDate: map['entry_date'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'report_date': reportDate,
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
      'entry_date': entryDate,
    };
  }
}
