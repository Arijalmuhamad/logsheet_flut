import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';

class DailyQualityCompositeFractionationEntity {
  // General Information
  final String id;
  final String? workCenter;
  final TimeOfDay? time;
  final DateTime? transactionDate;
  final String? crystalizer;

  // Raw Material (RM)
  final double? rmMni;
  final double? rmIv;
  final double? rmColorR;
  final double? rmColorY;
  final double? rmColorW;
  final double? rmColorB;

  // Finished Goods (FG)
  final double? fgFfa;
  final double? fgMni;
  final double? fgIv;
  final double? fgColorR;
  final double? fgColorY;
  final double? fgColorW;
  final double? fgColorB;
  final double? fgCp;
  final String? fgClarity;
  final String? fgToTank;

  // By Product (BP) / PFAD
  final double? bpFfa;
  final double? bpMni;
  final double? bpIv;
  final double? bpPv;
  final double? bpColorR;
  final double? bpColorY;
  final double? bpColorW;
  final double? bpColorB;
  final String? bpToTank;

  final String? remarks;
  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? checkedBy;
  final DateTime? checkedDate;
  final String? checkedStatus;
  final String? checkedStatusRemarks;
  final String? updatedBy;
  final DateTime? updatedDate;
  final String? formNo;
  final DateTime? dateIssued;
  final String? revisionNo;
  final DateTime? revisionDate;

  DailyQualityCompositeFractionationEntity({
    required this.id,
    required this.transactionDate,
    required this.workCenter,
    required this.time,
    required this.crystalizer,
    required this.rmMni,
    required this.rmIv,
    required this.rmColorR,
    required this.rmColorY,
    required this.rmColorW,
    required this.rmColorB,
    required this.fgFfa,
    required this.fgMni,
    required this.fgIv,
    required this.fgColorR,
    required this.fgColorY,
    required this.fgColorW,
    required this.fgColorB,
    required this.fgCp,
    required this.fgClarity,
    required this.fgToTank,
    required this.bpFfa,
    required this.bpMni,
    required this.bpIv,
    required this.bpPv,
    required this.bpColorR,
    required this.bpColorY,
    required this.bpColorW,
    required this.bpColorB,
    required this.bpToTank,
    required this.preparedStatusRemarks,
    required this.updatedBy,
    required this.updatedDate,
    required this.remarks,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });

  factory DailyQualityCompositeFractionationEntity.fromMap(
    Map<String, dynamic> map,
  ) {
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

    return DailyQualityCompositeFractionationEntity(
      id: map['id'].toString(),
      transactionDate: parseDateTime(map['transaction_date']),
      time: parseTimeOfDay(map['time']),
      crystalizer: map['crystalizer'],
      workCenter: map['work_center'],

      // Raw Material
      rmMni: parseDouble(map['rm_mni']),
      rmIv: parseDouble(map['rm_iv']),
      rmColorR: parseDouble(map['rm_color_r']),
      rmColorY: parseDouble(map['rm_color_y']),
      rmColorW: parseDouble(map['rm_color_w']),
      rmColorB: parseDouble(map['rm_color_b']),

      // Finished Goods
      fgFfa: parseDouble(map['fg_ffa']),
      fgMni: parseDouble(map['fg_mni']),
      fgIv: parseDouble(map['fg_iv']),
      fgColorR: parseDouble(map['fg_color_r']),
      fgColorY: parseDouble(map['fg_color_y']),
      fgColorW: parseDouble(map['fg_color_w']),
      fgColorB: parseDouble(map['fg_color_b']),
      fgCp: parseDouble(map['fg_cp']),
      fgClarity: map['fg_clarity'],
      fgToTank: map['fg_to_tank'],

      // By Product / PFAD
      bpFfa: parseDouble(map['bp_ffa']),
      bpMni: parseDouble(map['bp_mni']),
      bpIv: parseDouble(map['bp_iv']),
      bpPv: parseDouble(map['bp_pv']),
      bpColorR: parseDouble(map['bp_color_r']),
      bpColorY: parseDouble(map['bp_color_y']),
      bpColorW: parseDouble(map['bp_color_w']),
      bpColorB: parseDouble(map['bp_color_b']),
      bpToTank: map['bp_to_tank'],

      // General info
      remarks: map['remarks'],
      flag: map['flag'],
      entryBy: map['entry_by'],
      entryDate: parseDateTime(map['entry_date']),

      preparedBy: map['prepared_by'],
      preparedDate: parseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'],
      preparedStatusRemarks: map['prepared_status_remarks'],

      checkedBy: map['checked_by'],
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'],
      checkedStatusRemarks: map['checked_status_remarks'],

      updatedBy: map['updated_by'],
      updatedDate: parseDateTime(map['updated_date']),

      formNo: map['form_no'],
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: map['revision_no'],
      revisionDate: parseDateTime(map['revision_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_date': transactionDate,
      'time': formatTimeOfDay(time),
      'crystalizer': crystalizer,
      'work_center': workCenter,

      // RM (Raw Material)
      'rm_mni': rmMni,
      'rm_iv': rmIv,
      'rm_color_r': rmColorR,
      'rm_color_y': rmColorY,
      'rm_color_w': rmColorW,
      'rm_color_b': rmColorB,

      // FG (Finished Goods)
      'fg_ffa': fgFfa,
      'fg_mni': fgMni,
      'fg_iv': fgIv,
      'fg_color_r': fgColorR,
      'fg_color_y': fgColorY,
      'fg_color_w': fgColorW,
      'fg_color_b': fgColorB,
      'fg_cp': fgCp,
      'fg_clarity': fgClarity,
      'fg_to_tank': fgToTank,

      // BP (By Product)
      'bp_ffa': bpFfa,
      'bp_mni': bpMni,
      'bp_iv': bpIv,
      'bp_pv': bpPv,
      'bp_color_r': bpColorR,
      'bp_color_y': bpColorY,
      'bp_color_w': bpColorW,
      'bp_color_b': bpColorB,
      'bp_to_tank': bpToTank,

      // General fields
      'remarks': remarks,
      'flag': flag,
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),

      // Prepared
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,

      // Checked
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,

      // Updated
      'updated_by': updatedBy,
      'updated_date': updatedDate?.toIso8601String(),

      // Document meta
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
    };
  }
}
