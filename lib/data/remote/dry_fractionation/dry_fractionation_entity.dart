import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';

class DryFractionationEntity {
  final String id;
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? workCenter;
  final String? oilType;

  final String? crystalizer;
  final TimeOfDay? fillingStartTime;
  final TimeOfDay? fillingEndTime;
  final TimeOfDay? collingStartTime;
  final double? initialOilLevel;
  final String? initialTank;
  final double? feedIV;
  final String? agitatorSpeed;
  final double? waterPumpPress;

  final TimeOfDay? crystalStartTime;
  final String? crystalTemp;
  final TimeOfDay? filtrationStartTime;
  final String? filtrationTemp;
  final int? filtrationCycleNo;
  final String? filtrationOilLevel;
  final double? oleinIVRed;
  final double? oleinCloudPoint;
  final double? stearinIV;
  final double? stearinSlepPointRed;
  final double? oleinYield;

  final String? remarks;
  final String? entryBy;
  final DateTime? entryDate;

  final String? preparedBy;
  final DateTime? preparedDate;
  // TODO: prepared status
  // TODO: prepared status remarks

  final String? checkedBy;
  final DateTime? checkedDate;
  // TODO: checked status
  // TODO: checked status remarks

  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  DryFractionationEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.postingDate,
    required this.workCenter,
    required this.oilType,
    required this.crystalizer,
    required this.fillingStartTime,
    required this.fillingEndTime,
    required this.collingStartTime,
    required this.initialOilLevel,
    required this.initialTank,
    required this.feedIV,
    required this.agitatorSpeed,
    required this.waterPumpPress,
    required this.crystalStartTime,
    required this.crystalTemp,
    required this.filtrationStartTime,
    required this.filtrationTemp,
    required this.filtrationCycleNo,
    required this.filtrationOilLevel,
    required this.oleinIVRed,
    required this.oleinCloudPoint,
    required this.stearinIV,
    required this.stearinSlepPointRed,
    required this.oleinYield,
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
  });

  factory DryFractionationEntity.fromMap(Map<String, dynamic> map) {
    return DryFractionationEntity(
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'] as String?,
      oilType: map['oil_type'] as String?,
      crystalizer: map['crystalizer'] as String?,
      fillingStartTime: parseTimeOfDay(map['filling_start_time']),
      fillingEndTime: parseTimeOfDay(map['filling_end_time']),
      collingStartTime: parseTimeOfDay(map['colling_start_time']),
      initialOilLevel: parseDouble(map['initial_oil_level']),
      initialTank: map['initial_tank'],
      feedIV: parseDouble(map['feed_iv']),
      agitatorSpeed: map['agitator_speed'],
      waterPumpPress: parseDouble(map['water_pump_press']),
      crystalStartTime: parseTimeOfDay(map['crystal_start_time']),
      crystalTemp: map['crystal_temp'] as String?,
      filtrationStartTime: parseTimeOfDay(map['filtration_start_time']),
      filtrationTemp: map['filtration_temp'] as String?,
      filtrationCycleNo: parseInt(map['filtration_cycle_no']),
      filtrationOilLevel: map['filtration_oil_level'] as String?,
      oleinIVRed: parseDouble(map['olein_iv_red']),
      oleinCloudPoint: parseDouble(map['olein_cloud_point']),
      stearinIV: parseDouble(map['stearin_iv']),
      stearinSlepPointRed: parseDouble(map['stearin_slep_point_red']),
      oleinYield: parseDouble(map['olein_yield']),
      remarks: map['remarks'] as String?,
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: parseDateTime(map['prepared_date']),
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
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
      'oil_type': oilType,
      'crystalizer': crystalizer,
      'filling_start_time': formatTimeOfDay(fillingStartTime),
      'filling_end_time': formatTimeOfDay(fillingEndTime),
      'colling_start_time': formatTimeOfDay(collingStartTime),
      'initial_oil_level': initialOilLevel,
      'initial_tank': initialTank,
      'feed_iv': feedIV,
      'agitator_speed': agitatorSpeed,
      'water_pump_press': waterPumpPress,
      'crystal_start_time': crystalStartTime,
      'crystal_temp': crystalTemp,
      'filtration_start_time': filtrationStartTime,
      'filtratrion_temp': filtrationTemp,
      'filtration_oil_level': filtrationOilLevel,
      'olein_iv_red': oleinIVRed,
      'olein_cloud_point': oleinCloudPoint,
      'stearin_iv': stearinIV,
      'stearin_slep_point_red': stearinSlepPointRed,
      'olein_yield': oleinYield,
      'remarks': remarks,
      'entry_by': entryBy,
      'entry_date': entryDate,
      'prepared_by': preparedBy,
      'prepared_date': preparedDate,
      'checked_by': checkedBy,
      'checked_date': checkedDate,
      'form_no': formNo,
      'date_issued': dateIssued,
      'revision_no': revisionNo,
      'revision_date': revisionDate,
    };
  }

  DryFractionationEntity copyWith({
    String? id,
    String? company,
    String? plant,
    DateTime? transactionDate,
    DateTime? postingDate,
    String? workCenter,
    String? oilType,
    String? crystalizer,
    TimeOfDay? fillingStartTime,
    TimeOfDay? fillingEndTime,
    TimeOfDay? collingStartTime,
    double? initialOilLevel,
    String? initialTank,
    double? feedIV,
    String? agitatorSpeed,
    double? waterPumpPress,
    TimeOfDay? crystalStartTime,
    String? crystalTemp,
    TimeOfDay? filtrationStartTime,
    String? filtrationTemp,
    int? filtrationCycleNo,
    String? filtrationOilLevel,
    double? oleinIVRed,
    double? oleinCloudPoint,
    double? stearinIV,
    double? stearinSlepPointRed,
    double? oleinYield,
    String? remarks,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? checkedBy,
    DateTime? checkedDate,
    String? formNo,
    DateTime? dateIssued,
    int? revisionNo,
    DateTime? revisionDate,
  }) {
    return DryFractionationEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      workCenter: workCenter ?? this.workCenter,
      oilType: oilType ?? this.oilType,
      crystalizer: crystalizer ?? this.crystalizer,
      fillingStartTime: fillingStartTime ?? this.fillingStartTime,
      fillingEndTime: fillingEndTime ?? this.fillingEndTime,
      collingStartTime: collingStartTime ?? this.collingStartTime,
      initialOilLevel: initialOilLevel ?? this.initialOilLevel,
      initialTank: initialTank ?? this.initialTank,
      feedIV: feedIV ?? this.feedIV,
      agitatorSpeed: agitatorSpeed ?? this.agitatorSpeed,
      waterPumpPress: waterPumpPress ?? this.waterPumpPress,
      crystalStartTime: crystalStartTime ?? this.crystalStartTime,
      crystalTemp: crystalTemp ?? this.crystalTemp,
      filtrationStartTime: filtrationStartTime ?? this.filtrationStartTime,
      filtrationTemp: filtrationTemp ?? this.filtrationTemp,
      filtrationCycleNo: filtrationCycleNo ?? this.filtrationCycleNo,
      filtrationOilLevel: filtrationOilLevel ?? this.filtrationOilLevel,
      oleinIVRed: oleinIVRed ?? this.oleinIVRed,
      oleinCloudPoint: oleinCloudPoint ?? this.oleinCloudPoint,
      stearinIV: stearinIV ?? this.stearinIV,
      stearinSlepPointRed: stearinSlepPointRed ?? this.stearinSlepPointRed,
      oleinYield: oleinYield ?? this.oleinYield,
      remarks: remarks ?? this.remarks,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      checkedBy: checkedBy ?? this.checkedBy,
      checkedDate: checkedDate ?? this.checkedDate,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
    );
  }
}
