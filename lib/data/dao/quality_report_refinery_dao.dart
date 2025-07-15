import 'package:drift/drift.dart' as drift;
import 'package:logsheet_app/core/database/app_database.dart';

class QualityReportRefineryDao {
  final AppDatabase db;

  QualityReportRefineryDao(this.db);

  Future<List<TQualityReportRefineryData>> getAllQualityReportsRefinery() {
    return db.select(db.tQualityReportRefinery).get();
  }

  Future<void> insertQualityReportRefinery(
    TQualityReportRefineryCompanion unit,
  ) {
    return db.into(db.tQualityReportRefinery).insert(unit);
  }

  Future<void> updateQualityReportRefinery(TQualityReportRefineryData unit) {
    return db.update(db.tQualityReportRefinery).replace(unit);
  }

  Future<void> deleteQualityReportRefinery(String id) async {
    await (db.delete(db.tQualityReportRefinery)
      ..where((tbl) => tbl.id.equals(id))).go();
  }

  // Ambil data yang belum terkirim (flag == 'T')
  Future<List<TQualityReportRefineryData>> getUnsentReports() {
    return (db.select(db.tQualityReportRefinery)
      ..where((tbl) => tbl.flag.equals('T'))).get();
  }

  // Tandai sebagai sudah terkirim (ubah flag ke 'F')
  Future<void> updateFlag(String id, String flag) async {
    await (db.update(db.tQualityReportRefinery)..where(
      (tbl) => tbl.id.equals(id),
    )).write(TQualityReportRefineryCompanion(flag: drift.Value(flag)));
  }
}
