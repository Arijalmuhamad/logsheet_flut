// ignore_for_file: avoid_print

import 'sync_result.dart';
import 'sync_quality_service.dart'; // ⬅️ PASTIKAN IMPORT INI ADA

class SyncService {
  static Future<List<SyncResult>> syncAll({String? type}) async {
    print('📤 Mulai syncAll dengan type: $type');
    List<SyncResult> results = [];

    try {
      if (type == 'Semua' || type == 'Quality Report') {
        print('📤 Menjalankan SyncQualityService...');
        final result =
            await SyncQualityService.sync(); // ⬅️ PASTIKAN INI DIPANGGIL
        results.add(result);
      }

      if (type == 'Semua' || type == 'Sortase') {
        results.add(
          SyncResult(
            title: 'Sortase',
            message: 'Belum diimplementasikan.',
            success: false,
          ),
        );
      }
    } catch (e) {
      print('❌ Error saat syncAll: $e');
    }

    print('✅ Selesai syncAll');
    return results;
  }
}
