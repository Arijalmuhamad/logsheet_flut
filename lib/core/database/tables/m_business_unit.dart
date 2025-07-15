import 'package:drift/drift.dart';
import '../converters.dart';

class MBusinessUnit extends Table {
  TextColumn get id => text()(); // UUID (primary key)
  TextColumn get companyCode => text().withLength(min: 1, max: 5)();
  TextColumn get companyName => text().withLength(min: 1, max: 100)();
  TextColumn get plantCode => text().nullable().withLength(max: 5)();
  TextColumn get plantName => text().nullable().withLength(max: 100)();
  TextColumn get isactive => text().withLength(min: 1, max: 1)();
  TextColumn get entryBy =>
      text().named('entry_by').withLength(min: 1, max: 50)();
  // DateTimeColumn get entryDate => dateTime()();
  TextColumn get entryDate =>
      text().map(const DateTimeTextConverter()).named('entry_date')();
  TextColumn get parent => text().withLength(min: 1, max: 1)();

  @override
  Set<Column> get primaryKey => {id};
}
