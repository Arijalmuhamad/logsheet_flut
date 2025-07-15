import 'package:drift/drift.dart';

class MUsers extends Table {
  TextColumn get userid => text()();
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get role => text()();
  TextColumn get isactive => text().withLength(min: 1, max: 1)();

  @override
  Set<Column> get primaryKey => {userid};
}
