import 'package:intl/intl.dart';

String formatNullableDateTime(DateTime? dt) {
  if (dt == null) return '-';
  return DateFormat('dd MMMM yyyy, HH:mm').format(dt);
}
