// import 'package:drift/drift.dart';
import 'package:logsheet_app/core/database/app_database.dart';

class BusinessUnitDao {
  final AppDatabase db;

  BusinessUnitDao(this.db);

  Future<List<MBusinessUnitData>> getAllBusinessUnits() {
    return db.select(db.mBusinessUnit).get();
  }

  Future<void> insertBusinessUnit(MBusinessUnitCompanion unit) {
    return db.into(db.mBusinessUnit).insert(unit);
  }

  Future<void> updateBusinessUnit(MBusinessUnitData unit) {
    return db.update(db.mBusinessUnit).replace(unit);
  }

  Future<void> deleteBusinessUnit(String id) {
    return (db.delete(db.mBusinessUnit)
      ..where((tbl) => tbl.id.equals(id))).go();
  }
}
