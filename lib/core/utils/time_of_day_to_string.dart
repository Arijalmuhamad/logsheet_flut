import 'package:flutter/material.dart';

String displayTime(TimeOfDay? time) {
  if (time == null) return "-";
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
