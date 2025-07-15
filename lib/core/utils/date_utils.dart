import 'package:intl/intl.dart';

String getCurrentDateTimeFormatted() {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
