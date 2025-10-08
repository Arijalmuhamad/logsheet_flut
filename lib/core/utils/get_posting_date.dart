DateTime getPostingDate() {
  final DateTime now = DateTime.now();

  final int hour = now.hour;

  if (hour <= 7) {
    final DateTime previousDay = now.subtract(const Duration(days: 1));
    return DateTime(
      previousDay.year,
      previousDay.month,
      previousDay.day,
      previousDay.hour,
      previousDay.minute,
      previousDay.second,
    );
  } else {
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
  }
}
