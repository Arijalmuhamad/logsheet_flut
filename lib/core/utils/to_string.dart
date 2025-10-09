import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return '-';
  return DateFormat('dd MMM yyyy').format(date);
}

String formatDouble(double? value) {
  if (value == null) return '-';
  return value.toStringAsFixed(2);
}

String formatInt(int? value) {
  return value?.toString() ?? '-';
}
