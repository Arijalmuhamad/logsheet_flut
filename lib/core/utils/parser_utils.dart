import 'package:flutter/material.dart';

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

String? formatTimeOfDay(TimeOfDay? time) {
  if (time == null) {
    return null;
  }
  // padLeft ensures that single-digit hours/minutes get a leading zero (e.g., 9 becomes '09')
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute:00'; // We add ':00' for seconds to match the standard TIME format
}
