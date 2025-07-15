import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'converters.dart';
import '../utils/date_utils.dart';

import 'tables/m_user.dart';
import 'tables/m_business_unit.dart';
import 'tables/m_mastervalue.dart';
import 'tables/t_quality_report_refinery.dart'; // Tetap digunakan

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MUsers,
    MBusinessUnit,
    MMastervalues,
    TQualityReportRefinery, // ✅ Tabel ini tetap digunakan
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8; // ✅ Versi diubah menjadi 8

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.createTable(mMastervalues);
      }
      if (from < 7) {
        await m.createTable(tQualityReportRefinery);
      }
      if (from < 8) {
        await m.deleteTable('t_quality_report');
        await m.deleteTable('t_quality_report_detail');
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'logsheet.sqlite');
    return SqfliteQueryExecutor(path: dbPath, logStatements: true);
  });
}
