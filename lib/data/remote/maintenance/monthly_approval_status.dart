import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_approval_entity.dart';

class MonthlyApprovalStatus {
  final bool canApprove;
  final int completedDays;
  final int totalDaysInMonth;

  final Map<DateTime, List<LampsAndGlassApprovalEntity>> dailyChecks;

  MonthlyApprovalStatus({
    required this.canApprove,
    required this.completedDays,
    required this.totalDaysInMonth,
    required this.dailyChecks,
  });

  factory MonthlyApprovalStatus.fromEntityList({
    required int year,
    required int month,
    required List<LampsAndGlassApprovalEntity> allChecks,
  }) {
    int getDaysInMonth(int year, int month) {
      return DateUtils.getDaysInMonth(year, month);
    }

    final Map<DateTime, List<LampsAndGlassApprovalEntity>> groupedData = {};

    // Group all check items by their date.
    for (final check in allChecks) {
      if (check.checkDate != null) {
        final day = DateTime(
          check.checkDate!.year,
          check.checkDate!.month,
          check.checkDate!.day,
        );
        if (groupedData.containsKey(day)) {
          groupedData[day]!.add(check);
        } else {
          groupedData[day] = [check];
        }
      }
    }

    // must modify this code with dynamic value,
    // because the item quantity is from a master value
    int daysWith9Item = 0;
    for (final dayGroup in groupedData.values) {
      if (dayGroup.length == 9) {
        daysWith9Item++;
      }
    }

    final totalDays = getDaysInMonth(year, month);
    final isMonthComplete = daysWith9Item == totalDays;

    log("TOTAL DAYS IN THE CURRENT MONTH: $totalDays");

    return MonthlyApprovalStatus(
      canApprove: isMonthComplete,
      completedDays: daysWith9Item,
      totalDaysInMonth: totalDays,
      dailyChecks: groupedData,
    );
  }
}
