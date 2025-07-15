import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

/// Converter untuk menyimpan dan mengambil DateTime sebagai format `yyyy-MM-dd`
class DateTimeTextConverter extends TypeConverter<DateTime, String> {
  const DateTimeTextConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb);

  @override
  String toSql(DateTime value) => DateFormat('yyyy-MM-dd').format(value); // hanya tanggal
}

/// Converter untuk menyimpan dan mengambil DateTime sebagai format `yyyy-MM-dd HH:mm:ss`
class DateTimeFullTextConverter extends TypeConverter<DateTime, String> {
  const DateTimeFullTextConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb);

  @override
  String toSql(DateTime value) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(value); // lengkap tanggal & jam
}
