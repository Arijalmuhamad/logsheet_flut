import 'package:drift/drift.dart';
import 'package:logsheet_app/core/database/app_database.dart';

class MastervalueDao {
  final AppDatabase db;

  MastervalueDao(this.db);

  // Ambil semua data
  Future<List<MMastervalue>> getAllMastervalues() {
    return db.select(db.mMastervalues).get();
  }

  // Ambil data berdasarkan ID (optional)
  Future<MMastervalue?> getMastervalueById(String id) {
    return (db.select(db.mMastervalues)
      ..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Insert data baru
  Future<int> insertMastervalue(MMastervaluesCompanion data) {
    return db.into(db.mMastervalues).insert(data);
  }

  // Update data berdasarkan ID
  Future<void> updateMastervalue(MMastervalue data) {
    return db.update(db.mMastervalues).replace(data);
  }

  // Delete data berdasarkan ID
  Future<int> deleteMastervalue(String id) {
    return (db.delete(db.mMastervalues)..where((t) => t.id.equals(id))).go();
  }

  // Get Tank
  Future<List<MMastervalue>> getActiveTanks() {
    return (db.select(db.mMastervalues)..where(
      (tbl) =>
          Expression.and([tbl.group.equals('TANK'), tbl.isactive.equals('T')]),
    )).get();
  }

  // Get Part
  Future<List<MMastervalue>> getActiveParts() {
    return (db.select(db.mMastervalues)..where(
      (tbl) =>
          Expression.and([tbl.group.equals('PART'), tbl.isactive.equals('T')]),
    )).get();
  }

  // Get Component (Lamps & glass)
  Future<List<MMastervalue>> getActiveComponents() {
    return (db.select(db.mMastervalues)..where(
      (tbl) => Expression.and([
        tbl.group.like('%component%'),
        tbl.isactive.equals('T'),
      ]),
    )).get();
  }
}
