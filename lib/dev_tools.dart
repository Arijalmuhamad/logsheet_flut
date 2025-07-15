// // dev_tools.dart
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

// Future<void> deleteDatabaseFile() async {
//   final dbFolder = await getApplicationDocumentsDirectory();
//   final dbPath = p.join(dbFolder.path, 'logsheet.sqlite');
//   final file = File(dbPath);
//   if (await file.exists()) {
//     await file.delete();
//     print('🗑️ Database logsheet.sqlite telah dihapus.');
//   }
// }
