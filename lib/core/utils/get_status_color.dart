import 'package:flutter/material.dart';

Color getStatusColor(dynamic report) {
  if (report.checkedStatus == "Approved") {
    return Colors.green;
  }

  if (report.checkedStatus == "Rejected") {
    return Colors.red;
  }

  if (report.preparedStatus == "Approved") {
    return Colors.orangeAccent;
  }

  if (report.preparedStatus == "Rejected") {
    return Colors.red;
  }
  return Colors.grey;
}
