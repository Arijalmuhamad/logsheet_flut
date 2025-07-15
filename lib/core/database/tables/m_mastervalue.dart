import 'package:drift/drift.dart';
import '../converters.dart';

class MMastervalues extends Table {
  TextColumn get id => text()(); // UUID (primary key)
  TextColumn get code => text().withLength(min: 1, max: 10)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get group => text().withLength(min: 1, max: 20)();
  IntColumn get number => integer().named('number')();
  TextColumn get isactive => text().withLength(min: 1, max: 1)();
  TextColumn get entryBy =>
      text().named('entry_by').withLength(min: 1, max: 50)();
  //DateTimeColumn get entryDate => dateTime().named('entry_date')();
  TextColumn get entryDate =>
      text().map(const DateTimeTextConverter()).named('entry_date')();

  @override
  Set<Column> get primaryKey => {id};
}
